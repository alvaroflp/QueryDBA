SELECT      owner, name, type, referenced_owner, referenced_name, referenced_type, 
            owner sdev_link_owner, name sdev_link_name, type sdev_link_type
FROM        dba_dependencies
WHERE       UPPER(referenced_owner) = UPPER('&SCHEMA')
AND         UPPER(referenced_name) = UPPER('&OBJETO')
ORDER BY    referenced_owner, referenced_name;
