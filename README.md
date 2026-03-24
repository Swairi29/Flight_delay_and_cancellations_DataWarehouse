# Flight_delay_and_cancellations_DataWarehouse

Creating and managing a data warehouse for Flight Delay and Cancellation Dataset (2019-2023) dataset.
Due to GitHub file size limitations, the full dataset (flights_sample_3m.csv) is not included.

🔗 Dataset Source:
https://www.kaggle.com/datasets/patrickzel/flight-delay-and-cancellation-dataset-2019-2023/

A reduced sample dataset (10,000 records) is provided for demonstration purposes. - flights_sample_10k.csv

## SQL Implementation

All database-related scripts are available in the /sql folder.
- Schema creation
- ETL process
- Analytical queries for reporting

These were developed using SQL Server Management Studio (SSMS).

Solution Architecture
Overview

A simple Data Warehouse & BI architecture is used to process and analyze flight delay and cancellation data.

Components
Data Sources
CSV, JSON, and Excel files containing flight, airline, and airport data.
ETL Process
Python scripts are used to clean, transform, and prepare the data.
Data Warehouse (SQL Server)
Stores structured data using fact and dimension tables.
Analytics Layer
SQL queries are used to generate insights such as delays and cancellations.

Data Warehouse Design
Dimensional Model

A Star Schema is used.

Fact Table
Fact_Flights
Stores measurable data such as delay time and cancellation status.

Dimension Tables
Dim_Airline
Dim_Airport
Dim_Date
Dim_Flight_Status
Dim_Time
Dim_Flight_Data
Dim_Route

Slowly Changing Dimension (SCD)
Implemented in Dim_Airline
Used to track changes in airline details over time.


Design Assumptions
Each flight record is treated as a unique event
Airlines and airports provide descriptive details
Date dimension is used for time-based analysis
Historical data changes are preserved using SCD


