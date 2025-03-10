# 📊 SQL Data Warehouse Project

## 📝 Overview

This project focuses on building a **Data Warehouse (DWH) using SQL Server**, implementing robust **ETL (Extract, Transform, Load)** processes to handle structured data from CSV sources. The architecture follows the **Medallion approach** (**Bronze, Silver, and Gold layers**) to ensure data is efficiently ingested, cleaned, transformed, and optimized for analytical consumption.

---

## 📖 Project Scope

### 🔹 Key Components:
1. 🏛 **Data Architecture**: Designing a Modern Data Warehouse using **Medallion Architecture** (**Bronze**, **Silver**, and **Gold** layers).
2. ⚙️ **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. 🛠 **Data Modeling**: Developing **fact and dimension tables** optimized for analytical queries.
4. 📈 **Analytics & Reporting**: Creating SQL-based **reports and dashboards** for actionable insights.

---

## 🏗 Data Architecture

The project adheres to the **Medallion Architecture**, which consists of three layers:

![DWH Architecture](https://github.com/StefanoN98/SQL-Projects/blob/bfb6fddf33b55684ca873048f80aa5bb69c7cd97/01.%20DATA%20WAREHOUSE%20PROJECT/Docs/DWH%20Architecture%20.png)

### 🟤 1. Bronze Layer (Raw Data)
- 📂 Stores **raw data** as received from source systems (**CRM, ERP**) in **CSV format**.
- ❌ No transformation is applied.
- 📌 Data is loaded using **batch processing** with **full load** and **truncate & insert strategies**.
- 📊 **Object Type**: Tables. 

### ⚪ 2. Silver Layer (Cleaned, Standardized Data)
- 🧹 Cleanses and **standardizes raw data** for **consistency and quality**.
- 🔍 Performs **data cleansing, normalization, derived columns, and enrichment**.
- 📌 Data is still stored in **tables**.
- ⚙ Uses **batch processing for loading (stored procedures)**.

### 🟡 3. Gold Layer (Business-Ready Data)
- 💡 Provides **transformed data** optimized for **analytics and reporting**.
- 🔄 Applies **data integration, aggregation, and business logic**.
- 📌 Data is stored as **views** rather than tables.
- 🌟 Implements **Star Schema model**.

---

## ⚙️ ETL Pipeline

During the ETL process:
1. 🔄 Data is retrieved from the **source system** and loaded into the **Bronze Layer (tables)**.
2. 🔍 Various transformations are applied before loading into the **Silver Layer (tables)**.
3. 🌟 Views are created in the **Gold Layer**, identifying **dimension and fact tables**.

![Data Flow Diagram](https://github.com/StefanoN98/SQL-Projects/blob/bfb6fddf33b55684ca873048f80aa5bb69c7cd97/01.%20DATA%20WAREHOUSE%20PROJECT/Docs/Data%20Flow%20Diagram%20.png)

---

## 🛠️ Data Modeling

After identifying **dimension and fact objects**, relationships are established using **surrogate keys**.

![Star Schema](https://github.com/StefanoN98/SQL-Projects/blob/d4a874eb53ffb80c71ba649ba51c3acb383c722c/01.%20DATA%20WAREHOUSE%20PROJECT/Docs/Star%20Schema%20Gold%20Layer.png)

---

## 🔧 Technologies Used

- 📂 **Datasets**: Structured **CSV files**.
- 🗄 **SQL Server Management Studio (SSMS)**: GUI for managing and interacting with databases.
- 🐙 **Git & GitHub**: Version control for managing and collaborating on the project.
- 📊 **DrawIO**: Designing **data architecture, models, and ETL flow diagrams**.

---

## 📜 License

This project is licensed under the **MIT License**.

