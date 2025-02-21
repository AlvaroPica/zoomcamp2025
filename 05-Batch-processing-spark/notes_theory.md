# Batch Processing

Disclaimer: Notes forked from section 4 README [2025 Notes by Manuel Guerra](https://github.com/ManuelGuerra1987/data-engineering-zoomcamp-notes/blob/main/5_Batch-Processing-Spark/README.md)

## Table of contents

- [Batch Processing](#batch-processing)
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Introduction to Batch Processing](#introduction-to-batch-processing)
    - [Batch vs. Streaming](#batch-vs-streaming)
      - [Batch](#batch)
      - [Streaming](#streaming)
    - [Characteristics of Batch Jobs](#characteristics-of-batch-jobs)
    - [Introduction to Spark](#introduction-to-spark)
  - [What is Apache Spark?](#what-is-apache-spark)
  - [When to Use Spark?](#when-to-use-spark)
    - [Alternatives: Hive, Presto, Athena](#alternatives-hive-presto-athena)
  - [Example Workflow: Machine Learning in Spark](#example-workflow-machine-learning-in-spark)
    - [Best Practices](#best-practices)

## Introduction

In this lesson, we explore **Apache Spark** as a tool for batch processing, specifically using **PySpark** (Python). The lesson covers:

- **DataFrames, SQL, and Joins** in Spark.
- **RDDs (Resilient Distributed Datasets)** and their differences from DataFrames.
- **Spark internals** and how to run Spark jobs using Docker.
- **Deployment to the cloud** and integration with a data warehouse.

## Introduction to Batch Processing

_[Video source](https://www.youtube.com/watch?v=dcHe5Fl3MF8)_

### Batch vs. Streaming

Data processing can be categorized into **batch processing** and **streaming**:

#### Batch

- Processes large amounts of accumulated data at scheduled intervals.
- Example: A job that processes taxi trip data for an entire day (e.g., January 15).
- Suitable for structured, periodic data transformation.

#### Streaming

- Handles data **in real-time** or near real-time.
- Example: A taxi service that processes trip events (start, stop, arrival) as they occur.
- Not covered in this lesson (focus is on batch processing).

### Characteristics of Batch Jobs

- **Scheduled execution** (e.g., daily, hourly, or even every few minutes).
- **Data accumulation**

### Introduction to Spark

_[Video source](https://www.youtube.com/watch?v=FhaqbEOuQ8U)_

## What is Apache Spark?

Apache Spark is an **open-source distributed computing system** designed for big data processing and analytics. It provides a fast, general-purpose engine that:

- **Leverages in-memory computing** for high-speed data processing.
- **Runs on distributed clusters**, handling large-scale data efficiently.
- **Supports multiple languages**, including:
  - **Scala** (native)
  - **Python (PySpark)**
  - **Java**
  - **R**

While Spark supports both **batch** and **streaming** processing, this lesson focuses on **batch jobs**.

## When to Use Spark?

Spark is particularly useful when dealing with data stored in **data lakes** (e.g., S3, Google Cloud Storage).

### Alternatives: Hive, Presto, Athena

- If **SQL** can express your data processing logic, **SQL-based tools** may be more efficient:
  - **Hive**: SQL-like query engine for Hadoop.
  - **Presto**: High-performance SQL engine for interactive queries.
  - **Athena (AWS-managed Presto)**: Allows querying data in S3 using SQL.
  - **BigQuery (external tables)**: Google Cloud’s serverless SQL engine.

When using **SQL alone is insufficient** (e.g., complex logic, modular code, unit tests), Spark provides **greater flexibility**.

## Example Workflow: Machine Learning in Spark

A typical **machine learning workflow** using Spark follows these steps:

1. **Raw data ingestion** into a **data lake** (e.g., S3, Google Cloud Storage).
2. **Initial transformations** using SQL tools like **Athena** or **Presto** (aggregations, joins).
3. **More complex transformations** requiring **Spark**:
   - Custom Python-based data processing.
   - Feature engineering and transformations that SQL cannot handle.
4. **Model training in Spark** using Python and ML libraries.
5. **Model application at scale**:
   - Trained models are used to process large datasets within Spark.
   - Results are stored back in the **data lake** or moved to a **data warehouse**.

### Best Practices

- **Use SQL-based tools (Presto, Athena, BigQuery) whenever possible** for simple queries.
- **Use Spark** when SQL becomes impractical, complex, or difficult to maintain.
