/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

--1) Base Query: Retrieves core columns from tables
	WITH base_query AS(
		SELECT 
			f.order_number,
			f.product_key,
			f.order_date,
			f.sales_amount,
			f.quantity,
			c.customer_key,
			c.customer_number,
			CONCAT(c.first_name,' ',c.last_name) AS customer_name,
			DATEDIFF(year, c.birthdate,GETDATE()) AS age
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customer c
		ON c.customer_key= f.customer_key
		)

	SELECT *
	FROM base_query

/*2) Now we'll create the requested aggregation (total orders, total sales
	   total quantity purchased, total products, lifespan (in months)*/

	WITH base_query AS(
		SELECT 
			f.order_number,
			f.product_key,
			f.order_date,
			f.sales_amount,
			f.quantity,
			c.customer_key,
			c.customer_number,
			CONCAT(c.first_name,' ',c.last_name) AS customer_name,
			DATEDIFF(year, c.birthdate,GETDATE()) AS age
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customer c
		ON c.customer_key= f.customer_key
		)

	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   COUNT(DISTINCT order_number) AS total_orders, --Aggregation Created
		   SUM(sales_amount) AS total_sales, --Aggregation Created
		   SUM(quantity) AS total_quantity, --Aggregation Created
		   COUNT(DISTINCT product_key) AS total_products, --Aggregation Created
		   MAX(order_date) AS last_order_date, --Aggregation Created
		   DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan --Aggregation Created
	FROM base_query
	GROUP BY customer_key,
			 customer_number,
			 customer_name,
			 age   --GROUP BY to manage the aggregations

--3) Let's create the segment (VIP, Regular, New and age groups) 

	WITH base_query AS(
		SELECT 
			f.order_number,
			f.product_key,
			f.order_date,
			f.sales_amount,
			f.quantity,
			c.customer_key,
			c.customer_number,
			CONCAT(c.first_name,' ',c.last_name) AS customer_name,
			DATEDIFF(year, c.birthdate,GETDATE()) AS age
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customer c
		ON c.customer_key= f.customer_key
		),

	customer_aggregation AS(
	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   COUNT(DISTINCT order_number) AS total_orders,
		   SUM(sales_amount) AS total_sales,
		   SUM(quantity) AS total_quantity,
		   COUNT(DISTINCT product_key) AS total_products,
		   MAX(order_date) AS last_order_date,
		   DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key,
		   customer_number,
		   customer_name,
		   age
	)

	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   CASE 
				 WHEN age < 20 THEN 'Under 20'
				 WHEN age between 20 and 29 THEN '20-29'
				 WHEN age between 30 and 39 THEN '30-39'
				 WHEN age between 40 and 49 THEN '40-49'
				 ELSE '50 and above'
		   END AS age_group, --Age group created
		   total_orders,
		   total_sales,
		   total_quantity,
		   total_products,
		   last_order_date,
		   lifespan,
		   CASE 
				 WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
				 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		         ELSE 'New'
		  END AS customer_segment --Customer segment created
	FROM customer_aggregation


--4) Create KPIs (recency (months since last order), average order value , average monthly spend
	WITH base_query AS(
		SELECT 
			f.order_number,
			f.product_key,
			f.order_date,
			f.sales_amount,
			f.quantity,
			c.customer_key,
			c.customer_number,
			CONCAT(c.first_name,' ',c.last_name) AS customer_name,
			DATEDIFF(year, c.birthdate,GETDATE()) AS age
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customer c
		ON c.customer_key= f.customer_key
		),

	customer_aggregation AS(
	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   COUNT(DISTINCT order_number) AS total_orders,
		   SUM(sales_amount) AS total_sales,
		   SUM(quantity) AS total_quantity,
		   COUNT(DISTINCT product_key) AS total_products,
		   MAX(order_date) AS last_order_date,
		   DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key,
		   customer_number,
		   customer_name,
		   age
	)

	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   CASE 
				 WHEN age < 20 THEN 'Under 20'
				 WHEN age between 20 and 29 THEN '20-29'
				 WHEN age between 30 and 39 THEN '30-39'
				 WHEN age between 40 and 49 THEN '40-49'
				 ELSE '50 and above'
		   END AS age_group,
		   DATEDIFF(month , last_order_date, GETDATE()) AS recency,  --recency KPI
		   total_orders,
		   total_sales,
		   total_quantity,
		   total_products,
		   last_order_date,
		   lifespan,
		   CASE 
				 WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
				 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		         ELSE 'New'
		  END AS customer_segment,
		  CASE WHEN total_orders = 0 THEN 0  -- this is to avoid to divide by zero
			   ELSE total_sales / total_orders
		  END AS avg_order_value, --average order value KPI
		  CASE WHEN lifespan = 0 THEN total_sales
			   ELSE total_sales / lifespan
		  END AS avg_monthly_spend --Average montly spent KPI
	FROM customer_aggregation

------------------------------------------------------------------------------------------------------

--5) Put the final query in a view
IF OBJECT_ID('gold.report_customer', 'V') IS NOT NULL
    DROP VIEW gold.report_customer;
GO
CREATE VIEW gold.report_customer AS

	WITH base_query AS(
		SELECT 
			f.order_number,
			f.product_key,
			f.order_date,
			f.sales_amount,
			f.quantity,
			c.customer_key,
			c.customer_number,
			CONCAT(c.first_name,' ',c.last_name) AS customer_name,
			DATEDIFF(year, c.birthdate,GETDATE()) AS age
		FROM gold.fact_sales f
		LEFT JOIN gold.dim_customer c
		ON c.customer_key= f.customer_key
		),

	customer_aggregation AS(
	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   COUNT(DISTINCT order_number) AS total_orders,
		   SUM(sales_amount) AS total_sales,
		   SUM(quantity) AS total_quantity,
		   COUNT(DISTINCT product_key) AS total_products,
		   MAX(order_date) AS last_order_date,
		   DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key,
		   customer_number,
		   customer_name,
		   age
	)

	SELECT customer_key,
		   customer_number,
		   customer_name,
		   age,
		   CASE 
				 WHEN age < 20 THEN 'Under 20'
				 WHEN age between 20 and 29 THEN '20-29'
				 WHEN age between 30 and 39 THEN '30-39'
				 WHEN age between 40 and 49 THEN '40-49'
				 ELSE '50 and above'
		   END AS age_group,
		   DATEDIFF(month , last_order_date, GETDATE()) AS recency,  --recency KPI
		   total_orders,
		   total_sales,
		   total_quantity,
		   total_products,
		   last_order_date,
		   lifespan,
		   CASE 
				 WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
				 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		         ELSE 'New'
		  END AS customer_segment,
		  CASE WHEN total_orders = 0 THEN 0  -- this is to avoid to divide by zero
			   ELSE total_sales / total_orders
		  END AS avg_order_value, --average order value KPI
		  CASE WHEN lifespan = 0 THEN total_sales
			   ELSE total_sales / lifespan
		  END AS avg_monthly_spend --Average montly spent KPI
	FROM customer_aggregation

----------------------------------------------------------------------------------------------------

-- Check the nre report_customer view is working
	SELECT *
	FROM gold.report_customer
