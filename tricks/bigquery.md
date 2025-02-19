# BigQuery Tricks

Check column types:

```sql
SELECT 
    column_name, 
    data_type
FROM `angular-rhythm-450212-n4.zoomcamp_dbt_core_prod.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'fct_taxi_trips_quarterly_revenue';
```

