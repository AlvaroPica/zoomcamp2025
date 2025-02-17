-- Select from green_tripdata where filename contains 2019 or 2020
SELECT *
FROM `zoomcamp.green_tripdata`
WHERE filename LIKE '%2019%' OR filename LIKE '%2020%';

-- Create a new table in zoomcamp_dbt with filtered green_tripdata
CREATE OR REPLACE TABLE `zoomcamp_dbt.green_tripdata` AS
SELECT *
FROM `zoomcamp.green_tripdata`
WHERE filename LIKE '%2019%' OR filename LIKE '%2020%';

-- Select from yellow_tripdata where filename contains 2019 or 2020
SELECT *
FROM `zoomcamp.yellow_tripdata`
WHERE filename LIKE '%2019%' OR filename LIKE '%2020%';

-- Create a new table in zoomcamp_dbt with filtered yellow_tripdata
CREATE OR REPLACE TABLE `zoomcamp_dbt.yellow_tripdata` AS
SELECT *
FROM `zoomcamp.yellow_tripdata`
WHERE filename LIKE '%2019%' OR filename LIKE '%2020%'; 