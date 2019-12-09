/*
Permite recuperar todos os privilegios que os usuarios possuem sobre os objetos de um schema do banco de dados.
              Possui o parametro SCHEMA para filtrar os objetos do schema desejado.
*/
-- cria tabela temporaria p/ guardar todos os comandos de privilegios
create table STBD.temp_grant (col1 varchar2(4000) );

-- insere na tabela temp todos os privs encontrados dos objetos de um determinado schema
SET SERVEROUTPUT ON
declare
    v_schema VARCHAR2(30) := UPPER('&schema');
BEGIN
    FOR LINHA IN (select * from dba_tables where owner = v_schema)
    LOOP
          INSERT INTO STBD.TEMP_GRANT
          SELECT  'GRANT ' || LOWER(privilege) || ' ON ' || LOWER(owner || '.' || table_name) ||
                  ' TO ' || LOWER(grantee) || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';'
          FROM      DBA_TAB_PRIVS
          WHERE     OWNER = v_schema
          AND       table_name = LINHA.TABLE_NAME
          union all
          --Recupera os privilégios de INSERT, UPDATE, e REFERENCES em COLUNAS
          SELECT  'GRANT ' || LOWER(privilege) || '(' || COLUMN_NAME || ') ON ' || LOWER(OWNER || '.' || table_name) ||
                    ' TO ' || LOWER(grantee) || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';' "SQL"
          from      Dba_Col_Privs
          WHERE     OWNER = v_schema
          AND       table_name = LINHA.TABLE_NAME;
    END LOOP;    
END;
/

-- gera string com os comandos de GRANT de cada privs gravado na tabela temp
SET SERVEROUTPUT ON
BEGIN
    FOR LINHA IN (SELECT * FROM STBD.temp_grant)
    LOOP
        DBMS_OUTPUT.PUT_LINE(LINHA.COL1);
    END LOOP;
END;
/

-- apaga a tabela temp
drop table STBD.temp_grant;

