SELECT
    extract(epoch from timestamp '2030-08-15 03:30:45'),
    timestamp "2030-08-15 03:30:45",
    TO_TIMESTAMP('2017-03-31 9:30:20', 'YYYY-MM-DD HH:MI:SS'),
    date_trunc('day', now())::date,
    start_time,
    start_time + resolution * interval '1 second' as end_time
from table
where time :: date = '2022-08-23'
;


select
    table_catalog,
    table_schema,
    table_name,
    column_name,
    ordinal_position,
    column_default,
    is_nullable,
    data_type,
    character_maximum_length,
    numeric_precision,
    datetime_precision,
    interval_type,
    interval_precision,
    udt_name,
    is_identity,
    is_updatable
from information_schema.columns
where table_schema not in ('information_schema','pg_catalog');


