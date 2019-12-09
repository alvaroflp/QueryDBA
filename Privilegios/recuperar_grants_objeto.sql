UNDEFINE SCHEMA_NAME;
UNDEFINE TABLE_NAME;
/*
Permite recuperar todos os privilegios que os usuarios possuem sobre ou mais objetos de banco de dados.
              Possui os parametros SCHEMA_NAME e TABLE_NAME, que permitem filtrar por nome do schema e/ou nome do objeto. Se nao desejar utilizar algum dos parametros de filtro, nao forneca valor para eles quando for solicitado, ao executar o script.
*/
SELECT    'GRANT ' || LOWER(privilege) || ' ON ' || LOWER(owner || '.' || table_name) ||
          ' TO ' || LOWER(grantee) || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';' "SQL"
FROM      DBA_TAB_PRIVS
WHERE     OWNER = NVL(UPPER('&&SCHEMA_NAME'), OWNER)
AND       table_name = NVL(UPPER('&&TABLE_NAME'),TABLE_NAME)
union all
--Recupera os privilegios de INSERT, UPDATE, e REFERENCES em COLUNAS
SELECT    'GRANT ' || LOWER(privilege) || '(' || COLUMN_NAME || ') ON ' || LOWER(OWNER || '.' || table_name) ||
          ' TO ' || LOWER(grantee) || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';' "SQL"
from      Dba_Col_Privs
WHERE     OWNER = NVL(UPPER('&&SCHEMA_NAME'), OWNER)
AND       table_name = NVL(UPPER('&&TABLE_NAME'),TABLE_NAME)
ORDER BY 1;