-- Execute a consulta abaixo somente se vc tem licença do Diagnostics Pack:
select      a.EVENT_NAME,
            a.total_waits,
            a.TIME_WAITED_MICRO / 10000000 time_waited_sec,
            h.begin_interval_time, h.end_interval_time
            --round(a.TIME_WAITED_MICRO/a.total_waits,5) average_wait,
            --round(sysdate - h.begin_interval_time,2) days_old
from        DBA_HIST_SYSTEM_EVENT a
inner join  dba_hist_snapshot h
    on      h.snap_id = a.snap_id            
where       h.end_interval_time between to_date('21/03/2014 00:00:00', 'dd/mm/yyyy hh24:mi:ss') and to_date('21/03/2014 23:59:00', 'dd/mm/yyyy hh24:mi:ss')
order by    h.begin_interval_time desc, time_waited_sec desc;
