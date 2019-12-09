select  owner,  segment_name, sum(bytes)/1024/1024 MBYTES 
from    dba_segments
where   owner = UPPER('&SCHEMA')
GROUP BY owner,  segment_name