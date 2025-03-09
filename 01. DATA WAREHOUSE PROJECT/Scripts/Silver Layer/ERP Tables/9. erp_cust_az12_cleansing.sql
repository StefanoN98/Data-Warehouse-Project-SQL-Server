/*
===============================================================================
Data Cleansing for table erp_cust_az12
===============================================================================
Script Purpose:
    In this script I did the following modification in the bronze.erp_cust_az12:
	- Identify out of range date
	- Data standardization & consistency

Then I verified the issues were solved and I loaded the cleaned data
in the silver.erp_cust_az12 with INSERT INTO command
===============================================================================
*/

SELECT cid,
	   bdate,
	   gen
FROM bronze.erp_cust_az12

--1) DATA QUALITY STANDARDIZATION (cid column)

SELECT 
	   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LEN(cid))
	   ELSE cid
	   END AS cid,
	   bdate,
	   gen
FROM bronze.erp_cust_az12

	--Verify if some keys are missing in the silver.crm_cust_info
	SELECT 
	   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LEN(cid))
	        ELSE cid
	   END AS cid, --Remove 'NAS' prefix if present
	   bdate,
	   gen
	FROM bronze.erp_cust_az12
	WHERE  CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LEN(cid))
		   ELSE cid
	       END  NOT IN (
		   			SELECT DISTINCT cst_key
					FROM silver.crm_cust_info
					)

------------------------------------------------------------------------

--2) FIX BIRTHDAY RANGE COLUMN (Identify out of range date)
	--Check Range
		SELECT 
			   MIN(bdate) min_date,
			   MAX(bdate) max_date
		FROM bronze.erp_cust_az12

	--Build the query
SELECT 
	   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LEN(cid))
	        ELSE cid
	   END AS cid, --Remove 'NAS' prefix if present
	   CASE WHEN bdate > GETDATE() THEN NULL
	        ELSE bdate
	   END AS bdate, --Set future birthday to NULL
	   gen
FROM bronze.erp_cust_az12

------------------------------------------------------------------------

--3) DATA QUALITY STANDARDIZATION (gen column)
	--Verify cardinality
	SELECT DISTINCT gen
	FROM bronze.erp_cust_az12

		--Build the query
SELECT 
	   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LEN(cid))
		    ELSE cid
	   END AS cid, --Remove 'NAS' prefix if present
	   CASE WHEN bdate > GETDATE() THEN NULL
	        ELSE bdate
	   END AS bdate, --Set future birthday to NULL
	   CASE WHEN UPPER(TRIM(gen)) IN ('MALE','M') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('FEMALE','M') THEN 'Female'
			ELSE 'n/a' 
	   END AS gen --Normalize gender values and handle unknown cases
FROM bronze.erp_cust_az12

------------------------------------------------------------------------

-- APPLY THE INSERT STATEMENT INSIDE THE silver.crm_prd_info TABLE
INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
			)
SELECT 
	   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LEN(cid))
		    ELSE cid
	   END AS cid, --Remove 'NAS' prefix if present
	   CASE WHEN bdate > GETDATE() THEN NULL
	        ELSE bdate
	   END AS bdate, --Set future birthday to NULL
	   CASE WHEN UPPER(TRIM(gen)) IN ('MALE','M') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('FEMALE','M') THEN 'Female'
			ELSE 'n/a'
	   END AS gen --Normalize gender values and handle unknown cases
FROM bronze.erp_cust_az12

--DISPLAY THE NEW silver.crm_prd_info TO VERIFY THAT THERE IS EVERYTHING
 SELECT *
 FROM silver.erp_cust_az12
