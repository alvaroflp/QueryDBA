SELECT 'ALTER INDEX "' || i.owner || '"."' || i.index_name || '" MONITORING USAGE;'
FROM   dba_indexes i
WHERE  owner      = UPPER('&SCHEMA_NAME');
