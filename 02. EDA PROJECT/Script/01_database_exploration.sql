/*
===============================================================================
DATABASE EXPLORATION
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

	-- Retrieve a list of all TABLES in the database
		--TABLES
			SELECT TABLE_CATALOG, 
				   TABLE_SCHEMA, 
				   TABLE_NAME, 
				   TABLE_TYPE
			FROM INFORMATION_SCHEMA.TABLES

--------------------------------------------------------------

	-- Retrieve all columns for a specific table
		-- For example focus on dim_customer table
			SELECT *
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME ='dim_customer'

		--Instead of retrieve all the columns, focus on just the most important/useful
			SELECT 
				  COLUMN_NAME, 
				  DATA_TYPE, 
				  IS_NULLABLE, 
				  CHARACTER_MAXIMUM_LENGTH
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'dim_customer';
