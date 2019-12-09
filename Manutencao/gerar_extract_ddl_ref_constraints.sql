-- DIGITAR PARAMETROS EM MAIUSCULO
SELECT    'SELECT DBMS_METADATA.GET_DDL(''REF_CONSTRAINT'',''' || constraint_name ||
          ''',''' || OWNER || ''') FROM DUAL;'
FROM      dba_constraints
WHERE     owner = '&owner'
AND       constraint_type IN ('R')
AND       constraint_name = NVL('&constraint_name',constraint_name)




