select      a.average_wait "Avg Waits Full Scan Read I/O",
            b.average_wait "Avg Waits Index Read I/O",
            round((a.total_waits /(a.total_waits + b.total_waits)) * 100,2) "% of I/O Waits scattered" ,
            round((b.total_waits /(a.total_waits + b.total_waits)) * 100,2) "% of I/O Waits sequential",
            round((b.average_wait / a.average_wait)*100,0) "Starting Value oica"
from        v$system_event  a,
            v$system_event  b
where       a.event = 'db file scattered read'
and         b.event = 'db file sequential read';