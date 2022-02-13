Example deep dive vs data exploration
-------------------------------------

a. Deep dive ensures understanding of underlying real world business
b. Data exploration generates insights difficult to reach without data skills

Data exploration/profiling to understand data
---------------------------------------------

a. Page: https://tapoueh.org/blog/2017/06/exploring-a-data-set-in-sql/

b. Questions to ask for key tables:

    #. Underlying business rules, processes?
    #. How may rows total, per month?
    #. Key columns distribution, variations, What values does it usually take?
    #. Data shape change over time?
    #. Get a feel for data, some unobvious insights?

Snapshot table vs delta table
-----------------------------

#. Page: https://www.nuwavesolutions.com/snapshot-fact-tables/
#. Snapshot table good for analysis

    #. Quarterly, yearly invoice_items snapshot table

#. Delta table good for storage of changing information across time

    #. Common across databases and real world processes, customer, product details commonly change over time and not static. This can be trivial though.
    #. not particularly pronounced for once-off retail sale? Can be if track customer preference across time. 
    #. Certainly important for financial institutions: bank account, loan, insurance contract, super account

Common dashboard items from snapshot table
------------------------------------------

    #. Slice and dice
    #. Time series
    #. volume, exposure
    #. performance

complex relationships
---------------------

#. recommendation based on
#. user’s own history invoice genres/album/track/artists
#. also the top sold tracks associated with those genres/album/tracks/artists

