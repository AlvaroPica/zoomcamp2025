# Solution Homework 3

## Question 1

The condition added to the stg models related to the filter on variable `is_test_run` has the following effect:

- If `is_test_run` is set to `true` (default), then only 100 rows are processed.
- If `is_test_run` is set to `false`, then the full dataset is processed.
- If not specified, the default value is `true` and the number of rows processed is 100.

## Question 2

The CI will run with...

## Question 3

First we have run a Kestra Flow to download the data from the source and load it into BigQuery.

For that purpose we have adapted the given 06_gcp_taxi_scheduled.yml to a renamed
`06_gcp_taxi_fhv_included_scheduled`

We have added an if block to consider the FHV case and we adapted the DDL for the schemas in BigQuery.

The  model `fhv_trips` that gathers all the year months was put in the same RAW dataset than the previous `yellow` and `green` models.

From there a new `stg_fhv_trips` model was created to have the FHV data in the STAGING area. This model is built with --vars 'is_test_run: false' to avoid running into the limit of 100 rows. A filter to keep only the year 2019 was added.

From this point we have followed the instructions given in the homework to build the `fact_fhv_trips` model considering only the records with known pickup and dropoff zones.

The final model has a total of **22,998,722** records.

## Question 4

To do
