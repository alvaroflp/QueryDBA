select        I.OWNER, 
              I.TABLE_NAME,
              C.COLUMN_NAME,
              i.index_name,
              I.index_type
FROM          DBA_INDEXES I
INNER JOIN    dba_ind_columns C
    ON        I.OWNER = C.index_owner
    AND       I.table_name = c.table_name
    AND       I.index_name = C.index_name
WHERE         I.OWNER = UPPER('&schema_name');