
# Data Engineering Zoomcamp 2025

## Docker

Test Docker is running OK in your machine

`docker run hello-work`

Run a fresh container from the image `ubuntu` with a parameter:

`docker run -it ubuntu bash`

Adding bash in this image will run the container and we can type from the bash within it (e.g. You could type `ls`)

Another example:

Run a container with image python:3.9, directly goes to python (>>> ) with no dependencies installed.

`docker run -it python:3.9`

To install something:

`docker run -it --entrypoint=bash python:3.9`

This will run the container with the python installed but will go directly to bash so we can install dependencies (e.g. `pip install pandas`) and then go to python prompt with `python`

`--entrypoint` is what is executed first thing after running the container.

### Directly install some dependencies

To directly run commands in the container  `Dockerfile` are used to create an image with instructions.

```bash
FROM python:3.9

RUN pip install pandas

ENTRYPOINT [ "bash" ]
```

To build the use the command `build` and give a name to the *image* we are creating. The `.` indicates to look for the Docker file in this directory.

`docker build -t test:panads .`

To run: `docker run -it test:pandas`

## Copy files from host to the container

```bash
FROM python:3.9

RUN pip install pandas

WORKDIR /app # This is the directoy we will work in the container. In this case where they file is copied to.
COPY pipeline.py pipeline.py

# ENTRYPOINT [ "bash" ] This would open the bash in the container.
ENTRYPOINT[ "python", "pipeline.py"]` # This runs the container and directly runs the python pipeline.py command.
```

## Parameters in docker

To pass arguments when running the docker container directly add them after the image name as in the following example, where the date is passed as an argument.

`docker run -it test:pandas 2021-01-01`

In this case the sys.args would be `[pipeline.py, "2021-01.01"]`

```bash
docker run -it \
    -e POSTGRES_USER=root \
    -e POSTGRES_PASSWORD=root \
    -e POSTGRES_DB=ny_taxi \
    -v c:/workspace/alvaro_NAS_home/workspace_cloud/data_expert/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:13
```

 As we have used **volumes** (bound) the data will be persisted even when closing the container.
With this we can access the database  within the **container** from the **host**. We could use `pgcli` python package or psql directly.

`pgcli -h localhost -p 5432 -u root -d ny_taxi`

We can run pgAdmin as SQL client to access the database also using a Docker container:

```bash
docker run -it \
    -e PG_ADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PG_ADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    dbpage/pgadmin4 # Name of the image
```

From within the `pgAdmin` container we cannot use `localhost` as the`postgres` container is not within that container, is in another container.

To connect to the database from the pgAdmin container we need to link them. For that purpose we use **networks** and we give names to the containers.

We need to create the network first:

```bash
docker network create pg-network
```

Then we tell the containers to use that network with a parameter:

```bash
docker run -it \
    -e POSTGRES_USER=root \
    -e POSTGRES_PASSWORD=root \
    -e POSTGRES_DB=ny_taxi \
    -v c:/workspace/alvaro_NAS_home/workspace_cloud/data_expert/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \ # This is the name pgAdmin will need to connect to the database
    postgres:13
```

```bash
docker run -it \
    -e PG_ADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PG_ADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
    --name pg-admin \ # Here the name is not that much important
    dbpage/pgadmin4 # Name of the image
```

### Other docker commands

To check what is running: `docker ps`
kill a giving container: `docker kill container_id`

## Pipeline

From localhost:

```bash
python ingest_data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --table_name=homework_green_tripdata \
    --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```

From the other container it would fail because of the `localhost`

From container:

```bash
FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqalchemy pyscopg2

WORKDIR /app # This is the directoy we will work in the container. In this case where they file is copied to.
COPY ingest_data.py ingest_data.py

# ENTRYPOINT [ "bash" ] This would open the bash in the container.
ENTRYPOINT[ "python", "ingest_data.py"]` # This runs the container and directly runs the python pipeline.py command.
```

`docker build -t taxi_ingest:v001 .`

```bash
docker run -it 
    --network=pg-network \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pg-database \ # Important to change this as the connection will come from the other container, no the host machine
        --port=5432 \
        --db=ny_taxi \
        --table_name=homework_green_tripdata \
        --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```

It is important to remark the difference in the parameters:

- Parameters to Docker: Before the name of the image.
- Paramters to our job: After the name of the image.
  
The --network parameter is for developing purpose and local testing. In real life scenario instead of using `pg-database` pointing to a local database we would use a url pointing to some database in a cloud service.

Sometime we might want to create a volume independently prior to run a container as in:

`docker volume create --name dtc_postgres_volume_local -d local`

And run the container as in:

```bash
docker run -it \
    -e POSTGRES_USER=root \
    -e POSTGRES_PASSWORD=root \
    -e POSTGRES_DB=ny_taxi \
    -v dtc_postgres_volume_local:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \
    postgres:13
```

## Docker compose

These example of running containers separately is for learning, in production we would use docker compose files, which allows to have multiple services or containers in a single configuration file.

```bash
services:
  pgdatabase: # Name of the service
    image: postgres:13
    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi
    volumes:
      - "./ny_taxi_postgres_data:/var/lib/postgresql/data:rw" # In Docker compose we do not neet to write de full path as in the run command.
    ports:
      - "5432:5432"
  pgadmin:
    image: dpage/pgadmin4
    environment:
      - PGADMIN_DEFAULT_EMAIL=admin@admin.com
      - PGADMIN_DEFAULT_PASSWORD=root
    ports:
      - "8080:80"
    # We might want also volumes in this service to keep the configuration in pgAdmin instead of having to write the connection everytime we run the container.
    # We do not need to specify the network, they will use the same network automaticalle when using docker compose.
```

`docker compose up`: Check logs and so on, console will not be able to be used.
`docker compose up -d` : Run in detached mode, you will be able to use the console you run the command in.
`docker compose down`: Shut everything down.

### Other considerations

python -m http.server

Will launch a server in localhost:8000/ shwoing the current dir content and being able to request a CSV as to an URL. To use from the container we cannot use localhost but the actual IP of the host machine by typing ipcong and checking the IPv4 address.

## Terraform

Places where your code can live and your software can run
