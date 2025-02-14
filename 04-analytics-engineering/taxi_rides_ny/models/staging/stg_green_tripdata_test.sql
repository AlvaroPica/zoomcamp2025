-- generating model for source('staging', 'green_tripdata')...

{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select *
  from {{ source('staging','green_tripdata') }}
  limit 100
)

select
*
from tripdata
