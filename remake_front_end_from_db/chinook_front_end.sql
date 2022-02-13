--front end

--extend tracks by related tables
-- albums, artists
-- media types, genres
-- playlist track
drop table tracks_ext;
create table tracks_ext as
with tp as (
  select trackid,group_concat(playlistid,',') playlistappear
  from playlist_track
  group by trackid
)
select  
  tk.albumid
  ,ab.title albumtitle
  ,at.name artist
  ,tk.trackid
  ,tk.name
  ,mt.name mediatype
  ,g.name genre
  ,tk.composer
  ,tk.milliseconds
  ,tk.bytes
  ,tk.unitprice
  ,tp.playlistappear
from tracks tk
left join albums ab
on ab.albumid = tk.albumid
left join media_types mt
on mt.mediatypeid = tk.mediatypeid
left join genres g
on g.genreid = tk.genreid
left join artists at
on at.artistid = ab.artistid
left join tp
on tp.trackid = tk.trackid
;

select count(1) from tracks_ext;

--extend playlist by tracks info
--  tables: playlist_tracks, and tracks_ext
drop table playlist_ext;
create table playlist_ext as
select 
  p.playlistid
  ,p.name
  ,pt.trackid
  ,te.name trackname
  ,te.albumtitle
  ,te.artist 
from playlists p
left join playlist_track pt
on pt.playlistid = p.playlistid
left join tracks_ext te
on te.trackid = pt.trackid
;

select count(1) from playlist_ext;

--employee
-- add hirarchy info
drop table employees_hrchy;
create table employees_hrchy as
with RECURSIVE hrchy(employeeid,reportsto,reportstoname) AS (
    select 
      employeeid
      ,employeeid reportsto
      ,firstname reportstoname 
    from employees
    UNION
    SELECT 
      h.employeeid
      ,e.reportsto
      ,e2.firstname reportstoname 
    FROM hrchy h
    left join employees e
    on e.employeeid = h.reportsto
    left join employees e2
    on e2.employeeid = e.reportsto
), hrchy_grp as (
SELECT --*
  employeeid
  ,group_concat(reportsto,'>') hierarchy
  ,group_concat(reportstoname,'>') namehierarchy
FROM hrchy
group by employeeid
)
select 
  e.*
  ,hg.hierarchy
  ,hg.namehierarchy
from employees e
left join hrchy_grp hg
on hg.employeeid = e.employeeid
;
select * from employees_hrchy;
select count(1) from employees_hrchy;

--A, invoice info from 3 views

--view 1: invoice info with customer name
select 
  i.invoiceid
  ,i.customerid
  ,c.firstname || ' ' || c.lastname customername
  ,i.billingcity
  ,i.billingaddress
  ,i.billingstate
  ,i.billingcountry
  ,i.billingpostalcode
  ,i.invoicedate
  ,i.total
from invoices i
left join customers c
using(customerid)
where i.invoiceid = 1;

--view 2: invoice items and track name
select 
  ii.invoicelineid
  ,ii.trackid
  ,t.name trackname
  ,ii.unitprice
  ,ii.quantity
from invoice_items ii
left join tracks t
on t.trackid = ii.trackid
where ii.invoiceid = 1;

--view 3: tracks info of the items
select te.*
from invoice_items ii
left join tracks_ext te
on ii.trackid = te.trackid
where ii.invoiceid = 1 
;


--B, tracks info
select *
from tracks_ext
where 
  albumid = 1
  --artist = 'AC/DC'
;

--C, play list and tracks info
select * 
from playlist_ext
where
  playlistid = 8
;

--D, customer and it's associated employee info
select 
  c.*
  ,e.firstname || ' ' || e.lastname supportrepname
from customers c
left join employees e
on e.employeeid = c.supportrepid
where c.customerid = 2;

--E, employee and 
select 
  e.*
from employees_hrchy e
where e.employeeid = 5;

