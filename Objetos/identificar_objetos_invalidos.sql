SELECT      owner,
            object_type,
            object_name,
            status
FROM        dba_objects
WHERE       owner not like '%SYS%'
and status = 'INVALID'
ORDER BY    owner, object_type, object_name;
