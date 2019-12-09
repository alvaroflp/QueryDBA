-- Script to Show Objects That are Missing Statistics [ID 957993.1]
SELECT 'TABLE' object_type,owner, table_name object_name, last_analyzed, stattype_locked, stale_stats
FROM all_tab_statistics
WHERE (last_analyzed IS NULL OR stale_stats = 'YES') and stattype_locked IS NULL
and owner NOT IN ('ANONYMOUS', 'CTXSYS', 'DBSNMP', 'EXFSYS','LBACSYS','MDSYS','MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS','ORDSYS','OUTLN','SI_INFORMTN_SCHEMA','SYS', 'SYSMAN','SYSTEM','TSMSYS','WK_TEST','WKSYS','WKPROXY','WMSYS','XDB' ) 
AND owner NOT LIKE 'FLOW%' 
UNION ALL
SELECT 'INDEX' object_type,owner, index_name object_name,  last_analyzed, stattype_locked, stale_stats
FROM all_ind_statistics
WHERE (last_analyzed IS NULL OR stale_stats = 'YES') and stattype_locked IS NULL
AND owner NOT IN ('ANONYMOUS', 'CTXSYS', 'DBSNMP', 'EXFSYS','LBACSYS','MDSYS','MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS','ORDSYS','OUTLN','SI_INFORMTN_SCHEMA','SYS', 'SYSMAN','SYSTEM','TSMSYS','WK_TEST','WKSYS','WKPROXY','WMSYS','XDB' ) 
AND owner NOT LIKE 'FLOW%' 
ORDER BY object_type desc, owner, object_name;
