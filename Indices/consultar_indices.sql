    SELECT      I.OWNER,
                i.table_name,
                I.INDEX_NAME,
                i.index_type,
                IC.COLUMN_NAME,
                I.tablespace_name,
                i.num_rows, 
                TO_CHAR(o.created,'dd/mm/yyyy hh24:mi:ss') created,
                TO_CHAR(i.last_analyzed,'dd/mm/yyyy hh24:mi:ss') last_analyzed,
                i.status
    FROM        DBA_INDEXES I
    INNER JOIN  DBA_IND_COLUMNS IC
        ON      I.owner = IC.index_owner
        AND     I.TABLE_NAME = IC.TABLE_NAME 
        AND     I.index_name = IC.index_name
    INNER JOIN  dba_objects o
        on      i.owner = o.owner
    and         i.index_name = o.object_name
    WHERE       I.OWNER = UPPER(NVL('&NOME_SCHEMA',I.OWNER))
    AND         I.table_name = UPPER(NVL('&NOME_TABELA',I.table_name))
ORDER BY    1, 2, 3