SELECT
    extract(epoch from timestamp '2030-08-15 03:30:45'),
    timestamp "2030-08-15 03:30:45",
    TO_TIMESTAMP('2017-03-31 9:30:20', 'YYYY-MM-DD HH:MI:SS'),
    date_trunc('day', now())::date,
from table;



