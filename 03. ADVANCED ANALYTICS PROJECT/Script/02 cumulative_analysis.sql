/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


--1) RUNNING TOTAL - default frame
	-- Month case
		WITH cte AS(
			SELECT DATETRUNC(month, order_date) AS order_date, --month level
				   SUM(sales_amount) as total_sales
			FROM gold.fact_sales
			WHERE order_date IS NOT NULL
			GROUP BY DATETRUNC(month, order_date)
			)

			SELECT *,
				SUM(cte.total_sales) OVER (ORDER BY cte.order_date) AS running_total
			FROM cte

	-- Year case
		WITH cte AS(
			SELECT DATETRUNC(year, order_date) AS order_date, --year level
				   SUM(sales_amount) as total_sales
			FROM gold.fact_sales
			WHERE order_date IS NOT NULL
			GROUP BY DATETRUNC(year, order_date)
			)

			SELECT *,
				SUM(cte.total_sales) OVER (ORDER BY cte.order_date) AS running_total
			FROM cte


--2) RUNNING TOTAL - year frame
	WITH cte AS(
		SELECT DATETRUNC(month, order_date) AS order_date, --month level
			   SUM(sales_amount) as total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY DATETRUNC(month, order_date)
		)

		SELECT *,
			SUM(cte.total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY cte.order_date) AS running_total --partition per year
		FROM cte

--3) Add MOVING AVERAGE on the price
	WITH cte AS(
			SELECT DATETRUNC(year, order_date) AS order_date,
				   SUM(sales_amount) AS total_sales,
				   AVG(price) AS avg_price  --introduce average price
			FROM gold.fact_sales
			WHERE order_date IS NOT NULL
			GROUP BY DATETRUNC(year, order_date)
			)

	SELECT *,
		SUM(cte.total_sales) OVER (ORDER BY cte.order_date) AS running_total,
	    AVG(cte.avg_price) OVER (ORDER BY cte.order_date) AS moving_average  --add moving average
    FROM cte
