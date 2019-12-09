select 
   function_name, 
   small_read_reqs + large_read_reqs reads,
   small_write_reqs + large_write_reqs writes, 
   wait_time/1000 wait_time_sec,
   case when number_of_waits > 0 then 
          round(wait_time / number_of_waits, 2)
       end avg_wait_ms
from 
   v$iostat_function
order by 
    wait_time desc;