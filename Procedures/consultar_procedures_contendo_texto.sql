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
WHERE       UPPER(s.TEXT) LIKE UPPER('%&STRING_PESQUISA%')
ORDER BY    1,2,3;

