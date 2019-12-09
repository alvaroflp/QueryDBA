-- zerar tabela de auditoria
delete from aud$;

-- comando p/ indexar pesquisas por usuario:
create index IX_AUD$_USERID ON AUD$(USERID);
drop index IX_AUD$_USERID;

-- verificar parametros default relacionados ao gerenciamento da auditoria
SELECT * FROM DBA_AUDIT_MGMT_CONFIG_PARAMS;

-- limpando registros de auditoria obsoletos e ao mesmo configurando periodo de limpeza padrao (maximo de 41,6 dias = 999 horas)
BEGIN
  DBMS_AUDIT_MGMT.init_cleanup(
    audit_trail_type         => DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
    default_cleanup_interval => 999 /* 0-999 horas */);
END;
/

-- movendo AUD$ para tablespace AUDSYS
BEGIN
  DBMS_AUDIT_MGMT.set_audit_trail_location(
    audit_trail_type           => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
    audit_trail_location_value => 'AUDSYS');
END;
/

-- movendo FGA_LOG$ para tablespace AUDSYS
BEGIN
  DBMS_AUDIT_MGMT.set_audit_trail_location(
    audit_trail_type           => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
    audit_trail_location_value => 'AUDSYS');
END;
/

