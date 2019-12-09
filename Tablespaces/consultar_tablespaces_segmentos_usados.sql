-- objetos na recycle bin aparecem aqui: para limpar recycle bin digite PURGE RECYCLEBIN;

select  owner,  segment_name, blocks, extents,  bytes/1024 KBYTES 
from    dba_segments  
where   tablespace_name = '&TABLESPACE_NAME';

-- tamanho total de um determinado tablespace
select  SUM(bytes)/1024/1024 MBYTES 
from    dba_segments  
where   tablespace_name = '&TABLESPACE_NAME';

-- tamanho total de todos os tablespaces
select  tablespace_name, SUM(bytes)/1024/1024 MBYTES
from    dba_segments
group by tablespace_name
order by 1;