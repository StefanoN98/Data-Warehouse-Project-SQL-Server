/*
===============================================================================
DDL Script: Bulk Insert CSV Into Tables
===============================================================================
Script Purpose:
    This script insert records from cvs into the tables of the 'bronze' schema, truncating tables before,
	in order to not keep old data
	  Run this script to popolate the tables with new records.
===============================================================================
*/

-- LOAD CSV INTO TABLES
USE DataWarehouseProject

-- LOAD DATA INTO bronze.crm_cust_info
TRUNCATE TABLE bronze.crm_cust_info
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Stefano\Desktop\dashboard progetti\SQL Data Warehouse from Scratch  Full Hands On Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH(
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
)

-- LOAD DATA INTO bronze.crm_prd_info
TRUNCATE TABLE bronze.crm_prd_info
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Stefano\Desktop\dashboard progetti\SQL Data Warehouse from Scratch  Full Hands On Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH(
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
)

-- LOAD DATA INTO bronze.crm_sales_details
TRUNCATE TABLE bronze.crm_sales_details
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Stefano\Desktop\dashboard progetti\SQL Data Warehouse from Scratch  Full Hands On Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH(
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
)

-- LOAD DATA INTO bronze.erp_cust_az12
TRUNCATE TABLE bronze.erp_cust_az12
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\Stefano\Desktop\dashboard progetti\SQL Data Warehouse from Scratch  Full Hands On Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH(
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
)

-- LOAD DATA INTO bronze.erp_loc_a101
TRUNCATE TABLE bronze.erp_loc_a101
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\Stefano\Desktop\dashboard progetti\SQL Data Warehouse from Scratch  Full Hands On Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH(
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
)

-- LOAD DATA INTO bronze.erp_px_cat_g1v2
TRUNCATE TABLE bronze.erp_px_cat_g1v2
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\Stefano\Desktop\dashboard progetti\SQL Data Warehouse from Scratch  Full Hands On Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH(
	FIRSTROW=2,
	FIELDTERMINATOR =',',
	TABLOCK
)
