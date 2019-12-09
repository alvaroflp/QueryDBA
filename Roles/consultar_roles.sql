select      * 
from        dba_role_privs 
where       granted_role = 'DBA'
order by    grantee