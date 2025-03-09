/*
===============================================================================
DIMENSION EXPLORATION
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

	--Granularity check using DISTINCT --> retrieve a list of unique values

		--Countries Analysis
			SELECT DISTINCT country
			FROM gold.dim_customer
			ORDER BY country;


		--Categoris Analysis ('The major divisions')
			SELECT DISTINCT 
					 category 
			FROM gold.dim_product
			ORDER BY category, subcategory, product_name;


		--Categoris Analysis + Subcategories
			SELECT DISTINCT 
					 category, 
					 subcategory
			FROM gold.dim_product
			ORDER BY category, subcategory, product_name;


		--Categoris Analysis + Subcategories + Prodcut_name
			SELECT DISTINCT 
					 category, 
					 subcategory, 
					 product_name 
			FROM gold.dim_product
			ORDER BY category, subcategory, product_name;
