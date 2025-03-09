/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?

	-- Simple Ranking
		SELECT TOP 5 dp.product_name,
			   SUM(fs.sales_amount) AS total_revenue
		FROM gold.fact_sales fs
		LEFT JOIN gold.dim_product dp
		ON dp.product_key= fs.product_key
		GROUP BY dp.product_name
		ORDER BY total_revenue DESC

	-- Complex but Flexibly Ranking Using Window Functions
		WITH cte as(
			SELECT  dp.product_name,
				   SUM(fs.sales_amount) AS total_revenue,
					ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) DESC) as ranking
			FROM gold.fact_sales fs
			LEFT JOIN gold.dim_product dp
			ON dp.product_key= fs.product_key
			GROUP BY dp.product_name
			)

		SELECT *
		from cte
		WHERE ranking <=5
		

-- What are the 5 worst-performing products in terms of sales?
		SELECT TOP 5 dp.product_name,
			   SUM(fs.sales_amount) AS total_revenue
		FROM gold.fact_sales fs
		LEFT JOIN gold.dim_product dp
		ON dp.product_key= fs.product_key
		GROUP BY dp.product_name
		ORDER BY total_revenue ASC


-- Find the top 10 customers who have generated the highest revenue
		SELECT TOP 10
			dc.customer_key,
			dc.first_name,
			dc.last_name,
			SUM(fs.sales_amount) AS total_revenue
		FROM gold.fact_sales fs
		LEFT JOIN gold.dim_customer dc
		ON dc.customer_id = fs.customer_key
		GROUP BY 
			dc.customer_key,
			dc.first_name,
			dc.last_name
		ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
		SELECT TOP 10
			dc.customer_key,
			dc.first_name,
			dc.last_name,
			COUNT(DISTINCT order_number) AS total_orders
		FROM gold.fact_sales fs
		LEFT JOIN gold.dim_customer dc
		ON dc.customer_id = fs.customer_key
		GROUP BY 
			dc.customer_key,
			dc.first_name,
			dc.last_name
		ORDER BY total_orders ASC;




