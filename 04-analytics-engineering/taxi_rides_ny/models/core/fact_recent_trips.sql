{{ config(
    schema=resolve_schema_for(model_type='core'), 
) }}

{% set simnulated_current_date = '2020-01-01' %}

select *
from {{ ref('fact_trips') }}

where date(pickup_datetime) between date('{{ simnulated_current_date }}') - interval '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' day
and date('{{ simnulated_current_date }}')
