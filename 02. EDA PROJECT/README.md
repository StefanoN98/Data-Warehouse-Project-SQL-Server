# 📊 SQL Exploratory Data Analysis (EDA) Project  


🔍 This project focuses on **Exploratory Data Analysis (EDA) using SQL**, to uncover insights, identify trends, and answer key business questions.  


---


## 🔥 What is EDA?  

📌 **Exploratory Data Analysis (EDA)** is the process of understanding a dataset and extracting insights by analyzing its structure, patterns, and relationships.  

📊 **In this project:**  
✅ We xplored database objects, dimensions, and measures  
✅ We analyze key business metrics using SQL  

🔜 **Next Steps:** After EDA, we'll apply advanced SQL techniques to answer complex business questions and generate reports for stakeholders.  

---

## 📁 Project Material  

📌 We reuse data from the previous project ([DWH Project](https://github.com/StefanoN98/SQL-Projects/tree/06aee2d53e71eb27d893c442388b04e8bc5889e7/01.%20DATA%20WAREHOUSE%20PROJECT)), specifically the **gold layer**, no additional setup is required!

---

## 📏 Identify Dimensions & Measures  

✔️ **Dimensions** (Qualitative)  
- Examples: `Category`, `Product Name`, `Customer ID`  
- Used for grouping/segmentation  

✔️ **Measures** (Quantitative)  
- Examples: `Sales Amount`, `Revenue`, `Age`  
- Used for numerical aggregation (SUM, AVG, COUNT)  


---

## 🏗️ Exploratory Process  

### 📂 Database Exploration  
- Use `INFORMATION_SCHEMA` to inspect tables, views, and columns.  

### 🏷️ Dimension Exploration  
- Identify unique values in each dimension using `DISTINCT` to understand segmentation (e.g., regions, product types).  

### 📅 Date Exploration  
- Determine dataset timespan by finding the earliest and latest dates.  
- Use `DATEDIFF()` to analyze customer ages.  

### 📊 Measure Exploration  
- Compute high-level key metrics using SQL aggregation functions like `SUM`, `AVG`, `COUNT`.  
- Combine multiple queries using `UNION ALL` for a single overview table.  

---

## 📈 Analysis  

### 📏 Magnitude Analysis  
🔹 Compare measures across different categories/dimensions:  
- Number of customers per **country, gender, category**  
- **Average cost per category**  
- **Total revenue by category/customer/country**  

### 🏆 Ranking Analysis  
📊 Rank dimensions based on measure values to find **top/bottom performers**:  
- Use `ORDER BY` to rank results  
- Apply **Window Functions** for flexible ranking  


