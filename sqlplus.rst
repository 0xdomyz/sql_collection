Use sqlplus to run a query template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

template like this:

.. code-block:: sql

    # template.sql
    -- Define the SQL template
    SELECT *
    FROM my_table
    WHERE id IN (&id_list);

run in cmd:

.. code-block:: bash

    sqlplus -s user/password@db @template.sql id_list=1,2,3


