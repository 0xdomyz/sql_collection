-- Step 1: Assign row numbers globally and within each (id, flag) group
WITH numbered AS (
    SELECT id
         , event_date
         , event_flag
         , ROW_NUMBER() OVER (PARTITION BY id ORDER BY event_date) AS rn_all
         , ROW_NUMBER() OVER (PARTITION BY id, event_flag ORDER BY event_date) AS rn_by_flag
    FROM events
),

-- Step 2: Create group ID based on row number difference
grouped AS (
    SELECT id
         , event_date
         , event_flag
         , rn_all - rn_by_flag AS grp_id
    FROM numbered
)

-- Step 3: Aggregate to get start/end dates and event length
SELECT id
     , MIN(event_date) AS start_date
     , MAX(event_date) AS end_date
     , event_flag
     , (CAST(MAX(event_date) AS DATE) - CAST(MIN(event_date) AS DATE) + 1) AS event_length_days
FROM grouped
GROUP BY id, grp_id, event_flag
ORDER BY id, start_date;