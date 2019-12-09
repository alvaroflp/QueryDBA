-- criar policy para auditoria FGA
BEGIN
    dbms_fga.add_policy (
      OBJECT_SCHEMA => '&SCHEMA_NAME',
      OBJECT_NAME => '&OBJECT_NAME',
      policy_name => '&POLICY_NAME',
      AUDIT_CONDITION=> NULL,
      audit_column => 'COLUMN_NAME',      
      ENABLE => TRUE,
      STATEMENT_TYPES=> 'select, insert, update, delete' );
END;

-- habilitar policy
begin
    dbms_fga.enable_policy (
    object_schema => '&SCHEMA_NAME',
    OBJECT_NAME => '&OBJECT_NAME',
    POLICY_NAME => '&POLICY_NAME' );
end;

-- apagar policy
BEGIN
  DBMS_FGA.drop_policy(
    object_schema   => '&SCHEMA_NAME',
    object_name     => '&OBJECT_NAME',
    POLICY_NAME     => '&POLICY_NAME');
END;

-- pesquisar AUDITORIA FGA
SELECT db_user, to_char(timestamp, 'dd/mm/yyyy hh24:mi:ss') time, os_user, sql_text, sql_bind FROM dba_fga_audit_trail;

-- LIMPA AUDIT TRAIL FGA
TRUNCATE TABLE fga_log$;