from datetime import datetime
from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateExternalTableOperator
from airflow.operators.python import PythonOperator
from google.cloud import bigquery

PROJECT_ID = "angular-rhythm-450212-n4"
BUCKET = "angular-rhythm-450212-n4-kestra-bucket"
DATASET = "trips_data_all"

def create_external_table(year_month: str) -> None:
    """Creates an external table in BigQuery"""
    
    client = bigquery.Client()
    
    # Format table name
    table_id = f"{PROJECT_ID}.{DATASET}.fhv_tripdata_{year_month.replace('-', '_')}_ext"
    
    # External table configuration
    external_config = bigquery.ExternalConfig("CSV")
    external_config.source_uris = [f"gs://{BUCKET}/fhv/fhv_tripdata_{year_month}.csv"]
    external_config.schema = [
        bigquery.SchemaField("dispatching_base_num", "STRING"),
        bigquery.SchemaField("pickup_datetime", "TIMESTAMP"),
        bigquery.SchemaField("dropoff_datetime", "TIMESTAMP"),
        bigquery.SchemaField("PULocationID", "INTEGER"),
        bigquery.SchemaField("DOLocationID", "INTEGER"),
        bigquery.SchemaField("SR_Flag", "INTEGER"),
        bigquery.SchemaField("Affiliated_base_number", "STRING"),
    ]
    external_config.skip_leading_rows = 1
    
    # Create table
    table = bigquery.Table(table_id)
    table.external_data_configuration = external_config
    
    # Create or update the table
    client.create_table(table, exists_ok=True)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
}

with DAG(
    'fhv_gcs_to_bigquery',
    default_args=default_args,
    description='Creates BigQuery external tables for FHV data',
    schedule_interval=None,  # Manual trigger only
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['fhv'],
) as dag:
    
    for month in range(1, 13):
        year_month = f"2019-{month:02d}"
        
        create_ext_table = PythonOperator(
            task_id=f'create_external_table_{year_month}',
            python_callable=create_external_table,
            op_kwargs={'year_month': year_month},
        ) 