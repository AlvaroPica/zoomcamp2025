terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
}

# Create a Google Cloud Storage bucket

resource "google_storage_bucket" "demo-bucket" { # This is the resource name and demo-bucket is the name of the bucket locally
  name          = var.gcs_bucket_name            # This has to be globally unique across all GCP
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1 # Age in Days
    }

    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

#Create bigquery dataset

resource "google_bigquery_dataset" "demo-dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}