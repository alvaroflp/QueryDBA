select    buffer_pool,           
          --(sum(blocks)*8192)/1024/1024 as "size (mb)",
          (sum(bytes))/(1024*1024) as "size (mb)"
from      dba_segments
group by  buffer_pool; 

-- candidatas para default pool
select      vss.owner,
            vss.object_name, vss.statistic_name, vss.value,
            ds.bytes segsize, ds.buffer_pool
from        v$segment_statistics vss, dba_segments ds
where       vss.statistic_name ='physical reads'
and         vss.value > 5000000 -- You may need to play with this threshold value for your environment
and         ds.segment_type = vss.object_type
and         ds.segment_name = vss.object_name
and         ds.owner=vss.owner
and         ds.buffer_pool = 'DEFAULT'
order by    value;

-- objetos consumindo mais buffer
SELECT      o.owner, object_name, object_type, COUNT(1) buffers			
FROM        x$bh, dba_objects o			
WHERE       (tch = 1 OR (tch = 0 AND lru_flag < 8))			
AND         obj = o.object_id			
AND         o.owner not in ('SYSTEM','SYS')			
GROUP BY    o.owner, object_name, object_type			
ORDER BY    buffers desc;
