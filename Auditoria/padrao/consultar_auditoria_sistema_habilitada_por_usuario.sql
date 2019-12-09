-- consultar tudo o que esta sendo auditado
SELECT  *  
FROM    DBA_STMT_AUDIT_OPTS;


-- remover privs auditados para todos os usuarios
SELECT  'NOAUDIT ' || AUDIT_OPTION || ';'
FROM    DBA_STMT_AUDIT_OPTS
WHERE   USER_NAME IS NULL;