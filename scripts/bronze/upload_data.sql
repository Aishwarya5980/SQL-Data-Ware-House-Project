CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		DECLARE @batch_start_time DATETIME;
		DECLARE @batch_end_time DATETIME;
		 

		DECLARE @start_time DATETIME;
		DECLARE @end_time DATETIME;
		SET @batch_start_time = GETDATE();
		PRINT'========================================';
		PRINT'Loading data into bronze layer...';
		PRINT'========================================';

		PRINT'------------------------------';
		PRINT'Loading data into bronze.crm...';
		PRINT'------------------------------';
		SET @start_time = GETDATE();
		PRINT'>>  TRUNCATE TABLE bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT'>>  BULK INSERT bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Guest -01\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';

		SET @start_time = GETDATE();
		PRINT'>>TRUNCATE TABLE bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT'>>  BULK INSERT bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Guest -01\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';

		SET @start_time = GETDATE();
		PRINT'>>TRUNCATE TABLE bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT'>>  BULK INSERT bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Guest -01\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';


		PRINT'------------------------------';
		PRINT'Loading data into bronze.ERP...';
		PRINT'------------------------------';

		SET @start_time = GETDATE();
		PRINT'>> TRUNCATE TABLE bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT'>> BULK INSERT bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Guest -01\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';

		SET @start_time = GETDATE();
		PRINT'>>  TRUNCATE TABLE bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT'>>  BULK INSERT bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Guest -01\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';

		SET @start_time = GETDATE();
		PRINT'>>  TRUNCATE TABLE bronze.erp_px_g1v2';
		TRUNCATE TABLE bronze.erp_px_g1v2;
		PRINT'>>  BULK INSERT bronze.erp_px_g1v2';
		BULK INSERT bronze.erp_px_g1v2
		FROM 'C:\Users\Guest -01\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.erp_px_g1v2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';

		SELECT COUNT(*) FROM bronze.crm_cust_info;
		SELECT COUNT(*) FROM bronze.crm_sales_details;
		SELECT COUNT(*) FROM bronze.erp_loc_a101;
		SELECT COUNT(*) FROM bronze.crm_prd_info;
		SELECT COUNT(*) FROM bronze.erp_cust_az12;
		SELECT COUNT(*) FROM bronze.erp_px_g1v2;
	END TRY
	BEGIN CATCH
		PRINT'========================================';
		PRINT'Error loading data into bronze layer: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50)) ;
		
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR(50));
		PRINT'========================================';
	END CATCH
	SET @batch_end_time= GETDATE();
	PRINT'========================================';
	PRINT 'TOTAL TIME TAKEN TO LOAD BRONZE LAYER: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(50)) + ' seconds';
END

EXEC bronze.load_bronze;

