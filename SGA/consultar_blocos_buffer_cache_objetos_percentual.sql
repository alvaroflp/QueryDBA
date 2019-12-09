--select distinct status from v$bh

with t1 as 
(
select    o.owner          owner,
          o.object_name    object_name,
          o.subobject_name subobject_name,
          o.object_type    object_type,
          count(distinct file# || block#)         num_blocks
from      dba_objects  o,
          v$bh         bh
where     o.data_object_id  = bh.objd
and       o.owner not in ('SYS','SYSTEM')
and       bh.status != 'free'
group by  o.owner,  o.object_name,  o.subobject_name, o.object_type
)

select    t1.owner                                          owner,
          object_name                                       object_name,
          case when object_type = 'TABLE PARTITION' then 'TAB PART'
               when object_type = 'INDEX PARTITION' then 'IDX PART'
          else object_type end object_type,
               sum(num_blocks)                                     num_blocks_buffer_cache,
               round((sum(num_blocks)/greatest(sum(blocks), .001))*100,2) perc_blocks_buffer_cache,
          buffer_pool                                       buffer_pool,
          sum(bytes)/sum(blocks)                            block_size
from      t1,
          dba_segments s
where     s.segment_name = t1.object_name
and       s.owner = t1.owner
and       s.segment_type = t1.object_type
and       nvl(s.partition_name,'-') = nvl(t1.subobject_name,'-')
group by  t1.owner, object_name, object_type, buffer_pool
having    sum(num_blocks) > 10
order by  5 desc;


