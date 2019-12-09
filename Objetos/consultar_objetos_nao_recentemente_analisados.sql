select      OWNER,
            TABLE_NAME,
            to_char(LAST_ANALYZED,'DD/MM/YYYY HH24:MI:SS') last_analyzed
from        dba_tab_columns
where       OWNER not in ('SYS','SYSTEM')
and         LAST_ANALYZED is not null
and	        COLUMN_ID = 1
and         (SYSDATE-LAST_ANALYZED) > 7
order by    3 DESC 