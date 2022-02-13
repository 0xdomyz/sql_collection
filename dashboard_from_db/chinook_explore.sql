--explore tables
select * from invoices;

select invoicedate,date(invoicedate,'start of month') 
from invoices;

select invoicedate,count(1) from invoices
group by invoicedate
order by invoicedate;

with x as (
select invoicedate,date(invoicedate,'start of month') mth
from invoices
)select mth,count(1)
from x 
group by mth order by mth;

select * from invoice_items;

select * from tracks;

--example
select * 
from invoices
where invoiceid = 1;

select *
from invoice_items
where invoiceid = 1;

select *
from tracks
where trackid in (1,2);

select *
from albums
where albumid in (1,2);

select *
from artists
where artistid in (1,2) ;

select *
from genres
where genreid in (1);

select *
from media_types
where mediatypeid in (1,2);

select *
from playlist_track
where trackid in (1,2);

select *
from playlists
where playlistid in (1,8,17);

select *
from playlist_track
where playlistid in (1,8,17)
order by playlistid desc;

select *
from customers
where customerid = 2;

select *
from employees
where employeeid = 5;

select *
from employees
where employeeid = 2;

