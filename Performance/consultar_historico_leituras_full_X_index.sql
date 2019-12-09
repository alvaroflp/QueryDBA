-- execute a consulta abaixo somente se vc tiver licença do Diagnostics Pack
select      round(sum(a.time_waited_micro)/sum(a.total_waits)/1000000,5) "Avg Waits Full Scan Read I/O", 
            round(sum(b.time_waited_micro)/sum(b.total_waits)/1000000,5) "Avg Waits Index Read I/O",
            round((
                sum(a.total_waits) / 
                sum(a.total_waits + b.total_waits)
            ) * 100,2) "% of I/O Waits scattered" ,
            round((
                sum(b.total_waits) / 
                sum(a.total_waits + b.total_waits)
            ) * 100,2) "% of I/O Waits sequential",
            round((
                sum(b.time_waited_micro) /
                sum(b.total_waits)) / 
                (sum(a.time_waited_micro)/sum(a.total_waits)
            ) * 100,2) "Starting Value oica"
from        dba_hist_system_event a, 
            dba_hist_system_event b
where       a.snap_id = b.snap_id
and         a.event_name = 'db file scattered read'
and         b.event_name = 'db file sequential read';