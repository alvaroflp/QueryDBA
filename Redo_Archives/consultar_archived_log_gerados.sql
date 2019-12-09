select    to_char(completion_time, 'dd/mm/yyyy hh24')||':00' hour,
          round(sum(blocks*block_size)/1048576,2) mb,
          round(sum(blocks*block_size)/1024/(60*60),2) kbps,
          count(*) logs
from      v$archived_log
group by  to_char(completion_time, 'dd/mm/yyyy hh24')||':00'
order by  min(completion_time); 

-- por dia
select    TO_CHAR(completion_time, 'yyyy/mm/dd') "Dia", COUNT(1) "Logs",
          round(sum(blocks*block_size)/1048576,2) "Mb",
          round(sum(blocks*block_size)/1024/(60*60),2) "Kb/s"
from      v$archived_log
group by  TO_CHAR(completion_time, 'yyyy/mm/dd')
order by  1 desc;

-- por hora 
select    to_char(first_time, 'yyyy/mm/dd hh24'), count(1)
from      v$log_history
group by  to_char(first_time, 'yyyy/mm/dd hh24')
order by  1 desc;


