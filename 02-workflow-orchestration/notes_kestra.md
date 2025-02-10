

# Check set up is OK.

Data is coming from [Taxi Data in Github](https://github.com/DataTalksClub/nyc-tlc-data/releases)

Once you have run `docker compose up -d` verify everthing is fine:

1) Check Kestra container can see Posgres:

- Jump into Kestra container: `docker exec -it 612e68257987 bash` (From Git Bash you might need to use `winpty docker exec -it 612e68257987 bash`)
- Install postgres in the container `apt update && apt install -y postgresql-client`
- Connect to the Database in the other container: `psql -h postgres -U kestra -d kestra`
- Check tables with `\dt` and run a `select 1` query check.

2) Check you can access the database in your laptop

- From any SQL client create a connection: 
  - Host: localhost
  - Database: kestra
  - user: kestra
  - pass: k3str4

**Important**: Understand that from local machine we use `host=localhost` but from the kestra container we must use the name of the container managing the database (in this case `postgres`)

3) Run an easy Flow in Kestra to create a table in the database:

This is the test job you can use:

```bash
id: test_sql_database
namespace: zoomcamp

tasks:
  - id: hello
    type: io.kestra.plugin.core.log.Log
    message: Hello World! 🚀

  - id: green_create_staging_table
    type: io.kestra.plugin.jdbc.postgresql.Queries
    sql: |
      CREATE TABLE IF NOT EXISTS public.test_manolito (
          foo          text,
          bar               text,
      );

pluginDefaults:
  - type: io.kestra.plugin.jdbc.postgresql
    values:
      #url: jdbc:postgresql://host.docker.internal:5432/postgres-zoomcamp
      url: jdbc:postgresql://postgres:5432/kestra
      username: kestra
      password: k3str4
```

We had to change the host from `host.docker.internal` for the reason commented in point (1)

4) From the host machine SQL cliente check visually that the table `test_manolito` have been created and rop it manually.

## Render variable expressions

When doing recursive expression, that is calling a string that has an expression in it, you need to explicitily tell it to render it too.

`staging_table: "public.{{inputs.taxi}}_tripdata_staging"`
 
 `CREATE TABLE IF NOT EXISTS {{render(vars.staging_table)}}`

If we do not use the render() function we would recieve the string as we see it right know, without the dynamic value inside, leading to a fail.

## Plug-in Defaults

Allows to set 



## Adding a Unique line ID

To add a unique line ID we use a md5 hash that depends on the value of some key columns. This ensures we will not have duplicates. With other random hashing methods this could not be ensured.

In the case of green taxi we use this function:

```bash
unique_row_id = md5(
        VendorID ||
        COALESCE(CAST(lpep_pickup_datetime AS text), '') || 
        COALESCE(CAST(lpep_dropoff_datetime AS text), '') || 
        COALESCE(PULocationID, '') || 
        COALESCE(DOLocationID, '') || 
        COALESCE(CAST(fare_amount AS text), '') || 
        COALESCE(CAST(trip_distance AS text), '')      
    )
```

**Important**: This hashing methodology only works with all non-nullable columns. If there are NULLs in any column this will fail.

In the example above the VendorID NULLs will lead to errors. To fix this a COALESCE is also applied:

```bash
unique_row_id = md5(
        COALESCE(CAST(VendorID AS text), '') ||
        COALESCE(CAST(lpep_pickup_datetime AS text), '') || 
        COALESCE(CAST(lpep_dropoff_datetime AS text), '') || 
        COALESCE(PULocationID, '') || 
        COALESCE(DOLocationID, '') || 
        COALESCE(CAST(fare_amount AS text), '') || 
        COALESCE(CAST(trip_distance AS text), '')      
    )
```

This examples 

## Conditionals

You can add a specific condition for a given task as in:

```bash
  - id: green_create_staging_table
    type: io.kestra.plugin.jdbc.postgresql.Queries
    runIf: "{{ inputs.taxi == 'green' }}"
    sql: |
      CREATE TABLE IF NOT EXISTS public.test_manolito (
          foo          text,
          bar               text,
      );
```

Or create a `if` statemente and group many task within that part of the code:

```bash

id: if_green_taxi
type: io.kestra.plugin.core.flow.If
condition: "{{inputs.taxi == 'green'}}"
then:
        - id: green_create_table
            type: io.kestra.plugin.jdbc.postgresql.Queries
            sql: |
            CREATE TABLE IF NOT EXISTS {{render(vars.table)}} (
            ....
        - id: another_task_under_the_if_group
            type: ...
- id: another_task_out_of_the_group
```

## Tags

We can add a set_label tasks at the beginning to then within the "Execution" check the values of variables in the logs.

``` bash
id: set_label
type: io.kestra.plugin.core.execution.Labels
labels:
file: "{{render(vars.file)}}"
taxi: "{{inputs.taxi}}"
```

## Triggers

```bash
triggers:
  - id: green_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 9 1 * *"
    inputs:
      taxi: green
```

The cron expressions referes to:

minute hour day(month) month day(week)

In the example that would be: *Every month on the first at 9:00 am.*

More details about cron schedule expressions: [crontab guru](https://crontab.guru/)

Then the value of the data can be referred within the job as in:

```bash
variables:
  file: "{{inputs.taxi}}_tripdata_{{trigger.date | date('yyyy-MM')}}.csv"
  data: "{{outputs.extract.outputFiles[inputs.taxi ~ '_tripdata_' ~ (trigger.date | date('yyyy-MM')) ~ '.csv']}}"
  ```

When there is not Flow in the Kestra flow we do not usee `trigger.date` but directly `input.date` (In our examples actually we used `input.year` and `input.month`). Having the flow depending on triggers means if they execute manually they will not work.

## Schedules & Backfill

Backfill execution: Go back in Time and execute all the missing dates.

It is important for backfilling considering for the last run to be after the `next execution date`. If it is before, then it will not reach.

In Execution labels we can write *Backfill* to be able to differentiate between executions that happened in *real-time* or in *backfill*.

### Schedules



## Other considerations

When working with monthly data we first load to staging and then merge to production table.

We only have one staging table and we work with concurrency=1, meaning there will not be processes in parallel writing to the same staging table.

We could dynamically create the staging table so each month iteration uses a dedicated staging table and no issues can occur because multiple process were writting and operaitng on the single table.

Issue: Too many tables in staging would be created. You can drop as a fix.

## DBT in Kestra

Module 4

## Set up GCP to work with Kestra

### Key-Vale Store (kv store)

Store where safely store credentials.
Within a Namespace you can store specific key-valur pairs to be used later.
Similar to environment variables when running code locally.
We will be able to access these values in the workflows and update them.
We will never see them directly during the workflow to not show sensitive information.

With a servie account credentials json we downloaded from GCP we create a new kv pair in Kestra UI:

Value: Paste the json
Key: GCP_CREDS

There is a dedicated Kestra flow to create the KV pairs in file `04_gcp_kv`

However, for security reassons the GCP_CREDS must be added manually through UI to avoid pushing credentials to a repository.

Parameters:

- serviceAccount: "{{kv('GCP_CREDS')}}"
- projectId: "{{kv('GCP_PROJECT_ID')}}"
- location: "{{kv('GCP_LOCATION')}}"
- bucket: "{{kv('GCP_BUCKET_NAME')}}"
- dataset:  "{{kv('GCP_DATASET')}}"

To create the dataset and the bucket we can use the Terraform we studied last lesson or use a dedicated kestra flow for that purpose in `05_gcp_setup.yaml` that will create the resources accoding to the KV we have just created.


### Adding data strategy

- Download CSV and upload to Google Cloud Bucket
- Create a temporal table to put the data in Bigquery dataset: `my_data_202401_ext`
- Create a temporal table to put the data with a unique id and ensure no duplicates: `my_data_202401`
- Add the data to the production table to join other months data: `my_data`