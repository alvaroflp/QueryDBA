select      a.event,
            a.total_waits,
            a.time_waited,
            round(a.time_waited/a.total_waits,5) average_wait,
            round(sysdate - b.startup_time,2) days_old
from        v$system_event a,
            v$instance b
order by    4 desc