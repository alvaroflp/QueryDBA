-- consultar privs auditados
select  * 
from    DBA_PRIV_AUDIT_OPTS order by 1;

-- remover privs auditados
SELECT  'NOAUDIT ' || PRIVILEGE || ';'
FROM    DBA_PRIV_AUDIT_OPTS
WHERE   USER_NAME IS NULL;