/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/


/*Analyze the yearly performance of products by comparing their sales
 to both the average sales performance of the product and the previous year's sales*/

-- Compare current sales with the avg sales per product_name
	 WITH yearly_product_sales AS (
			SELECT YEAR(f.order_date) AS _year,
				   p.product_name,
				   SUM(f.sales_amount) AS current_sales
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_product p
			ON f.product_key= p.product_key
			WHERE f.order_date IS NOT NULL
			GROUP BY YEAR(f.order_date),p.product_name
			)

		SELECT y._year,
			   y.product_name,
			   y.current_sales,
			   AVG(y.current_sales) OVER (PARTITION BY y.product_name) AS avg_sales, 
			   y.current_sales - AVG(y.current_sales) OVER (PARTITION BY y.product_name) AS diff_avg,
			   CASE WHEN y.current_sales - AVG(y.current_sales) OVER (PARTITION BY y.product_name) > 0 THEN 'Above Avg'
					WHEN y.current_sales - AVG(y.current_sales) OVER (PARTITION BY y.product_name) < 0 THEN 'Below Avg'
					ELSE 'Avg'
				END AS avg_change
			   
		FROM yearly_product_sales AS y
		
-----------------------------------------------------------------------------------------------------------------------------

	-- Compare current sales with the previous year sales per product_name (YEAR OVER YEAR ANALYSIS)
	WITH yearly_product_sales AS (
			SELECT YEAR(f.order_date) AS _year,
				   p.product_name,
				   SUM(f.sales_amount) AS current_sales
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_product p
			ON f.product_key= p.product_key
			WHERE f.order_date IS NOT NULL
			GROUP BY YEAR(f.order_date),p.product_name
			)

		SELECT y._year,
			   y.product_name,
			   y.current_sales,
			   LAG(y.current_sales) OVER (PARTITION BY y.product_name ORDER BY y._year) AS py_sales,
			   y.current_sales-LAG(y.current_sales) OVER (PARTITION BY y.product_name ORDER BY y._year) AS diff_sales,
			   CASE WHEN y.current_sales-LAG(y.current_sales) OVER (PARTITION BY y.product_name ORDER BY y._year) > 0 THEN 'Increase'
					WHEN y.current_sales-LAG(y.current_sales) OVER (PARTITION BY y.product_name ORDER BY y._year) < 0 THEN 'Decraese'
					ELSE 'no change'
				END AS py_change
			   
		FROM yearly_product_sales AS y

-----------------------------------------------------------------------------------------------------------------------------

	-- Compare current sales with the previous month sales (yyyy-mmm) per product_name (MONTH OVER MONTH ANALYSIS)
	WITH monthly_product_sales AS (
			SELECT FORMAT(f.order_date, 'yyyy-MMM') AS year_month,
					p.product_name,
					SUM(f.sales_amount) AS current_sales,
					MIN(f.order_date) AS min_order_date  -- Add this column to order correctly the dates
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_product p
			ON f.product_key = p.product_key
			WHERE f.order_date IS NOT NULL
			GROUP BY FORMAT(f.order_date, 'yyyy-MMM'), p.product_name
			

			)

		SELECT m.year_month,
			   m.product_name,
			   m.current_sales,
			   LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.min_order_date) AS pM_sales,
			   m.current_sales-LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.min_order_date) AS diff_sales,
			   CASE WHEN m.current_sales-LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.min_order_date) > 0 THEN 'Increase'
					WHEN m.current_sales-LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.min_order_date) < 0 THEN 'Decraese'
					ELSE 'no change'
				END AS pm_change
		FROM monthly_product_sales AS m
		ORDER BY m.min_order_date, m.product_name;

		--But let's see a more robust solution using YEAR and MONTH columns separately
		WITH monthly_product_sales AS (
			SELECT 
				YEAR(f.order_date) AS year_,
				MONTH(f.order_date) AS month_,
				FORMAT(f.order_date, 'MMM', 'en-US') AS month_name,  -- Mese abbreviato con la prima lettera maiuscola
				p.product_name,
				SUM(f.sales_amount) AS current_sales,
				MIN(f.order_date) AS min_order_date  -- Per l'ordinamento
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_product p
			ON f.product_key = p.product_key
			WHERE f.order_date IS NOT NULL
			GROUP BY YEAR(f.order_date), MONTH(f.order_date), FORMAT(f.order_date, 'MMM', 'en-US'), p.product_name
		)

		SELECT 
			year_,
			month_,
			m.product_name,
			m.current_sales,
			LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.year_, m.month_) AS pM_sales,
			m.current_sales - LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.year_, m.month_) AS diff_sales,
			CASE 
				WHEN m.current_sales - LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.year_, m.month_) > 0 THEN 'Increase'
				WHEN m.current_sales - LAG(m.current_sales) OVER (PARTITION BY m.product_name ORDER BY m.year_, m.month_) < 0 THEN 'Decrease'
				ELSE 'No Change'
			END AS pm_change
		FROM monthly_product_sales AS m
		ORDER BY m.year_, m.month_, m.product_name;

