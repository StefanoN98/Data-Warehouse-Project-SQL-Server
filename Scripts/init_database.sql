/*
==================================================
Create Database and Schemas
==================================================

Script Purpose:
This script creates a new database named 'DataWarehouseProject' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
within the database: 'bronze', 'silver', and 'gold'.

WARNING:
Running this script will drop the entire 'DataWarehouseProject' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/
-----------------------------------------------------------------------------------------------------------------------------

-- CREATE DATABASE
USE master;

-- Best Practice Drop and Recreate the "DataWarehouseProject"
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseProject')
BEGIN
	ALTER DATABASE DataWarehouseProject SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouseProject;
END;
GO

CREATE DATABASE DataWarehouseProject;

USE DataWarehouseProject;

-- CREATE SCHEMAS FOR THE 3 LAYERS
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
