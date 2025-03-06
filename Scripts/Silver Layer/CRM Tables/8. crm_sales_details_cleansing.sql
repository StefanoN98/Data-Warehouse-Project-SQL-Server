/*
===============================================================================
Data Cleansing for table crm_sales_details
===============================================================================
Script Purpose:
    In this script I did the following modification in the bronze.crm_sales_details:
	- Check unwanted spaces
	- Check compatibility for the key relation
	- Handling invalid data (CASE WHEN structure, check on LEN, IS NULL)
	- Clean & format date
	- Data type casting (CAST, from INTEGER to DATE)
	- Implement businness rules deriving column (sls_sales and sls_price)


Then I verified the issues were solved and I loaded the cleaned data
in the silver.crm_sales_details with INSERT INTO command
===============================================================================
*/

SELECT *
FROM bronze.crm_sales_details

--1) CHECK UNWANTED SPACES

SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)
--NO ISSUE

--------------------------------------------------------------

--2) CHECK KEY RELATION WITH crm_prd_info & crm_cust_info

	--Check crm_prd_info
	SELECT sls_prd_key
	FROM bronze.crm_sales_details
	WHERE sls_prd_key NOT IN (
							SELECT prd_key
							FROM silver.crm_prd_info
							)
	-- NO ISSUE

	-- Check crm_cust_info
	SELECT sls_cust_id
	FROM bronze.crm_sales_details
	WHERE sls_cust_id NOT IN (
							SELECT cst_id
							FROM silver.crm_cust_info
							)
	-- NO ISSUE

--------------------------------------------------------------

--3) CLEAN & FORMAT DATE

	--3.1 Replace zeros with NULL
SELECT sls_ord_num,
	   sls_prd_key,
	   sls_cust_id,
	   NULLIF(sls_order_dt,0) AS sls_order_dt, --Replaced negative or zero value with NULL
	   NULLIF(sls_ship_dt,0) AS sls_ship_dt, --Replaced negative or zero value with NULL
	   NULLIF(sls_due_dt,0) AS sls_due_dt, --Replaced negative or zero value with NULL
	   sls_sales,
	   sls_quantity,
	   sls_price
FROM bronze.crm_sales_details

	--3.2 Convert in date format
		--3.2.1 Query to test
			SELECT sls_ord_num,
			   NULLIF(sls_order_dt,0) AS sls_order_dt, --Replaced negative or zero value with NULL
			   NULLIF(sls_ship_dt,0) AS sls_ship_dt, --Replaced negative or zero value with NULL
			   NULLIF(sls_due_dt,0) AS sls_due_dt, --Replaced negative or zero value with NULL
			   LEN(sls_order_dt) AS Len_sls_order_dt,
			   LEN(sls_ship_dt) AS Len_sls_ship_dt,
			   LEN(sls_due_dt) AS Len_sls_due_dt

		FROM bronze.crm_sales_details
		WHERE CAST( LEN(sls_order_dt) AS INTEGER) != 8 OR
			  CAST( LEN(sls_ship_dt) AS INTEGER) != 8 OR
			  CAST( LEN(sls_ship_dt) AS INTEGER) != 8

		--3.2.2 Query to fix v1 >> CASE WHEN structure
			SELECT sls_ord_num,
				   sls_prd_key,
				   sls_cust_id,
				   CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!= 8 THEN NULL
						ELSE sls_order_dt
				   END sls_order_dt, --Modified values where there were inconsistencies
				   sls_ship_dt,
				   sls_due_dt, 
				   sls_sales,
				   sls_quantity, 
				   sls_price
			FROM bronze.crm_sales_details


		--3.2.3 Query to fix v2 >> added conversion to date
			SELECT sls_ord_num,
				   sls_prd_key,
				   sls_cust_id,
				   CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!= 8 THEN NULL
						ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
				   END sls_order_dt, --Modified values where there were inconsistencies + added conversion in DATE
				   CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) AS sls_ship_dt, --added conversion in DATE
				   CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) AS sls_due_dt,  --added conversion in DATE
				   sls_sales,
				   sls_quantity,
				   sls_price
			FROM bronze.crm_sales_details

		--3.3 Check for invalid date orders (Verify sls_order_dt always less than sls_ship_dt and sls_due_date)
			SELECT *
			FROM bronze.crm_sales_details
			WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
		--NO ISSUE

--------------------------------------------------------------

--4) VERIFY BUSINESS RULES
	--4.1 Verify price=sales*quantity and null and zero values for sls_sales,sls_quantity and sls_price
			SELECT *
			FROM bronze.crm_sales_details
			WHERE 
				  sls_sales <= 0 OR
				  sls_sales IS NULL OR
				  sls_quantity <= 0 OR
				  sls_quantity IS NULL OR
				  sls_price != sls_sales*sls_quantity OR
				  sls_price <= 0 OR
				  sls_price IS NULL 

	--4.2 Implement rules for sls_sales and sls_price
			SELECT sls_ord_num,
				   sls_prd_key,
				   sls_cust_id,
				   CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!= 8 THEN NULL
						ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
				   END sls_order_dt, --Modified values where there were inconsistencies + added conversion in DATE
				   CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) AS sls_ship_dt, --added conversion in DATE
				   CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) AS sls_due_dt,  --added conversion in DATE

				   CASE WHEN sls_sales IS NULL or sls_sales <=0 OR sls_sales!= sls_quantity * ABS(sls_price)  
						THEN sls_quantity * ABS(sls_price)
						ELSE sls_sales
				   END AS sls_sales, -- rules for sls_sales

				   sls_quantity,

				   CASE WHEN sls_price <=0 OR sls_price IS NULL 
						THEN sls_sales / NULLIF(sls_quantity,0)
						ELSE sls_price 
				   END AS sls_price -- rules for sls_price
			FROM bronze.crm_sales_details
			
-------------------------------------------------------------------------------------------------
-- APPLY THE INSERT STATEMENT INSIDE THE silver.crm_prd_info TABLE		  
		 
INSERT INTO silver.crm_sales_details(
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt, 
				sls_ship_dt, 
				sls_due_dt, 
				sls_sales,
		        sls_quantity,
                sls_price 
			)

	SELECT sls_ord_num,
				   sls_prd_key,
				   sls_cust_id,
				   CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!= 8 THEN NULL
						ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
				   END sls_order_dt, --Modified values where there were inconsistencies + added conversion in DATE
				   CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) AS sls_ship_dt, --added conversion in DATE
				   CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) AS sls_due_dt,  --added conversion in DATE

				   CASE WHEN sls_sales IS NULL or sls_sales <=0 OR sls_sales!= sls_quantity * ABS(sls_price)  
						THEN sls_quantity * ABS(sls_price)
						ELSE sls_sales
				   END AS sls_sales, -- rules for sls_sales

				   sls_quantity,

				   CASE WHEN sls_price <=0 OR sls_price IS NULL 
						THEN sls_sales / NULLIF(sls_quantity,0)
						ELSE sls_price 
				   END AS sls_price -- rules for sls_price
			FROM bronze.crm_sales_details

--DISPLAY THE NEW silver.crm_sales_details TO VERIFY THAT THERE IS EVERYTHING
 SELECT *
 FROM silver.crm_sales_details
