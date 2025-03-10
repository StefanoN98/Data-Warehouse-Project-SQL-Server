/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time

	-- 1) Sales Amount date granularity --> SUM + GROUP BY
		SELECT order_date,
			   SUM(sales_amount) as sales_amount
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY order_date
		ORDER BY order_date

	-- 2) Sales Amount year granularity --> YEAR + SUM + GROUP BY
		SELECT YEAR(order_date) as _year,
			   SUM(sales_amount) as sales_amount
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY YEAR(order_date)
		ORDER BY YEAR(order_date)

	-- 3) Add numbers of client per year and quantity --> add COUNT
		SELECT YEAR(order_date) as _year,
			   SUM(sales_amount) as sales_amount,
			   COUNT(DISTINCT customer_key) as total_customer,
			   SUM(quantity) as total_quantity
		FROM gold.fact_sales 
		WHERE order_date IS NOT NULL
		GROUP BY YEAR(order_date)
		ORDER BY YEAR(order_date)

	-- 4) Drilldown to year-month level --> YAER + MONTH
		SELECT YEAR(order_date) as _year,
			   MONTH(order_date) as _month,
			   SUM(sales_amount) as sales_amount,
			   COUNT(DISTINCT customer_key) as total_customer,
			   SUM(quantity) as total_quantity
		FROM gold.fact_sales 
		WHERE order_date IS NOT NULL
		GROUP BY YEAR(order_date), MONTH(order_date)
		ORDER BY YEAR(order_date), MONTH(order_date)

	-- 5) Drilldown using --> DATETRUNC
		SELECT DATETRUNC(year,order_date) as _year,
			   DATETRUNC(month,order_date) as _month,
			   SUM(sales_amount) as sales_amount,
			   COUNT(DISTINCT customer_key) as total_customer,
			   SUM(quantity) as total_quantity
		FROM gold.fact_sales 
		WHERE order_date IS NOT NULL
		GROUP BY DATETRUNC(year,order_date), DATETRUNC(month,order_date)
		ORDER BY DATETRUNC(year,order_date), DATETRUNC(month,order_date)

	-- 6) Drilldown using --> FORMAT
		SELECT FORMAT(order_date, 'yyyy-MMM') as month_year,
			   SUM(sales_amount) as sales_amount,
			   COUNT(DISTINCT customer_key) as total_customer,
			   SUM(quantity) as total_quantity
		FROM gold.fact_sales 
		WHERE order_date IS NOT NULL
		GROUP BY FORMAT(order_date, 'yyyy-MMM')
		ORDER BY FORMAT(order_date, 'yyyy-MMM')


