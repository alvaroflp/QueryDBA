-- DIGITAR PARAMETROS EM MAIUSCULO
SELECT    'SELECT DBMS_METADATA.GET_DDL(''CONSTRAINT'',''' || constraint_name ||
          ''',''' || OWNER || ''') FROM DUAL;'
FROM      dba_constraints
WHERE     owner = '&owner'
--AND       constraint_type IN ('') -- Utilizar se desejar filtra um tipo de constraint ('C','P','U')
AND       constraint_name = NVL('&constraint_name',constraint_name)




