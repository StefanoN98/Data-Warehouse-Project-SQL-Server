/*
===============================================================================
DATE RANGE EXPLORATION
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/


	 --Find first and last order date
		SELECT MIN(order_date) AS first_order_date,
			   MAX(order_date) AS last_order_date
		FROM gold.fact_sales

	--How many years of sales are available
		SELECT MIN(order_date) AS first_order_date,
			   MAX(order_date) AS last_order_date,
			   DATEDIFF(year, MIN(order_date) , MAX(order_date)) AS orders_years_range,
			   DATEDIFF(month, MIN(order_date) , MAX(order_date)) AS orders_month_range
		FROM gold.fact_sales

	--Find the youngest and oldest customer
		SELECT MAX(birthdate) AS youngest_birthdate,
			   DATEDIFF(year, MAX(birthdate) , GETDATE() ) AS youngest_age,
			   MIN(birthdate) AS oldest_birthdate,
			   DATEDIFF(year, MIN(birthdate) , GETDATE() ) AS oldest_age
		FROM gold.dim_customer

