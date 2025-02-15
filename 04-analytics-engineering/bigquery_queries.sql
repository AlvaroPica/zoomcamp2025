SELECT 
  table_name,
  table_type,
  creation_time
FROM 
  `angular-rhythm-450212-n4.zoomcamp_dbt_dev.INFORMATION_SCHEMA.TABLES`
ORDER BY
  creation_time DESC;

select * from `angular-rhythm-450212-n4.zoomcamp_dbt_dev.facts_trips`;