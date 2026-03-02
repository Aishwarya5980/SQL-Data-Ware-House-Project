USE dataWarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY

        DECLARE @batch_start_time DATETIME;
        DECLARE @batch_end_time DATETIME;
        DECLARE @start_time DATETIME;
        DECLARE @end_time DATETIME;

        SET @batch_start_time = GETDATE();

        PRINT '========================================';
        PRINT 'Loading data into Silver Layer...';
        PRINT '========================================';


        /* ===============================
           CRM TABLES
        =============================== */

        PRINT 'Loading silver.crm_cust_info...';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.crm_cust_info;

        INSERT INTO silver.crm_cust_info
        (
            cust_id,
            cust_key,
            cust_firstname,
            cust_lastname,
            cust_material_status,
            cust_gndr,
            cust_create_date,
            dwh_create_date
        )
        SELECT
            cust_id,
            cust_key,
            cust_firstname,
            cust_lastname,
            cust_material_status,
            cust_gndr,
            cust_create_date,
            GETDATE()
        FROM bronze.crm_cust_info;

        SET @end_time = GETDATE();
        PRINT 'Time taken: ' 
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) 
        + ' seconds';


        /* ===============================
           PRODUCT INFO
        =============================== */

        PRINT 'Loading silver.crm_prd_info...';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.crm_prd_info;

        INSERT INTO silver.crm_prd_info
        SELECT
            prd_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt,
            GETDATE()
        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT 'Time taken: ' 
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) 
        + ' seconds';


        /* ===============================
           SALES DETAILS
        =============================== */

        PRINT 'Loading silver.crm_sales_details...';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.crm_sales_details;

        INSERT INTO silver.crm_sales_details
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price,
            GETDATE()
        FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();
        PRINT 'Time taken: ' 
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) 
        + ' seconds';


        /* ===============================
           ERP TABLES
        =============================== */

        PRINT 'Loading silver.erp_loc_a101...';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.erp_loc_a101;

        INSERT INTO silver.erp_loc_a101
        SELECT
            CID,
            CNTRY,
            GETDATE()
        FROM bronze.erp_loc_a101;

        SET @end_time = GETDATE();
        PRINT 'Time taken: ' 
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) 
        + ' seconds';


        PRINT 'Loading silver.erp_cust_az12...';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.erp_cust_az12;

        INSERT INTO silver.erp_cust_az12
        SELECT
            CID,
            BDATE,
            GEN,
            GETDATE()
        FROM bronze.erp_cust_az12;

        SET @end_time = GETDATE();
        PRINT 'Time taken: ' 
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) 
        + ' seconds';


        PRINT 'Loading silver.erp_px_g1v2...';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.erp_px_g1v2;

        INSERT INTO silver.erp_px_g1v2
        SELECT
            id,
            cat,
            subcat,
            maintenance,
            GETDATE()
        FROM bronze.erp_px_g1v2;

        SET @end_time = GETDATE();
        PRINT 'Time taken: ' 
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) 
        + ' seconds';


        SET @batch_end_time = GETDATE();

        PRINT '========================================';
        PRINT 'TOTAL TIME TAKEN TO LOAD SILVER LAYER: '
        + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(50))
        + ' seconds';
        PRINT '========================================';

    END TRY
    BEGIN CATCH

        PRINT '========================================';
        PRINT 'Error loading Silver Layer';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT '========================================';

    END CATCH
END
GO
EXEC silver.load_silver;
