/*
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
DDL Script: Create Gold Views --> Create Dimension: gold.dim_product
===============================================================================
*/

--1) Filter for only the most updated information (end date = NULL)
	SELECT prd_id,
		   cat_id,
		   prd_nm,
		   prd_cost,
		   prd_line,
		   prd_start_dt,
		   prd_end_dt
	FROM silver.crm_prd_info AS pn 
	WHERE prd_end_dt IS NULL --Filter out all hsitorical data

----------------------------------------------------------------------------

--2) Join with silver.erp_px_cat_g1v2
	SELECT pn.prd_id,
		   pn.cat_id,
		   pn.prd_nm,
		   pn.prd_cost,
		   pn.prd_line,
		   pn.prd_start_dt,
		   pn.prd_end_dt,
		   pc.cat,
		   pc.subcat,
		   pc.maintenance
	FROM silver.crm_prd_info AS pn 
	LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL --Filter out all historical data

----------------------------------------------------------------------------

--3) Data quality check (uniqueness)
	WITH cte AS(
		SELECT pn.prd_id,
		   pn.cat_id,
		   pn.prd_key,
		   pn.prd_nm,
		   pn.prd_cost,
		   pn.prd_line,
		   pn.prd_start_dt,
		   pn.prd_end_dt,
		   pc.cat,
		   pc.subcat,
		   pc.maintenance
	FROM silver.crm_prd_info AS pn 
	LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL --Filter out all historical data
	)

	SELECT cte.prd_key, COUNT(*)
	FROM cte
	GROUP BY cte.prd_key
	HAVING COUNT(*)>1
	--NO ISSUE

----------------------------------------------------------------------------

--4) Sorting columns & rename + removed end date column
	SELECT pn.prd_id AS product_id,
		   pn.prd_key AS product_number,
		   pn.prd_nm AS product_name,
		   pn.cat_id AS category_id,
		   pc.cat AS category,
		   pc.subcat AS subcategory,
		   pc.maintenance AS maintenance,
		   pn.prd_cost AS cost,
		   pn.prd_line AS product_line,
		   pn.prd_start_dt AS start_date
		   --pn.prd_end_dt this will be removed, not necessary it just shows NULL
		   		   		   
	FROM silver.crm_prd_info AS pn 
	LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL --Filter out all historical data

----------------------------------------------------------------------------

--5) Add suurogate key

	SELECT ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_id) AS product_key,
		   pn.prd_id AS product_id,
		   pn.prd_key AS product_number,
		   pn.prd_nm AS product_name,
		   pn.cat_id AS category_id,
		   pc.cat AS category,
		   pc.subcat AS subcategory,
		   pc.maintenance AS maintenance,
		   pn.prd_cost AS cost,
		   pn.prd_line AS product_line,
		   pn.prd_start_dt AS start_date
		   --pn.prd_end_dt this will be removed, not necessary it just shows NULL
		   		   		   
	FROM silver.crm_prd_info AS pn 
	LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL --Filter out all historical data

----------------------------------------------------------------------------

--6): Create the object (view)
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;
GO
CREATE VIEW gold.dim_product AS
	SELECT ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_id) AS product_key,
		   pn.prd_id AS product_id,
		   pn.prd_key AS product_number,
		   pn.prd_nm AS product_name,
		   pn.cat_id AS category_id,
		   pc.cat AS category,
		   pc.subcat AS subcategory,
		   pc.maintenance AS maintenance,
		   pn.prd_cost AS cost,
		   pn.prd_line AS product_line,
		   pn.prd_start_dt AS start_date
		   --pn.prd_end_dt this will be removed, not necessary it just shows NULL
		   		   		   
	FROM silver.crm_prd_info AS pn 
	LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL --Filter out all historical data
GO

----------------------------------------------------------------------------

--Step 9 : Check quality of the object
SELECT *
FROM gold.dim_product
