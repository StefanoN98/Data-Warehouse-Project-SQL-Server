/*===============================================================================
DDL Script: Create Gold Views -->Create Dimension: gold.dim_customer
===============================================================================*/

/*Step 1 : choose the columns I want to keep from silver.crm_cust_info
		   then assign an alias (ci) */
		SELECT ci.cst_id,
			   ci.cst_key,
			   ci.cst_firstname,
			   ci.cst_lastname,
			   ci.cst_marital_status,
			   ci.cst_gndr,
			   ci.cst_create_date
		FROM silver.crm_cust_info AS ci

-------------------------------------------------------------------------------------

/*Step 2 : join the table with silver.erp_cust_az12 (alias ca)
		   then add bdate e gen from ca */
		SELECT ci.cst_id,
			   ci.cst_key,
			   ci.cst_firstname,
			   ci.cst_lastname,
			   ci.cst_marital_status,
			   ci.cst_gndr,
			   ci.cst_create_date,
			   ca.bdate,
			   ca.gen
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
	
-------------------------------------------------------------------------------------	

/*Step 3 : join the table with silver.erp_loc_a101  (alias la)
		   then cntry from la */
		SELECT ci.cst_id,
			   ci.cst_key,
			   ci.cst_firstname,
			   ci.cst_lastname,
			   ci.cst_marital_status,
			   ci.cst_gndr,
			   ci.cst_create_date,
			   ca.bdate,
			   ca.gen,
			   la.cntry
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid

	--Check --> verify that after the join there are still not duplicates on cst_id
		WITH cte AS (
				SELECT ci.cst_id,
			   ci.cst_key,
			   ci.cst_firstname,
			   ci.cst_lastname,
			   ci.cst_marital_status,
			   ci.cst_gndr,
			   ci.cst_create_date,
			   ca.bdate,
			   ca.gen,
			   la.cntry
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid
		)

		SELECT cst_id, COUNT(*)
		FROM cte
		GROUP BY cst_id
		HAVING COUNT(*)>1

-------------------------------------------------------------------------------------

--Step 4 : Data Integration on the 2 genders columns
		--Query to check combination
			SELECT DISTINCT 
					ci.cst_gndr,
					ca.gen

			FROM silver.crm_cust_info AS ci
			LEFT JOIN silver.erp_cust_az12 AS ca
			ON ci.cst_key = ca.cid
			LEFT JOIN silver.erp_loc_a101 AS la
			ON ci.cst_key = la.cid
			ORDER BY 1,2

		--Check query where values are present, but don't match (consider values from ci table, so cst_gndr values)
		SELECT DISTINCT 
					ci.cst_gndr,
					CASE WHEN ci.cst_gndr!= 'n/a' THEN ci.cst_gndr  --crm is the master for gender info
						 ELSE COALESCE(ca.gen,'n/a')
					END AS new_gen 

			FROM silver.crm_cust_info AS ci
			LEFT JOIN silver.erp_cust_az12 AS ca
			ON ci.cst_key = ca.cid
			LEFT JOIN silver.erp_loc_a101 AS la
			ON ci.cst_key = la.cid
			ORDER BY 1,2

		--Write final query fixed
		SELECT ci.cst_id,
			   ci.cst_key,
			   ci.cst_firstname,
			   ci.cst_lastname,
			   ci.cst_marital_status,
			   ci.cst_gndr,
					CASE WHEN ci.cst_gndr!= 'n/a' THEN ci.cst_gndr  --crm is the master for gender info
						 ELSE COALESCE(ca.gen,'n/a')
					END AS new_gen,
			   ci.cst_create_date,
			   ca.bdate,
			   la.cntry
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid

-------------------------------------------------------------------------------------

--Step 5 : Rename columns with a friendly e meaningful name
	SELECT	   ci.cst_id AS customer_id,
			   ci.cst_key AS customer_number,
			   ci.cst_firstname AS first_name,
			   ci.cst_lastname AS last_name,
			   ci.cst_marital_status AS marital_status,
			   ci.cst_gndr,
					CASE WHEN ci.cst_gndr!= 'n/a' THEN ci.cst_gndr  --crm is the master for gender info
						 ELSE COALESCE(ca.gen,'n/a')
					END AS gender,
			   ci.cst_create_date AS create_date,
			   ca.bdate AS birthdate,
			   la.cntry as country
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid

-------------------------------------------------------------------------------------

--Step 6 : Sort columns into logicals groups to improve readability
		SELECT ci.cst_id AS customer_id,
			   ci.cst_key AS customer_number,
			   ci.cst_firstname AS first_name,
			   ci.cst_lastname AS last_name,
			   la.cntry as country,
			   ci.cst_marital_status AS marital_status,
			   ci.cst_gndr,
					CASE WHEN ci.cst_gndr!= 'n/a' THEN ci.cst_gndr  --crm is the master for gender info
						 ELSE COALESCE(ca.gen,'n/a')
					END AS gender,
			   ca.bdate AS birthdate,
			   ci.cst_create_date AS create_date	  
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid

-------------------------------------------------------------------------------------

--Step 7 : Generate surrogate key
		SELECT ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
			   ci.cst_id AS customer_id,
			   ci.cst_key AS customer_number,
			   ci.cst_firstname AS first_name,
			   ci.cst_lastname AS last_name,
			   la.cntry as country,
			   ci.cst_marital_status AS marital_status,
			   ci.cst_gndr,
					CASE WHEN ci.cst_gndr!= 'n/a' THEN ci.cst_gndr  --crm is the master for gender info
						 ELSE COALESCE(ca.gen,'n/a')
					END AS gender,
			   ca.bdate AS birthdate,
			   ci.cst_create_date AS create_date	  
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid

-------------------------------------------------------------------------------------

--Step 8 : Create the object
CREATE VIEW gold.dim_customer AS
		SELECT ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
			   ci.cst_id AS customer_id,
			   ci.cst_key AS customer_number,
			   ci.cst_firstname AS first_name,
			   ci.cst_lastname AS last_name,
			   la.cntry as country,
			   ci.cst_marital_status AS marital_status,
			   ci.cst_gndr,
					CASE WHEN ci.cst_gndr!= 'n/a' THEN ci.cst_gndr  --crm is the master for gender info
						 ELSE COALESCE(ca.gen,'n/a')
					END AS gender,
			   ca.bdate AS birthdate,
			   ci.cst_create_date AS create_date	  
		FROM silver.crm_cust_info AS ci
		LEFT JOIN silver.erp_cust_az12 AS ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid

-------------------------------------------------------------------------------------

--Step 9 : Chekc quality of the object
SELECT *
FROM gold.dim_customer
