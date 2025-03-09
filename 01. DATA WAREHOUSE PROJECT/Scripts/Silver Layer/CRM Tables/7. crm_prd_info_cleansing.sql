/*
===============================================================================
Data Cleansing for table crm_prd_info
===============================================================================
Script Purpose:
    In this script I did the following modification in the bronze.crm_prd_info:
	- Remove duplicates
	- Split and derived new column (cat_id)
	- Handle missing/null values with ISNULL
	- Removed unwanted spaces
	- Check for negative & null values in a numeric column
	- Check quality values through standardization & consistency (CASE WHEN structure)
	- Data Enrichment --> Check invalid date and changed format (LEAD, CAST)

Then I verified the issues were solved and I loaded the cleaned data
in the silver.crm_prd_info with INSERT INTO command
===============================================================================
*/

SELECT *
FROM BRONZE.crm_prd_info


-- 1) CHECK FOR DUPLICATES OR NULL VALUES IN THE PRIMARY KEY

SELECT prd_id, COUNT(*) as Counting
FROM bronze.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- *NO ISSUE*
-------------------------------------------------------------------------------------------------------
 --2) SPLIT AND DERIVE NEW COLUMNS
SELECT prd_id,
	   REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --Extract first 5 characters and replace minus with underscore
	   SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --Extract remaining chracters
	   prd_nm,
	   prd_cost,
	   prd_line,
	   prd_start_dt,
	   prd_end_dt
FROM bronze.crm_prd_info

-------------------------------------------------------------------------------------------------------

--3)REMOVE UNWANTED SPACES

	--Check column prd_nm
	SELECT prd_nm
	FROM bronze.crm_prd_info
	WHERE prd_nm != TRIM(prd_nm)
	-- NO ISSUE

-------------------------------------------------------------------------------------------------------

--4)CHECK NEGATIVE OR NULL VALUES IN NUMERIC COLUMN
SELECT prd_id,
	   REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --Extract first 5 characters and replace minus with underscore
	   SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --Extract remaining chracters
	   prd_nm,
	   ISNULL(prd_cost,0) AS prd_cost, --use COALESCE as alternative function: COALESCE(prd_cost, 0)
	   prd_line,
	   prd_start_dt,
	   prd_end_dt
FROM bronze.crm_prd_info

-------------------------------------------------------------------------------------------------------

--5)DATA STANDARDIZATION & CONSISTENCY
SELECT prd_id,
	   REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --Extract first 5 characters and replace minus with underscore
	   SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --Extract remaining chracters
	   prd_nm,
	   ISNULL(prd_cost,0) AS prd_cost, --use COALESCE as alternative function: COALESCE(prd_cost, 0)
	   CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,  
	   prd_start_dt,
	   prd_end_dt
FROM bronze.crm_prd_info

-------------------------------------------------------------------------------------------------------

--6) CHECK FOR INVALID DATE

	-- Check if there are end date before start date
	SELECT *
	FROM bronze.crm_prd_info
	WHERE prd_end_dt < prd_start_dt

	--Build the query testing on some records with issue
	SELECT *,
		LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS 'New end date' 
	FROM bronze.crm_prd_info
	WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509')

--Build the final query with also previous fixing
SELECT prd_id,
	   REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --Extract first 5 characters and replace minus with underscore
	   SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --Extract remaining chracters
	   prd_nm,
	   ISNULL(prd_cost,0) AS prd_cost, --use COALESCE as alternative function: COALESCE(prd_cost, 0)
	   CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,
	   CAST(prd_start_dt AS DATE) AS prd_start_date,  --Changed format as DATE
	   CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt --FIxed with correct date & changed format as DATE
FROM bronze.crm_prd_info

-------------------------------------------------------------------------------------------------------

-- APPLY THE INSERT STATEMENT INSIDE THE silver.crm_prd_info TABLE
INSERT INTO silver.crm_prd_info (
    prd_id,
	cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)

SELECT prd_id,
	   REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --Extract first 5 characters and replace minus with underscore
	   SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --Extract remaining chracters
	   prd_nm,
	   ISNULL(prd_cost,0) AS prd_cost, --use COALESCE as alternative function: COALESCE(prd_cost, 0)
	   CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,
	   CAST(prd_start_dt AS DATE) AS prd_start_date,  --Changed format as DATE
	   CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt --Changed format as DATE
FROM bronze.crm_prd_info


--DISPLAY THE NEW silver.crm_prd_info TO VERIFY THAT THERE IS EVERYTHING
 SELECT *
 FROM silver.crm_prd_info 
