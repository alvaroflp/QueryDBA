-- ver se existem procedures ou functions usando determinado dblink
SELECT      o.owner,
            o.object_type,
            o.object_name,
            o.status,
            s.text
FROM        dba_objects o
INNER JOIN  dba_source s
    ON      s.owner = o.owner
    AND     s.type = o.object_type
    AND     s.name = o.object_name
WHERE       UPPER(s.TEXT) LIKE UPPER('%&db_link_name%')
ORDER BY    1,2,3;

-- ver se existem visoes usando determinado db_link
SELECT * FROM DBA_VIEWS WHERE ADMBASECOMUM.FC_CONVERTE_LONG_TO_CHAR('DBA_VIEWS','TEXT','VIEW_NAME',VIEW_NAME) LIKE '%&db_link_name%';