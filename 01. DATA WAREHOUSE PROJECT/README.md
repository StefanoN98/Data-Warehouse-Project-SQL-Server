# 📊SQL Data arehouse Project

## 📝 Overview

This project focuses on building a Data Warehouse (DWH) using SQL Server, implementing ETL (Extract, Transform, Load) processes to handle structured data from CSV sources. The architecture follows the Medallion approach (Bronze, Silver, and Gold layers) to ensure data is efficiently ingested, cleaned, transformed, and optimized for analytical consumption.

---

## 📖 Project

1. 🏛**Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. ⚙️**ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. 🛠️**Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. 📈**Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

---

## 🏗 Data Architecture

The project adheres to the Medallion Architecture, which consists of three layers:

![Image Alt](https://github.com/StefanoN98/SQL-Projects/blob/bfb6fddf33b55684ca873048f80aa5bb69c7cd97/01.%20DATA%20WAREHOUSE%20PROJECT/Docs/DWH%20Architecture%20.png)


### 🟤 1. Bronze Layer (Raw Data)

- 📂 Stores raw data as received from source systems (CRM, ERP) in CSV format.
- ❌ No transformation is applied.
- 📌 Data is loaded using batch processing with full load and truncate & insert strategies.
- 📊 Object Type: Tables. 


### ⚪ 2. Silver Layer (Cleaned, Standardized Data)

- 🧹 Cleanses and standardizes raw data for consistency and quality.
- 🔍 Performs data cleansing, normalization, derived columns, and enrichment.
- 📌 Data is still stored in tables.
- ⚙ Uses batch processing for loading (stored procedure).


### 🟡 3. Gold Layer (Business-Ready Data)

- 💡 Provides transformed data optimized for analytics and reporting.
- 🔄 Applies data integration, aggregation, and business logic.
- 📌 Data is stored as views rather than tables.
- 🌟 Implements  Star Schema model

---

## ⚙️ ETL Pipeline

During the ETL process I retrieved data from the source loading directly in the bronze layer as table, then I applied various transformation and load in the silver layer always as table and to conclude I create view in the gold layer identifying dim and fact.

![Image Alt](https://github.com/StefanoN98/SQL-Projects/blob/bfb6fddf33b55684ca873048f80aa5bb69c7cd97/01.%20DATA%20WAREHOUSE%20PROJECT/Docs/Data%20Flow%20Diagram%20.png)

---

## 🛠️ Data Modeling

After the identification of dim and fact object I create the relationshio between them using the identified surrogate key.

![Image Alt](https://github.com/StefanoN98/Data-Warehouse-Project-SQL-Server/blob/dee6e94f1c0d899b7fbfbf42e00a1d08eea6d1f8/Docs/Star%20Schema%20Gold%20Layer.png)

---

## 🔧 Technologies Used

- 📂 Datasets: Access to the project dataset (CSV files).
- 🗄 SQL Server Management Studio (SSMS): GUI for managing and interacting with databases.
- 🐙 Git Repository: Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- 📊 DrawIO: Design data architecture, models, flows, and diagrams.


---

## 📜 License

This project is licensed under the MIT License.
