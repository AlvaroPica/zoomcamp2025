{{ config(
    materialized='table'
) }}

with trips_with_quarters as (

    select 
        service_type,
        extract(year from pickup_datetime) as year,
        extract(quarter from pickup_datetime) as quarter,
        concat(cast(extract(year from pickup_datetime) as string), '/Q', cast(extract(quarter from pickup_datetime) as string)) as year_quarter,
        sum(total_amount) as quarterly_revenue
    
    from {{ ref('fact_trips') }}
    
    where date(pickup_datetime) between date('2019-01-01') and date('2020-12-31')
    
    group by service_type, year, quarter, year_quarter

),

prev_year_revenue as (
    
    select 
        service_type,
        year,
        quarter,
        year_quarter,
        quarterly_revenue,
        lag(quarterly_revenue) over (partition by service_type, quarter order by year) as prev_year_revenue
    
    from trips_with_quarters

),

quarterly_yoy_growth as (
    
    select 
        *,
        round(((pyr.quarterly_revenue - pyr.prev_year_revenue) / pyr.prev_year_revenue) * 100, 2) as yoy_growth
    
    from prev_year_revenue pyr

)

select
    *
from quarterly_yoy_growth

order by service_type, year, quarter
