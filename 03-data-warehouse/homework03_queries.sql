-- Setup
CREATE OR REPLACE EXTERNAL TABLE `angular-rhythm-450212-n4.zoomcamp_hw3.external_yellow_tripdata_2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://angular-rhythm-450212-n4-kestra-bucket/yellow_tripdata_*.parquet']
);

CREATE OR REPLACE TABLE `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024`
AS SELECT * FROM `angular-rhythm-450212-n4.zoomcamp_hw3.external_yellow_tripdata_2024`;

SELECT count(*) FROM `angular-rhythm-450212-n4.zoomcamp_hw3.external_yellow_tripdata_2024`;

--Question 2
select (distinct PULocationID) from `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024`;

-- Question 3
select PULocationID from `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024` -- Scans 155MB
select PULocationID, DOLocationID from `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024` -- Scans 310MB

-- Question 4
select count(1)
 from `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024`
 where fare_amount = 0


-- Question 5
create or replace table `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024_optimized`
partition by date(tpep_dropoff_datetime)
cluster by VendorID as (
  select * from `angular-rhythm-450212-n4.zoomcamp_hw3.exteneral_yellow_tripdata_2024`
)

-- Question 6
SELECT count(*) FROM  `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024_optimized`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT distinct VendorID FROM  `angular-rhythm-450212-n4.zoomcamp_hw3.yellow_tripdata_2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

