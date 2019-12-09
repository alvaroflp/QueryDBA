select  event, total_waits, total_timeouts, time_waited, average_wait
from    v$system_event
where   event = 'buffer busy waits';