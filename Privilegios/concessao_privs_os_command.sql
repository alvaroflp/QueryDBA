-- 1: atribuindo privs de execucao no JVM embutido do Oracle
set verify off
declare
  v_username VARCHAR2(30) := upper('&USERNAME');
begin
    -- this grants read privilege on STDIN
    dbms_java.grant_permission(
    grantee =>           v_username,
    permission_type =>   'SYS:java.lang.RuntimePermission',
    permission_name =>   'readFileDescriptor',
    permission_action => null
    );
    COMMIT;
    -- this grants write permission on STDOUT
    dbms_java.grant_permission(
    grantee =>           v_username,
    permission_type =>   'SYS:java.lang.RuntimePermission',
    permission_name =>   'writeFileDescriptor',
    permission_action => null
    );
    COMMIT;
    -- this grants execute privilege for the 'ls -la' command
    dbms_java.grant_permission(
    grantee =>           v_username,
    permission_type =>   'SYS:java.io.FilePermission',
    permission_name =>   '/bin/ls',
    permission_action => 'execute'
    );
    COMMIT;
    -- this grants execute privilege for ALL shell commands: VERY DANGEROUS!
    dbms_java.grant_permission(
    grantee =>           v_username,
    permission_type =>   'SYS:java.io.FilePermission',
    permission_name =>   '<<ALL FILES>>',
    permission_action => 'execute'
    );
    COMMIT;

    -- atribuindo privs p/ o usuario executar o package OS_COMMAND e chamadas externas do oracle
    EXECUTE IMMEDIATE 'grant execute on OS_COMMAND to ' || v_username;
    EXECUTE IMMEDIATE 'grant execute on "ExternalCall" to ' || v_username;    
end;
/

-- Depdendo do que for executado com o pacote OS_COMMAND, verificar se é necessário conceder também os privs. abaixo:
/*
grant execute on java source "OS_HELPER" to rman;
Grant execute on java source "FILE_TYPE_JAVA" to rman;
grant execute on "FileType" to rman;
grant execute on lob_writer_plsql to rman;
grant execute on FILE_PKG to rman;
grant execute on FILE_TYPE to rman;
grant execute on FILE_LIST_TYPE to rman;
*/

