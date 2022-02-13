--1, get monthly snapshot table
drop table invoice_items_ss;
create table invoice_items_ss as 
with dtes as (--get dates
  select 
    invoiceid
    ,date(i.invoicedate,'start of year','+12 month','-1 day') invoiceyr
    ,date(i.invoicedate,'start of month','+1 month','-1 day') invoicemth
    ,strftime('%Y', i.invoicedate) yr
    ,CASE 
      WHEN cast(strftime('%m', i.invoicedate)as integer) BETWEEN 1 AND 3 THEN 3
      WHEN cast(strftime('%m', i.invoicedate)as integer) BETWEEN 4 AND 6 THEN 6
      WHEN cast(strftime('%m', i.invoicedate)as integer) BETWEEN 7 AND 9 THEN 9
      WHEN cast(strftime('%m', i.invoicedate)as integer) BETWEEN 10 AND 12 THEN 12
      ELSE null 
    END as qtr
  from invoices i
)
select
  --invoices
  i.invoiceid        
  ,i.customerid       
  ,i.invoicedate
  ,d.invoiceyr
  ,d.invoicemth
  ,date(d.yr || '-01-01','+' || d.qtr || ' month','-1 day') as invoiceqtr
  ,i.billingaddress   
  ,i.billingcity      
  ,i.billingstate     
  ,i.billingcountry   
  ,i.billingpostalcode
  ,i.total
  --customers  
  ,c.firstname || ' ' || c.lastname as customername
  ,c.firstname as customerfirstname 
  ,c.lastname  as customerlastname
  ,c.company
  ,c.address      as customeraddress
  ,c.city         as customercity  
  ,c.state        as customerstate 
  ,c.country      as customercountry  
  ,c.postalcode   as customerpostalcode
  ,c.phone        as customerphone    
  ,c.fax          as customerfax      
  ,c.email        as customeremail    
  ,c.supportrepid
  --invoice_items
  ,ii.invoicelineid
  ,ii.trackid
  ,ii.unitprice
  ,ii.quantity
  --tracks_ext
  ,te.albumid   
  ,te.albumtitle  
  ,te.artist--artistid seems not useful
  ,te.name as trackname       
  ,te.mediatype--mediatypeid seems not useful   
  ,te.genre--genreid seems not useful
  ,te.composer    
  ,te.milliseconds
  ,te.bytes       
  ,te.unitprice as trackunitprice   
  ,te.playlistappear
  --employees_hrchy
  ,eh.employeeid  
  ,eh.firstname || ' ' || eh.lastname as employeename
  ,eh.lastname      as employeelastname
  ,eh.firstname     as employeefirstname
  ,eh.title     
  ,eh.reportsto 
  ,eh.birthdate 
  ,eh.hiredate  
  ,eh.address       as employeeaddress  
  ,eh.city          as employeecity           
  ,eh.state         as employeestate         
  ,eh.country       as employeecountry     
  ,eh.postalcode    as employeepostalcode
  ,eh.phone         as employeephone        
  ,eh.fax           as employeefax            
  ,eh.email         as employeeemail        
  ,eh.hierarchy
  ,eh.namehierarchy
from invoices i
left join dtes d
on d.invoiceid = i.invoiceid
left join customers c
on c.customerid = i.customerid
left join invoice_items ii
on ii.invoiceid = i.invoiceid
left join tracks_ext te
on ii.trackid = te.trackid
left join employees_hrchy eh
on eh.employeeid = c.supportrepid
;
select count(1) from invoice_items_ss;

--volumes and exposures:
select * from invoice_items_ss limit 10;

--volume, exposure
select 
  invoiceyr
  ,count(1) n_item
  ,round(sum(unitprice),0) sells 
  ,count(distinct trackid) n_track
  ,count(distinct albumid) n_album
  ,count(distinct artist) n_artist
  ,count(distinct mediatype) n_mediatype
  ,count(distinct genre) n_genre
  ,count(distinct employeeid) n_employee
  ,count(distinct invoiceid) n_invoice
  ,count(distinct customerid) n_customer
  ,count(distinct customercountry) n_country
from invoice_items_ss
group by invoiceyr
order by invoiceyr desc
;

--by top 5 genre
drop table genre_top;
create table genre_top as 
with x as (
select 
  invoiceyr,genre
  ,count(1) n_item
  ,round(sum(unitprice),0) sells 
  ,count(distinct trackid) n_track
  ,count(distinct albumid) n_album
  ,count(distinct artist) n_artist
  ,count(distinct mediatype) n_mediatype
  ,count(distinct genre) n_genre
  ,count(distinct employeeid) n_employee
  ,count(distinct invoiceid) n_invoice
  ,count(distinct customerid) n_customer
  ,count(distinct customercountry) n_country
from invoice_items_ss
group by invoiceyr,genre
order by invoiceyr,sells desc
)
select
  x.*
from x
where x.invoiceyr || '_' || x.genre in (
  select x2.invoiceyr || '_' || x2.genre
  from x x2
  where x2.invoiceyr = x.invoiceyr
  order by x2.sells desc
  limit 5
);

select
  invoiceyr
  ,max(case when genre = 'Rock' then sells else null end) as rock
  ,max(case when genre = 'Latin' then sells else null end) as latin
  ,max(case when genre = 'Metal' then sells else null end) as metal
  ,max(case when genre = 'Alternative & Punk' then sells else null end) as alter_punk
  ,max(case when genre = 'TV Shows' then sells else null end) as tv_show
  ,max(case when genre = 'Jazz' then sells else null end) as jazz
from genre_top
group by invoiceyr
order by invoiceyr desc;


--volume
select 
  count(1) n_item
  ,count(distinct trackid) n_track
  ,count(distinct albumid) n_album
  ,count(distinct artist) n_artist
  ,count(distinct mediatype) n_mediatype
  ,count(distinct genre) n_genre
  ,count(distinct employeeid) n_employee
  ,count(distinct invoiceid) n_invoice
  ,count(distinct customerid) n_customer
  ,count(distinct customercountry) n_country
  ,round(sum(unitprice),0) sells 
from invoice_items_ss
;

--top buyers across time
with x as (
select 
  invoiceyr,customerid
  ,max(customername) customername
  ,round(sum(unitprice),0) total
from invoice_items_ss
group by invoiceyr,customerid
), mx as (
select
  invoiceyr,max(total) total
from x
group by invoiceyr
)
select
  x.*
from mx
left join x on 
x.invoiceyr = mx.invoiceyr 
and x.total = mx.total
;

--top 3 buyer
select 
  invoiceyr,customerid
  ,max(customername) customername
  ,sum(unitprice) total
  ,count(distinct invoiceid) n_invoice
from invoice_items_ss
where invoiceyr = '2013-12-31'
group by invoiceyr,customerid
order by sum(unitprice) desc
limit 3;

















