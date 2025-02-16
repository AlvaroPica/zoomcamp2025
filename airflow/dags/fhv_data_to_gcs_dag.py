import os
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.hooks.gcs import GCSHook
import requests
import gzip
import shutil

AIRFLOW_HOME = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
PROJECT_ID = "angular-rhythm-450212-n4"
BUCKET = "angular-rhythm-450212-n4-kestra-bucket"

def download_and_extract_fhv_data(year_month: str) -> str:
    """Downloads and extracts FHV data for a given year-month"""
    
    # Define file paths
    gzip_file = f"{AIRFLOW_HOME}/data/fhv_tripdata_{year_month}.csv.gz"
    output_file = f"{AIRFLOW_HOME}/data/fhv_tripdata_{year_month}.csv"
    
    # Create data directory if it doesn't exist
    os.makedirs(f"{AIRFLOW_HOME}/data", exist_ok=True)
    
    # Download the file
    url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_{year_month}.csv.gz"
    response = requests.get(url)
    
    # Save the gzipped file
    with open(gzip_file, 'wb') as f:
        f.write(response.content)
    
    # Extract the file
    with gzip.open(gzip_file, 'rb') as f_in:
        with open(output_file, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
    
    # Clean up gzip file
    os.remove(gzip_file)
    
    return output_file

def upload_to_gcs(file_path: str, year_month: str) -> None:
    """Uploads a file to GCS"""
    gcs_hook = GCSHook()
    
    # Upload to GCS
    gcs_hook.upload(
        bucket_name=BUCKET,
        object_name=f"fhv/fhv_tripdata_{year_month}.csv",
        filename=file_path
    )
    
    # Clean up local file
    os.remove(file_path)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
}

with DAG(
    'fhv_data_to_gcs',
    default_args=default_args,
    description='Downloads FHV data and uploads to GCS',
    schedule_interval=None,  # Manual trigger only
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['fhv'],
) as dag:
    
    for month in range(1, 13):
        year_month = f"2019-{month:02d}"
        
        download_task = PythonOperator(
            task_id=f'download_fhv_data_{year_month}',
            python_callable=download_and_extract_fhv_data,
            op_kwargs={'year_month': year_month},
        )
        
        upload_task = PythonOperator(
            task_id=f'upload_to_gcs_{year_month}',
            python_callable=upload_to_gcs,
            op_kwargs={
                'file_path': f"{AIRFLOW_HOME}/data/fhv_tripdata_{year_month}.csv",
                'year_month': year_month
            },
        )
        
        download_task >> upload_task 