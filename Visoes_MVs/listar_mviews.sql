select  owner, 
        mview_name, 
        updatable, 
        master_link, 
        rewrite_enabled, 
        rewrite_capability, 
        refresh_method, 
        last_refresh_type, 
        to_char(last_refresh_date, 'DD/MM/YYYY hh24:mi:ss') last_refresh_date,  
        compile_state  
from    dba_mviews 
where   mview_name = nvl(UPPER('&mview_name'), mview_name)
AND     owner = UPPER('&owner')
ORDER BY 9;