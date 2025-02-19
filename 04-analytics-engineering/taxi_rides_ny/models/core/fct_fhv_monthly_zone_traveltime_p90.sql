{{ config(
    materialized='table'
) }}

with fhv_trips as (
    select * from {{ ref('fact_fhv_trips') }}
),

fhv_trips_with_duration as (
    select 
        tripid,
        dispatching_base_num,
        pickup_datetime,
        extract(year from pickup_datetime) as year,
        extract(month from pickup_datetime) as month,
        dropoff_datetime,
        TIMESTAMP_DIFF(
            cast(dropoff_datetime as timestamp),
            cast(pickup_datetime as timestamp),
            SECOND
        ) as trip_duration,
        pickup_zone,
        dropoff_zone
    from fhv_trips
    --where 
    --    dropoff_datetime is not null 
    --    and pickup_datetime is not null
),

monthly_percentiles as (
    select 
        year,
        month,
        pickup_zone,
        dropoff_zone,
        PERCENTILE_CONT(trip_duration, 0.90) OVER (
            PARTITION BY year, month, pickup_zone, dropoff_zone
        ) as p90_trip_duration,
        count(1) over (partition by year, month, pickup_zone, dropoff_zone) as trip_count
    from fhv_trips_with_duration
)

select distinct
    year,
    month,
    pickup_zone,
    dropoff_zone,
    round(p90_trip_duration, 0) as p90_trip_duration,
    trip_count
from monthly_percentiles
--where year = 2019
order by year, month, pickup_zone, dropoff_zone
