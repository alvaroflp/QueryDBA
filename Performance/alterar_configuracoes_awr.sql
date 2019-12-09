begin
/* This SQL shows that the snapshots are taken every hour and the collections are retained 7 
   seven days. To change the settings--say, for snapshot intervals of 20 minutes and a retention 
   period of two days--you would issue the following. The parameters are specified in minutes. */
  
   dbms_workload_repository.modify_snapshot_settings (
      interval => 60,
      retention => 30*24*60
   );
   
   -- select snap_interval, retention from dba_hist_wr_control;
   
   --* visoes com dados de performance coletados pelo statspack
   -- select view_name from user_views where view_name like 'DBA\_HIST\_%' escape '\';
   
   --* criar baseline
   -- exec dbms_workload_repository.create_baseline (56,59,'apply_interest_1')
   
   --* apagar baseline
   -- exec dbms_workload_repository.drop_baseline (56,59,'apply_interest_1')
   
   
   --select count(1), server from v$session where username is not null group by server
   
/*   
V$ACTIVE_SESSION_HISTORY - Displays the active session history (ASH) sampled every second. 
V$METRIC - Displays metric information. 
V$METRICNAME - Displays the metrics associated with each metric group. 
V$METRIC_HISTORY - Displays historical metrics. 
V$METRICGROUP - Displays all metrics groups. 
DBA_HIST_ACTIVE_SESS_HISTORY - Displays the history contents of the active session history. 
DBA_HIST_BASELINE - Displays baseline information. 
DBA_HIST_DATABASE_INSTANCE - Displays database environment information. 
DBA_HIST_SNAPSHOT - Displays snapshot information. 
DBA_HIST_SQL_PLAN - Displays SQL execution plans. 
DBA_HIST_WR_CONTROL - Displays AWR settings. 
*/

   


end;