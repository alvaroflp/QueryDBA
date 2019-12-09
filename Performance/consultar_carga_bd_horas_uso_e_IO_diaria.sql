-- ver qtde de horas de uso do BD dia a dia (as visoes abaixo fazer parte do AWR, portanto antes de executar as consultas verifique se vc tem licenciamento da option DIAGNOSTICS PACK)
with tab_snap as (select   trunc(begin_interval_time) cob, min(snap_id) start_snap_id, max(snap_id) end_snap_id
            from    dba_hist_snapshot 
            group by trunc(begin_interval_time)
          )
select      (select distinct name from gv$database) as instancia,
            to_char(s.cob,'yyyy/mm/dd') data,
            to_char(s.cob,'Day') as dia_semana, 
            round((e.end_value-s.start_value)/1000000/3600) db_time_hour,
            round((end_value-start_value)*8192/1024/1024/1024,2) physical_read_write_gb
from        (  select  a.cob, s.instance_number, s.value start_value 
               from    dba_hist_sys_time_model s, tab_snap a 
               where   s.snap_id=a.start_snap_id and s.stat_name='DB time'
            ) s
INNER JOIN  ( select a.cob, e.instance_number, e.value end_value 
              from dba_hist_sys_time_model e, tab_snap a 
              where e.snap_id=a.end_snap_id and e.stat_name='DB time'
            ) e
    ON      s.cob = e.cob        
    and     s.instance_number = e.instance_number
order by    data desc , 2;

(
select a.cob, s.instance_number, sum(s.value) start_value from DBA_HIST_SERVICE_STAT s, a
where s.snap_id=a.start_snap_id and s.stat_name like 'physical%' group by a.cob, s.instance_number) s,

(select a.cob, e.instance_number, sum(e.value) end_value from DBA_HIST_SERVICE_STAT e, a
where e.snap_id=a.end_snap_id and e.stat_name like 'physical%' group by a.cob, e.instance_number) e
where s.cob=e.cob and s.instance_number=e.instance_number order by s.cob desc ,2

