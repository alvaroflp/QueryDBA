-- ver tamanho total fisico do BD, considerando datafiles, tempfiles e logs
Select  round(sum(used.bytes) / 1024 / 1024/1024 ) || ' GB' "Database Size",
        round(free.p / 1024 / 1024/1024) || ' GB' "Free space"
from    (select bytes from v$datafile
          union all
         select bytes from v$tempfile
          union all
          select bytes from v$log) used,   
    (select sum(bytes) as p from dba_free_space) free
group by free.p;

-- ver tamanho total logico do BD:
select (sum(bytes)/1024/1024/1024) as size_gb from dba_segments;

-- ver tamanho total logico somente tabelas:
select (sum(bytes)/1024/1024/1024) as size_gb from dba_segments where segment_type in ('TABLE SUBPARTITION','TABLE PARTITION','TABLE');

-- ver tamanho total logico somente indices:
select (sum(bytes)/1024/1024/1024) as size_gb from dba_segments where segment_type in ('INDEX PARTITION','INDEX');
