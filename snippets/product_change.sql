-- sas_sql

PROC SQL;
   CREATE TABLE tmp_tbl AS 
   SELECT 
      COALESCE(cur.account_id, prev.account_id) AS account_id,
      cur.product_type AS cur_product_type,
      prev.product_type AS prev_product_type,
      cur.balance AS cur_balance,
      prev.balance AS prev_balance,
      COALESCE(cur.balance, prev.balance) as balance,
      CASE 
         WHEN cur.account_id IS NOT NULL AND prev.account_id IS NULL THEN 'NEW'
         WHEN cur.account_id IS NULL AND prev.account_id IS NOT NULL THEN 'EXIT'
         ELSE 'STAY'
      END AS churn_status
   FROM 
      WORK.TABLE1 AS cur
   FULL JOIN 
      WORK.TABLE2 AS prev
   ON 
      cur.account_id = prev.account_id;

   CREATE TABLE tmp_agg1 AS 
   SELECT 
      churn_status,
      COUNT(*) AS total_count,
      SUM(balance) AS balance
   FROM 
      tmp_tbl
   GROUP BY 
      churn_status;

   CREATE TABLE tmp_agg2 AS 
   SELECT 
      cur_product_type, prev_product_type,
      COUNT(*) AS total_count,
      SUM(balance) AS balance
   FROM 
      tmp_tbl
   where churn_status = 'STAY'
   GROUP BY 1, 2;
run;

