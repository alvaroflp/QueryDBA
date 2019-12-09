select    s.segment_name ,
          b.object_type,
          b.num_blocks,
          round((b.num_blocks/decode(sum(s.blocks), 0, .001, sum(s.blocks)))*100,2) "% blocks buffer"
from        dba_segments s
INNER JOIN  (select   o.object_name,
                      o.object_type,
                      count(distinct block#) num_blocks
             from     dba_objects  o,
                      v$bh bh
             where    o.object_id  = bh.objd
             and      o.owner not in ('SYS','SYSTEM')
             group by o.object_name, o.object_type) b
    on      s.segment_name  = b.object_name
where     num_blocks > 10
group by  segment_name,
          object_type,
          num_blocks
order by  num_blocks desc;
