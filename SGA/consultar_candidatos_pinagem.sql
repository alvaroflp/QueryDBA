SELECT      SUBSTR(owner,1,10) Owner,
            SUBSTR(type,1,12) Type,
            SUBSTR(name,1,20) Name,
            executions,
            sharable_mem Mem_used,
            SUBSTR(kept||' ',1,4) "Kept?"
FROM        v$db_object_cache 
WHERE       TYPE IN ('TRIGGER','PROCEDURE','PACKAGE BODY','PACKAGE')
ORDER BY    EXECUTIONS DESC 

SELECT o.owner, o.object_name, object_type, COUNT(1) number_of_blocks
FROM DBA_OBJECTS o, V$BH bh
WHERE o.object_id = bh.objd
AND o.owner != 'SYS' AND o.owner != 'SYSTEM'
GROUP BY o.owner, o.object_name, object_type
ORDER BY count(1) desc;