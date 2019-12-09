/*
 Permite recuperar todos os privilegios de objeto, sistema e roles de um usuario e, se desejado, atribuir os privilegios para outro usuario. 
 Util para clonar privilegios de usuarios. 
 Possui os parametros USUARIO_ORIGEM e USUARIO_DESTINO. Para somente recuperar os privilegios de um determinado usuario, forneca o mesmo nome de usuario para os 2 parametros.
*/
undefine USUARIO_ORIGEM;
undefine USUARIO_DESTINO;

SELECT  'GRANT ' || LOWER(privilege) || ' ON ' || LOWER(OWNER || '.' || table_name) ||
        ' TO ' || LOWER('&&USUARIO_DESTINO') || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';' "SQL"
FROM    dba_TAB_privs
WHERE   grantee = UPPER('&&USUARIO_ORIGEM')
union all
SELECT  'GRANT ' || LOWER(privilege) || ' TO ' || LOWER('&&USUARIO_DESTINO') 
        || DECODE(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION') || ';' "SQL"
FROM    dba_SYS_privs
WHERE   grantee = UPPER('&&USUARIO_ORIGEM')
union all
SELECT  'GRANT ' || LOWER(GRANTED_ROLE) || ' TO ' || LOWER('&&USUARIO_DESTINO') 
        || DECODE(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION') || ';' "SQL"
FROM    dba_ROLE_privs
WHERE   grantee = UPPER('&&USUARIO_ORIGEM')
union all
--Recupera os privilegios de INSERT, UPDATE, e REFERENCES em COLUNAS
SELECT  'GRANT ' || LOWER(privilege) || '(' || COLUMN_NAME || ') ON ' || LOWER(OWNER || '.' || table_name) ||
        ' TO ' || LOWER('&&USUARIO_DESTINO') || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';' "SQL"
FROM    Dba_Col_Privs
WHERE   grantee = UPPER('&&USUARIO_ORIGEM')
ORDER BY 1;