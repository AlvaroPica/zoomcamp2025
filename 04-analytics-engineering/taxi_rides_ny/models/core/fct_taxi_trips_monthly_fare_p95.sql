{{ config(
    materialized='table'
) }}

with valid_trips as (
    select 
        service_type,
        extract(year from pickup_datetime) as year,
        extract(month from pickup_datetime) as month,
        fare_amount
    from {{ ref('fact_trips') }}
    where 
        fare_amount > 0 
        and trip_distance > 0 
        and payment_type_description in ('Credit card', 'Cash')
),

monthly_percentiles as (
    select 
        service_type,
        year,
        month,
        -- Using PERCENTILE_CONT for continuous percentile calculation
        PERCENTILE_CONT(fare_amount, 0.97) OVER (
            PARTITION BY service_type, year, month
        ) as p97_fare,
        PERCENTILE_CONT(fare_amount, 0.95) OVER (
            PARTITION BY service_type, year, month
        ) as p95_fare,
        PERCENTILE_CONT(fare_amount, 0.90) OVER (
            PARTITION BY service_type, year, month
        ) as p90_fare
    from valid_trips
)

select distinct
    service_type,
    year,
    month,
    round(p97_fare, 1) as p97_fare,
    round(p95_fare, 1) as p95_fare,
    round(p90_fare, 1) as p90_fare
from monthly_percentiles
order by service_type, year, month 