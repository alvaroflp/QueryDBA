-- consultar top total waits por serviços e eventos

select    service_name,
          event,
          average_wait
from      v$service_event
where     time_waited > 0
order by 3 desc