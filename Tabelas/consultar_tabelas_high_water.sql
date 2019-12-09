select      a.owner,
            a.table_name,
            b.blocks                        "alocated blocks",
            a.blocks                        "used blocks",
            (b.blocks-a.empty_blocks-1)     "high water"
from        dba_tables a,
            dba_segments b
where       a.table_name=b.segment_name
and         a.owner=b.owner
and         a.owner not in('SYS','SYSTEM')
and         a.blocks <> (b.blocks-a.empty_blocks-1)
and         a.owner like upper('&owner')||'%'
and         a.table_name like upper('&table_name')||'%'
order by    1,2;