SELECT cust_id,
	   COUNT(*) AS cnt
FROM bronze.crm_cust_info
GROUP BY cust_id
HAVING cust_id IS NULL OR COUNT(*)> 1
