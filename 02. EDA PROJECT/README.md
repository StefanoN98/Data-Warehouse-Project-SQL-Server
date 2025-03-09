# 📊 SQL Exploratory Data Analysis (EDA) Project  


🔍 This project focuses on **Exploratory Data Analysis (EDA) using SQL**, to uncover insights, identify trends, and answer key business questions.  


---


## 🔥 What is EDA?  

📌 **Exploratory Data Analysis (EDA)** is the process of understanding a dataset and extracting insights by analyzing its structure, patterns, and relationships.  

📊 **In this project::**  
✅ Explored database objects, dimensions, and measures  
✅ Analyze key business metrics using SQL  

🔜 **Next Steps:** After mastering EDA, I'll apply advanced SQL techniques to answer complex business questions and generate reports for stakeholders.  

---

## 📁 Project Material  

📌 We reuse data from the previous project, specifically the **gold layer**, no additional setup is required!  

---

## 📏 Dimensions & Measures  

📊 **Understanding your dataset starts with identifying Measures & Dimensions**  

✔️ **Dimensions** (Qualitative)  
- Examples: `Category`, `Product Name`, `Customer ID`  
- Used for grouping/segmentation  

✔️ **Measures** (Quantitative)  
- Examples: `Sales Amount`, `Revenue`, `Age`  
- Used for numerical aggregation (SUM, AVG, COUNT)  

👉 This classification is crucial because **analysis is always grouped by dimensions, while measures answer "how much?" questions.**  

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


