/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/* Segment products into cost ranges and
	count how many products fall into each segment*/
	WITH cte AS(
		SELECT product_key,
			   product_name,
			   cost,
			   CASE WHEN cost<100 THEN 'Below 100'
					WHEN cost BETWEEN 100 AND 500 THEN '100-500'
					WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			   ELSE 'Above 1000'
			   END AS cost_range
			   FROM gold.dim_product
			)
		
		SELECT cost_range,
			   COUNT(product_key) AS counting
	    FROM cte
		GROUP BY cost_range
		ORDER BY counting DESC

--------------------------------------------------------------------------------------------------------

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

	WITH cte AS(
			SELECT c.customer_key AS customer_key,
				   SUM(f.sales_amount) as total_sales,
				   MIN(f.order_date) as first_order_date,
				   MAX(f.order_date) as last_order_date,
				   DATEDIFF(month,MIN(f.order_date),MAX(f.order_date)) AS lifespan
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_customer c
			ON f.customer_key =c.customer_key
			GROUP BY c.customer_key
		),

		cte2 AS(
			SELECT	customer_key,
					total_sales,
					lifespan,
					CASE WHEN lifespan <= 12 THEN 'New'
						 WHEN lifespan > 12 AND total_sales <= 5000 THEN 'Regular' 
						 WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
					END AS customer_segment
			FROM cte
		)

	SELECT customer_segment,
		   COUNT(customer_key) total_customer
	FROM cte2
	WHERE customer_segment IS NOT NULL
	GROUP BY customer_segment
	ORDER BY total_customer DESC
				
	



