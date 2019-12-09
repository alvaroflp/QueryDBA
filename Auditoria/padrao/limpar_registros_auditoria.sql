-- verificar menor data de auditoria:
--      SELECT MIN(TIMESTAMP) FROM DBA_AUDIT_TRAIL;

declare
  curdate date;
  last_archtime date;
BEGIN

  curdate := SYSTIMESTAMP;
  last_archtime := add_months(curdate, -2);  -- limpa registros mais velhos que 2 meses
 
  -- set last archive timestamp for AUD$ 
  SYS.DBMS_AUDIT_MGMT.set_last_archive_timestamp (audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, last_archive_time => last_archtime);
    
  -- set last archive timestamp for FGA$
  -- uncomment the following if you are using fine-grained auditing
  --SYS.DBMS_AUDIT_MGMT.set_last_archive_timestamp (
  -- audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
  -- last_archive_time => last_archtime);
  
  -- set the last archive timestamp for a single instance OS audit trail, or for node 1 in a RAC cluster
  SYS.DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(audit_trail_type  => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS,
   last_archive_time => last_archtime,
   rac_instance_number => 1);

  -- set the last archive timestamp for a single instance XML audit trail, or for node 1 in a RAC cluster
  SYS.DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(audit_trail_type  => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML,
   last_archive_time => last_archtime,
   rac_instance_number => 1);
  
  -- set the last archive timestamp for the second node's OS audit trail
  -- uncomment the following if this procedure is being utilized in a RAC environment
  -- make sure to set the last archive timestamp for additional nodes if necessary (by incrementing the rac_instance_number parameter)
  --SYS.DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(audit_trail_type  => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS,
  -- last_archive_time => last_archtime,
  -- rac_instance_number => 2);

  -- set the last archive timestamp for the second node's XML audit trail
  -- uncomment the following if this procedure is being utilized in a RAC environment
  -- make sure to set the last archive timestamp for additional nodes if necessary (by incrementing the rac_instance_number parameter)
  --SYS.DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(audit_trail_type  => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML,
  -- last_archive_time => last_archtime,
  -- rac_instance_number => 2);

  -- write activity to alert log
  SYS.dbms_system.ksdwrt(2,'AUDIT: Purging Audit Trail until ' || last_archtime || ' beginning');

  -- Purge AUD$ until last time stamp
  SYS.DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL (
   audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
   use_last_arch_timestamp => TRUE);

  -- Purge FGA$ until last time stamp
  -- uncomment the following if you are using fine-grained auditing
  --SYS.DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL (
  -- audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
  -- use_last_arch_timestamp => TRUE);

  -- Purge OS audit trail until last time stamp
  SYS.DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL (
   audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS,
   use_last_arch_timestamp => TRUE);
  
  -- Purge XML audit trail until last time stamp
  SYS.DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL (
   audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML,
   use_last_arch_timestamp => TRUE);
     
  -- write activity to alert log
  SYS.dbms_system.ksdwrt(2,'AUDIT: Purging Audit Trail until ' || last_archtime || ' completed');

END;
