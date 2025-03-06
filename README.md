# 📊SQL Data arehouse Project

## 📝 Overview

This project focuses on building a Data Warehouse (DWH) using SQL Server, implementing ETL (Extract, Transform, Load) processes to handle structured data from CSV sources. The architecture follows the Medallion approach (Bronze, Silver, and Gold layers) to ensure data is efficiently ingested, cleaned, transformed, and optimized for analytical consumption.

---

## 🏗 Architecture

The project adheres to the Medallion Architecture, which consists of three layers:


### 🟤 1. Bronze Layer (Raw Data)

- 📂 Stores raw data as received from source systems (CRM, ERP) in CSV format.
- ❌ No transformation is applied.
- 📌 Data is loaded using batch processing with full load and truncate & insert strategies.
- 📊 Object Type: Tables. 


### ⚪ 2. Silver Layer (Cleaned, Standardized Data)

- 🧹 Cleanses and standardizes raw data for consistency and quality.
- 🔍 Performs data cleansing, normalization, derived columns, and enrichment.
- 📌 Data is still stored in tables.
- ⚙ Uses batch processing for loading.


### 🟡 3. Gold Layer (Business-Ready Data)

- 💡 Provides transformed data optimized for analytics and reporting.
- 🔄 Applies data integration, aggregation, and business logic.
- 📌 Data is stored as views rather than tables.
- 📊 Supports multiple data models:

    1. 🌟 Star Schema
  
    2. 📑 Flat Table
  
  3. 📈 Aggregated Table

---

## 🔄 Data Flow

1.📥 Extract: Data is ingested from CSV files located in designated folders.

2.🔄 Transform:

- 🟤 Bronze: No transformation (raw data storage).
- ⚪ Silver: Cleansing, standardization, and enrichment.
- 🟡 Gold: Aggregations and business logic applied.

3.📤 Load:

- 🟤 Bronze layers use batch processing.
- ⚪ Silver layers use batch processing.
- 🟡 Gold layer uses views for optimized data retrieval.
  
---

## 🛠 Technologies Used

🗄 SQL Server for data storage and processing.

---

## 🤝 Contribution

Feel free to contribute by submitting issues, feature requests, or pull requests. Let's build a robust data warehouse together! 🚀

---

## 📜 License

This project is licensed under the MIT License.
