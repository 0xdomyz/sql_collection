--create
create table tbl(col varchar2(20));
create table tbl(col varchar2(20)) compress for all operations;
partition by range(col)
(
    partition p1 values less than ('01-jan-2050'),
    partition p2 values less than ('01-jan-2100'),
    partition p2 values less than (maxvalue)
)
compress;
commit;


--insert
insert into tbl values ('','');
insert into tbl (col,col2) values ('','');
insert all
    into tbl values ('','')
    into tbl values ('','');


--update
update tbl set col = col2+1;commit;
update tbl set col = col2+1 where col3 =1;commit;


--delete
delete from tbl where col = '';


--add drop column
alter table tbl add col varchar2(20);

alter table tbl drop column col;
alter table tbl drop (col1,col2);
alter table tbl set unused (col1,col2);
alter table tbl drop unused columns;


--rename
alter table tbl rename column old_nme to new_nme;
alter table tbl rename to tbl2;


--constraint index
constraint name primary key (col1, col2);
alter table tbl add constraint name primary key (col1);
alter table tbl drop constraint name;
alter table tbl disable constraint name;

alter index name rebuild compress;
create index name_i on tbl(col);


--pivot
select * from (SELECT col, col2 from tbl)
pivot (
    sum(col) as col, count(col) as scol 
    for col2 in ('a' a, 'b' b)
)


--function
select 
    upper(col),
    to_number(col),
    to_date(col, 'YYYY-MM-DD'),
    to_char(col, 'YYYYMMDD'),
    last_day(dte),
    add_months(last_day(dte), 3) - 1,
    date(dte),
    convert(datetime,'2999-12-31'),
    dateadd(months, -3, dte),
    months_between(dte1,dte2),
    date_diff(dte,dte2),
    ora_hash(col1 || col2),
    count(distinct col1 || col2),
    greatest(a,b,c),
    nvl(a,0),
    regexp_substr(col,'\w+'),
    regexp_substr(col,'\d+'),
    regexp_substr(col,'\d+', 1, 1),
    regexp_substr(col,'\d+', 1, 1, 'c', 1),
    regexp_replace(col, '^[^\d]+_(\d+)','\1'),
    row_number() over (partition by col order by col2 desc),
    row_number() over (order by (10)),
    max(case when col>1 then 1 else 0 end),
    max(col) 
        keep (dense_rank first order by col2 desc nulls last) 
        over (partition by col2),
    extract(year from col),
    utl_match.edit_distance_similarity(a,b),
    list_agg(distinct col, ',') as col,
    concat('7',chr(37))
from tbl
where 
    regexp_like(col,'^(ab|bc)-.+') and
    bitand(col,1)>0

--agg function
select
    col,
    max(a) keep (dense_rank first order by b desc),
    count(1),
    sum(case when a is null then 1 else 0 end),
    avg(col),
    percentile_cont(0.1) within group as pct_10,
    max(decode(col, 'a', col2))
from tbl
group by col


--connect by
select 
    add_months(last_day(to_date('1-jan-2020')), level) dte
from dual
connect by level <=10


--admin
grant select on tbl to owner;
alter table tbl set unused(col1);

update tbl set col = sysdate;
update tbl set col = sys_context('OS_USER','USERENV');
commit;

drop table tbl purge;

select * from tbl1
minus
select * from tbl2

select * from user_tab_privs
select * from user_role_privs

select * from v$session
where osuser = '' order by logon_time, sid

select * from all_tab_columns
where owner = '' and column_name like '%col%'

alter table tbl add ts date;
update tbl set ts = sysdate;
commit;


--sqlldr
sqlldr name/pass control='path' log='path'

ctl file:
load data
    infile 'path'
    into table name
    fields terminated by "," optionally enclosed by '"'
    (col1, col2, col3)



