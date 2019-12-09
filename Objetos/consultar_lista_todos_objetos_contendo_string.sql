-- PURGE DBA_RECYCLEBIN;

-- lista de objetos e colunas contendo string MAIL, CORREIO e STMP
SELECT    DISTINCT I.INSTANCE_NAME AS SID, OWNER AS NOME_ESQUEMA, OBJECT_TYPE AS TIPO_OBJETO, 
          DECODE(COLUMN_NAME,NULL,OBJECT_NAME,OBJECT_NAME || '.' || COLUMN_NAME) AS NOME_OBJETO,
          DESCRICAO
FROM      (
          -- lista de objetos 
          SELECT    OWNER, OBJECT_NAME, OBJECT_TYPE, NULL AS COLUMN_NAME, 'Objeto c/ nome contendo string = MAIL, CORREIO ou SMTP' as DESCRICAO, NULL AS TEXT
          FROM      DBA_OBJECTS 
          UNION     ALL
          -- lista de colunas
          SELECT    OWNER, TABLE_NAME, 'COLUMN' AS OBJECT_TYPE, COLUMN_NAME,  'Objeto c/ nome contendo string = MAIL, CORREIO ou SMTP' as DESCRICAO, NULL AS TEXT
          FROM      DBA_TAB_COLS 
          UNION     ALL
          -- lista de objets PL/SQL
          SELECT    o.owner,
                    o.object_name,
                    o.object_type,
                    NULL AS COLUM_NAME,
                    'Procedures, Functions e Packages contendo string = MAIL, CORREIO, SMTP ou tre-sp.gov.br' as DESCRICAO,
                    S.TEXT
          FROM      dba_objects o
          JOIN      dba_source s
          ON        s.owner = o.owner
          AND       s.type = o.object_type
          AND       s.name = o.object_name
          ) l,
          V$INSTANCE I          
WHERE       (
            UPPER(l.TEXT) LIKE '%MAIL%'
            OR UPPER(l.TEXT) LIKE '%CORREIO%'
            OR UPPER(l.TEXT) LIKE '%SMTP%'            
            OR UPPER(NVL(COLUMN_NAME,OBJECT_NAME)) LIKE '%MAIL%'
            OR UPPER(NVL(COLUMN_NAME,OBJECT_NAME)) LIKE '%MAIL%'
            OR UPPER(NVL(COLUMN_NAME,OBJECT_NAME)) LIKE '%MAIL%'
            )
AND         l.OWNER NOT IN ('SYS', 'PUBLIC', 'APEX_040100', 'STBD', 'WMSYS', 'CTXSYS')
ORDER BY    2,3,4;



