select	  to_char(start_time,'hh24:mi:ss') timed_at,
          oper_type,
          component,
          parameter,
          oper_mode,
          initial_size/1024/1024 as "initial_size (mb)",
          final_size/1024/1024 as "final_size (mb)"
from	  v$sga_resize_ops
where	  start_time > trunc(sysdate)
order by  start_time, component;          