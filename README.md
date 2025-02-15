# zoomcamp2025

Personal repository to follow Data Engineering Zoomcamp 2025 Cohort.
It contains personal notes,homework and files created during the course.

Original repo available at: [data-engineering-zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)

ACtivate Poetry environment: `.\.venv\Scripts\activate`

Other relevant links:
[Course page DE Zoomcamp 2025](https://courses.datatalks.club/de-zoomcamp-2025/)
[Taxi Trips Data Home page](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)


For DBT project in 04-analytics-engineering/taxi_rides_ny:

The `profiles.yml` file is located in the root of the project. Create one with the following content:

```yaml
default:
  target: dev ##By default, dbt will use the dev profile. Execute dbt run --target=prod to use the prod profile.
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: angular-rhythm-450212-n4  # Your GCP project ID
      dataset: zoomcamp_dbt_core             # Your BigQuery dataset
      threads: 4
      timeout_seconds: 300
      location: 'europe-west2'  # Your dataset's location
      priority: interactive
      keyfile: Path to the service account key file json
    prod:
      type: bigquery
      method: service-account
      project: angular-rhythm-450212-n4
      dataset: zoomcamp_dbt_core_prod
      threads: 4
      timeout_seconds: 300
      location: 'europe-west2'
      priority: interactive
      keyfile: Path to the service account key file json
```

By default, dbt uses the profiles.yml in `/Users/username/.dbt/profiles.yml`
