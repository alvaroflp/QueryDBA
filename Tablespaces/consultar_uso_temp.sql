 -- ver usuarios conectados usando tablespaces temporarios:
 SELECT     U.TABLESPACE, s.*
 FROM       v$session s, v$tempseg_usage u
 WHERE      s.saddr=u.session_addr
 order by   u.blocks;
  
-- ver espaco alocado (cached) e utilizado nos tablespaces temporarios (tempgroups aparecerao com 0):  
select  tablespace_name,
        file_id,
        extents_cached extents_allocated,
        extents_used,
        bytes_cached/1024/1024 mb_allocated,
        bytes_used/1024/1024 mb_used
FROM    V$TEMP_EXTENT_POOL

-- ver espaco em uso ou maximo ja utilizado por tablespace temp:
select    a.tablespace_name, b.Total_MB,
          b.Total_MB - round(a.used_blocks*8/1024) Current_Free_MB,
          round(used_blocks*8/1024)                Current_Used_MB,
          round(max_used_blocks*8/1024)             Max_used_MB
from      v$sort_segment a,
          (select round(sum(bytes)/1024/1024) Total_MB from dba_temp_files ) b;