-- consultar todos os registros de auditoria de um determinado usuario ou nenhum usuario 
SELECT  os_username, USERNAME, userhost, terminal, timestamp, OWNER, obj_name, action_name, returncode
FROM    DBA_AUDIT_TRAIL
where   username = UPPER(NVL('&username',USERNAME));

-- consultar todos os registros de auditoria de um determinado usuario, que geraram erros (por exemplo por falta de privilegio ou objeto inexistente)
SELECT    * 
FROM      DBA_AUDIT_TRAIL
where     username = '&username'
and       returncode <> 0
ORDER BY  TO_CHAR(timestamp, 'yyyy/mm/dd hh24:mi:ss') DESC;


