--SELECT name, supplemental_log_data_min FROM v$database;
--ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

begin
  DBMS_LOGMNR_D.BUILD('dictionary.ora', '/tmp/scripts', DBMS_LOGMNR_D.STORE_IN_FLAT_FILE);
end;

--EXECUTE DBMS_LOGMNR_D.BUILD(OPTIONS=> DBMS_LOGMNR_D.STORE_IN_REDO_LOGS);

begin
  DBMS_LOGMNR.START_LOGMNR( starttime => to_date('20/10/2015 18:25:22' ,'dd/mm/yyyy hh24:mi:ss'),
              endtime => sysdate,
              --options => DBMS_LOGMNR.DICT_FROM_REDO_LOGS + DBMS_LOGMNR.CONTINUOUS_MINE);
              options => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG + DBMS_LOGMNR.CONTINUOUS_MINE);
end;

/*BEGIN
  DBMS_LOGMNR.add_logfile (
    options     => DBMS_LOGMNR.new,
    logfilename => '/u01/lf1/adm/adm_logfile_g1_m1.rdo');

  --DBMS_LOGMNR.add_logfile (
--    options     => DBMS_LOGMNR.addfile,
    --logfilename => 'C:\Oracle\Oradata\TSH1\Archive\TSH1\T001S00007.ARC');
END;
*/

--select * from v$logmnr_dictionary;

--select * from v$logmnr_logs;

select    timestamp, operation, seg_owner, table_name, sql_redo, SQL_UNDO, seg_type_name, table_space, row_id, username
from      v$logmnr_contents 
where     seg_owner = 'ADMACESSO'
--AND       TABLE_NAME = 'TAB1'
order by  timestamp desc;

EXEC DBMS_LOGMNR.END_LOGMNR;


--http://www.oracle-class.com/?page_id=589
--https://oracle-base.com/articles/11g/flashback-and-logminer-enhancements-11gr1
--http://oracle-info.com/2013/04/08/using-log-miner-effectively/
