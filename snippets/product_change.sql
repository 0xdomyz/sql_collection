-- sas_sql

PROC SQL;
   CREATE TABLE WORK.TOTAL AS 
   SELECT 
      COALESCE(A.account_id, B.account_id) AS account_id,
      A.product_type AS cur_product_type,
      B.product_type AS prev_product_type,
      A.balance AS cur_balance,
      B.balance AS prev_balance,
      CASE 
         WHEN A.account_id IS NOT NULL AND B.account_id IS NULL THEN 'NEW'
         WHEN A.account_id IS NULL AND B.account_id IS NOT NULL THEN 'EXIT'
         ELSE 'STAY'
      END AS status_flag
   FROM 
      WORK.TABLE1 AS A
   FULL JOIN 
      WORK.TABLE2 AS B
   ON 
      A.account_id = B.account_id;

   CREATE TABLE WORK.AGGREGATED AS 
   SELECT 
      status_flag,
      COUNT(*) AS total_count,
      SUM(cur_balance) AS total_balance
   FROM 
      WORK.TOTAL
   GROUP BY 
      status_flag;
QUIT;

