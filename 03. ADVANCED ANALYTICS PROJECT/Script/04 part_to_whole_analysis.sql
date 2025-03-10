


--Which categories contribute the most to the overall sales

		WITH cte AS (
			SELECT 
				p.category,
				SUM(f.sales_amount) AS category_sales
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_product p
			ON f.product_key = p.product_key
			GROUP BY p.category
		)
		SELECT 
			category,
			category_sales,
			SUM(category_sales) OVER () AS overall_sales, -- Overall total sales
			ROUND((CAST(category_sales AS FLOAT) / SUM(category_sales) OVER ())*100 , 2)  AS percentage_of_total
		FROM cte
		ORDER BY category_sales DESC

		-- Same query but with percentage expressed as string with '%' character
		WITH cte AS (
			SELECT 
				p.category,
				SUM(f.sales_amount) AS category_sales
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_product p
			ON f.product_key = p.product_key
			GROUP BY p.category
		)
		SELECT 
			category,
			category_sales,
			SUM(category_sales) OVER () AS overall_sales, -- Overall total sales
			CONCAT(ROUND((CAST(category_sales AS FLOAT) / SUM(category_sales) OVER ())*100 , 2), '%')  AS percentage_of_total
		FROM cte
		ORDER BY category_sales DESC
