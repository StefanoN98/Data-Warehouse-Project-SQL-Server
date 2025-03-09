/*
===============================================================================
Data Cleansing for table erp_loc_a101
===============================================================================
Script Purpose:
    In this script I did the following modification in the bronze.erp_loc_a101:
	- Handled invalid values
	- Data standardization & consistency (check cardinality)

Then I verified the issues were solved and I loaded the cleaned data
in the silver.erp_loc_a101 with INSERT INTO command
===============================================================================
*/

SELECT *
FROM bronze.erp_loc_a101

--1) REPLACE CHARACTERS

SELECT 
	   REPLACE(cid,'-','') AS cid, --Replace '-' in order to match the key with the cust_info table
	   cntry 
FROM BRONZE.erp_loc_a101

-----------------------------------------------------------------

--2 DATA STANDARDIZATION & CONSISTENCY (check cardianlity)

SELECT 
	   REPLACE(cid,'-','') AS cid, --Replace '-' in order to match the key with the cust_info table
	   CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('USA', 'US')  THEN 'United States'
			WHEN TRIM(cntry)='' OR TRIM(cntry) IS NULL THEN 'n/a'
			ELSE cntry
		END AS cntry  --Normalized and handle missing or blank values
FROM BRONZE.erp_loc_a101

-----------------------------------------------------------------

-- APPLY THE INSERT STATEMENT INSIDE THE silver.erp_loc_a101 TABLE
INSERT INTO silver.erp_loc_a101(
				cid,
				cntry
			)
SELECT 
	   REPLACE(cid,'-','') AS cid, --Replace '-' in order to match the key with the cust_info table
	   CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('USA', 'US')  THEN 'United States'
			WHEN TRIM(cntry)='' OR TRIM(cntry) IS NULL THEN 'n/a'
			ELSE cntry
		END AS cntry  --Normalized and handle missing or blank values
FROM BRONZE.erp_loc_a101

-----------------------------------------------------------------

--DISPLAY THE NEW silver.crm_prd_info TO VERIFY THAT THERE IS EVERYTHING
 SELECT *
 FROM silver.erp_loc_a101
