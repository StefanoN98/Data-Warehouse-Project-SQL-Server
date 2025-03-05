/*
===============================================================================
Data Cleansing for table crm_cust_info
===============================================================================
Script Purpose:
    In this script I did the following modification in the bronze.crm_cust_info:
	- Remove duplicates
	- Handle missing values
	- Check quality values through standardization & consistency

Then I verified the issues were solved and I loaded the cleaned data
in the silver.crm_cust_info with INSERT INTO command
===============================================================================
*/



-- 1) CHECK FOR DUPLICATES OR NULL VALUES IN THE PRIMARY KEY

SELECT cst_id, COUNT(*) as Counting
FROM bronze.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL

    -- Query to fix the issue
	SELECT *
		FROM (
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as Ranking
			FROM bronze.crm_cust_info
			) as sub
		WHERE sub.Ranking = 1  --Select Most Recent Record per customer
			  AND cst_id IS NOT NULL

-------------------------------------------------------------------------------------------------------
		
-- 2) CHECK FOR UNWANTED SPACES
SELECT     cst_id,
	   cst_key,
	   TRIM(cst_firstname) AS cst_firstname,  --Column Fixed Unwanted Space
	   TRIM(cst_lastname) AS cst_lastname,    --Column FIxed Unwanted Space
	   cst_marital_status,
	   cst_gndr,
	   cst_create_date
FROM (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as Ranking
	FROM bronze.crm_cust_info
	) as sub
WHERE sub.Ranking = 1 --Select Most Recent Record per customer
AND cst_id IS NOT NULL

-------------------------------------------------------------------------------------------------------
-- 3) CHECK QUALITY VALUES (STANDARDIZATION & CONSISTENCY)
SELECT  cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,  --Column Fixed Unwanted Space
	TRIM(cst_lastname) AS cst_lastname,    --Column FIxed Unwanted Space
	CASE    WHEN UPPER(TRIM(cst_gndr)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Married'
		ELSE 'n/a' 
	END cst_marital_status, --Column Replace Values to a more readable format
	CASE    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'FìM' THEN 'Male'
		ELSE 'n/a'  
	END cst_gndr, --Column Replace Values to a more readable format
	cst_create_date
FROM (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as Ranking
	FROM bronze.crm_cust_info
      ) as sub
WHERE sub.Ranking = 1 --Select Most Recent Record per customer
AND cst_id IS NOT NULL

-------------------------------------------------------------------------------------------------------

-- APPLY THE INSERT STATEMENT INSIDE THE silver.crm_cust_info TABLE
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname, 
	cst_marital_status,
	cst_gndr,
	cst_create_date
)

SELECT cst_id,
	   cst_key,
	   TRIM(cst_firstname) AS cst_firstname,  --Column Fixed Unwanted Space
	   TRIM(cst_lastname) AS cst_lastname,    --Column FIxed Unwanted Space
	   CASE WHEN UPPER(TRIM(cst_gndr)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Married'
		ELSE 'n/a' 
	   END cst_marital_status, --Column Replace Values to a more readable format
	   
	   CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'FìM' THEN 'Male'
		ELSE 'n/a'  
	   END cst_gndr, --Column Replace Values to a more readable format
	   cst_create_date
FROM (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as Ranking
	FROM bronze.crm_cust_info
      ) as sub
WHERE sub.Ranking = 1 --Select Most Recent Record per customer
AND cst_id IS NOT NULL
