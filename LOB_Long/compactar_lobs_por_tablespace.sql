SELECT     'ALTER TABLE ' || owner || '.' || table_name || ' MODIFY LOB (' || column_name || ') (SHRINK SPACE);'
FROM      DBA_LOBS
WHERE     TABLESPACE_NAME = '&TABLESPACE_NAME'