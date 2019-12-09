SELECT 'ALTER INDEX "' || i.owner || '"."' || i.index_name || '" NOMONITORING USAGE;'
FROM   dba_indexes i
WHERE  owner      = UPPER('&SCHEMA_NAME')