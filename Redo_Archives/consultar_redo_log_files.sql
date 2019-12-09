select l.group#, 
      l.thread#, 
      l.sequence#, 
      (l.bytes/1024/1024) mbytes, 
      l.members, 
      l.archived, 
      l.status, 
      l.first_change#, 
      to_char(l.first_time,'dd/mm/yyyy hh24:mi:ss') first_time,
      f.member as redo_filename
from  V$LOG l
join  V$LOGFILE f
  on  l.group# = f.group#
order by l.FIRST_TIME;