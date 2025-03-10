# SQL Advanced Analytics Project

## 📌 Overview

This project focuses on **Advanced Data Analytics** using SQL. It explores various analytical techniques, including **trend analysis, cumulative metrics, performance analysis, segmentation, and report building** using SQL queries.

The dataset used is the **gold layer** from previous project in DWH, allowing for deep-dive analysis on customer behaviors, product performance, and business insights over time.

## 📂 Project Structure

### 1️⃣ Changes Over Time Analysis

- **Use of `SUM`, `COUNT`, `GROUP BY`** for aggregations
- **`DATETRUNC` and `FORMAT`** for date-based transformations
- **Drill-down analysis** to identify trends and seasonality

### 2️⃣ Cumulative Analysis

- **Running total** using window functions
- **Moving averages** for trend smoothing

### 3️⃣ Performance Analysis

- **Comparing current sales with average sales** using `AVG OVER(PARTITION BY)`
- **Year-over-Year (YoY) comparison** using `LAG OVER(PARTITION BY)`

### 4️⃣ Part-to-Whole Analysis

- **Calculating category contribution to the total **
- **Percentage calculations** `

### 5️⃣ Data Segmentation Analysis

- **Segmenting new categories** with the construct `CASE WHEN`
- **Customer segmentation**

### 6️⃣ Report Building

- **Customer Report**: Aggregates customer behavior based on purchase trends
- **Product Report**: Analyzes product performance across different segments



