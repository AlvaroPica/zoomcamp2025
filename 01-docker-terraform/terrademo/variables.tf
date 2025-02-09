variable "credentials" {
  description = "Service Account Credentials"
  default     = "C:/workspace/alvaro_NAS_home/workspace_cloud/data_expert/angular-rhythm-450212-n4-7dbad37080ae.json"
}

variable "project" {
  description = "Project ID"
  default     = "angular-rhythm-450212-n4"

}

variable "location" {
  description = "Project Location"
  default     = "EU"

}

variable "region" {
  description = "Project Region"
  default     = "eu-west1"

}


variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default = "terrademo_dataset"

}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default = "angular-rhythm-450212-n4-terrademo-bucket"

}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"

}