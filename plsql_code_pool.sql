alter session enable parallel dml ddl query;

create synonym tbl for tbl_long;

define tbl = &pre._words

to_char(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI')

begin dbms_output.put_line(&timestamp || 'wrods');
End;
/

begin
    execute immediate 'qry';
    dbms_output.put_line(&timestamp || 'wrods');
exception
    when others then null;
end;
/

declear msg VARCHAR2(200);
declare
    a number := 1;
    b date;
    pragma autonomous_transaction;

BEGIN
    select case when cnt>0 then 'asdf' else 'assdg' end
    into msg from &tbl;
end:
/

BEGIN
    for i in start_n .. end_n loop
        var := var2 + 1
        commit;

        insert into tbl
        select * from tbl2 where col = var;
        commit;
    end loop;
end;
/

set escape on
set verify off feedback off echo off
set tab off
set serveroutput on size 100

whenever sqlerror exit sql.sqlcode

connect

create or replace procedure drop_tbl(tbl in varchar2) 
is
begin 
    execute immediate 'drop table' || tbl || ' purge';
exception when others then null;
end;
/

create or replace procedure counts(tbl in varchar2)
is n number;
begin
    execute immediate 'select count(1) from ' || tbl into n;
end;
/

@@file_nme.sql

exit;