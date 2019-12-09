-- pesquisar somente registros de usuarios que falharam ao se logar (senha errada por exemplo)
select    * 
from      dba_audit_trail 
WHERE     ACTION_NAME = 'LOGON'
AND       RETURNCODE = 1017
order by  timestamp desc;

-- verificar menor data de um registro auditado (bom para conferir se processo de limpeza dos registros de auditoria esta ocorrendo normalmente)
select min(timestamp) from dba_audit_trail;