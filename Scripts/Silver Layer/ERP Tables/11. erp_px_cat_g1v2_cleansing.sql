/*
===============================================================================
Data Cleansing for table erp_px_cat_g1v2
===============================================================================
Script Purpose:
    In this script I did the following modification in the bronze.erp_px_cat_g1v2:
	- Fixes unwanted spaces
	- Data standardization & consistency (check cardinality)

Then I verified the issues were solved and I loaded the cleaned data
in the silver.erp_px_cat_g1v2 with INSERT INTO command
===============================================================================
*/

SELECT id,
	   cat,
	   subcat,
	   maintenance
FROM bronze.erp_px_cat_g1v2


--1) CHECK UNWANTED SPACES
SELECT id,
	   cat,
	   subcat,
	   maintenance
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat OR TRIM(subcat)!=subcat OR TRIM(maintenance)!=maintenance
	--NO ISSUE

-------------------------------------------------

--2) DATA STANDARDIZATION & CONSISTENCY (check cardinality)
	SELECT DISTINCT cat	  
	FROM bronze.erp_px_cat_g1v2

	SELECT DISTINCT subcat
	FROM bronze.erp_px_cat_g1v2

	SELECT DISTINCT maintenance
	FROM bronze.erp_px_cat_g1v2

	-- NO ISSUE

-------------------------------------------------

-- APPLY THE INSERT STATEMENT INSIDE THE silver.erp_loc_a101 TABLE
INSERT INTO silver.erp_px_cat_g1v2(
				id,
				cat,
				subcat,
				maintenance
			)
SELECT id,
	   cat,
	   subcat,
	   maintenance
FROM bronze.erp_px_cat_g1v2

-----------------------------------------------------------------

--DISPLAY THE NEW silver.crm_prd_info TO VERIFY THAT THERE IS EVERYTHING
 SELECT *
 FROM silver.erp_px_cat_g1v2
