/*
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
DDL Script: Create Gold Views --> Create Dimension: gold.fact_sales
===============================================================================
*/

SELECT sd.sls_ord_num,
	   sd.sls_prd_key,
	   sd.sls_cust_id,
	   sd.sls_order_dt,
	   sd.sls_ship_dt,
	   sd.sls_due_dt,
	   sd.sls_sales,
	   sd.sls_quantity,
	   sd.sls_price
FROM silver.crm_sales_details sd

--1) Join with dimension and implement data look up process
	SELECT sd.sls_ord_num,
		   pr.product_number, --that replace sd.sls_prd_key
		   cu.customer_id, --that replace sd.sls_cust_id
		   sd.sls_order_dt,
		   sd.sls_ship_dt,
		   sd.sls_due_dt,
		   sd.sls_sales,
		   sd.sls_quantity,
		   sd.sls_price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_product pr
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customer cu
	ON sd.sls_cust_id = cu.customer_id

---------------------------------------------------------------------

--2) Sort and rename columns
	SELECT sd.sls_ord_num AS order_number,
		   pr.product_number, --that replace sd.sls_prd_key
		   cu.customer_id AS customer_key, --that replace sd.sls_cust_id
		   sd.sls_order_dt AS order_date,
		   sd.sls_ship_dt AS shipping_date,
		   sd.sls_due_dt AS due_date,
		   sd.sls_sales AS sales_amount,
		   sd.sls_quantity AS quantity,
		   sd.sls_price AS price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_product pr
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customer cu
	ON sd.sls_cust_id = cu.customer_id

---------------------------------------------------------------------

--3) Create the object (view)
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
	CREATE VIEW gold.fact_sales AS
	SELECT sd.sls_ord_num AS order_number,
		   pr.product_number, --that replace sd.sls_prd_key
		   cu.customer_id, --that replace sd.sls_cust_id
		   sd.sls_order_dt AS order_date,
		   sd.sls_ship_dt AS shipping_date,
		   sd.sls_due_dt AS due_date,
		   sd.sls_sales AS sales_amount,
		   sd.sls_quantity AS quantity,
		   sd.sls_price AS price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_product pr
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customer cu
	ON sd.sls_cust_id = cu.customer_id
GO

---------------------------------------------------------------------

--Step 9 : Check quality of the object
SELECT *
FROM gold.fact_sales
