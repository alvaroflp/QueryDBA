select 	OWNER,
        TABLESPACE_NAME,
        SEGMENT_NAME,
        SEGMENT_TYPE,
        BYTES,
        EXTENTS,
        MAX_EXTENTS,
        (EXTENTS/MAX_EXTENTS)*100 percentage
from 	dba_segments
where 	SEGMENT_TYPE in ('TABLE','INDEX')
and 	EXTENTS > MAX_EXTENTS/2
order 	by (EXTENTS/MAX_EXTENTS) desc
