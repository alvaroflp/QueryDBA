select  'drop table ' || owner_name || '.' || job_name || ' purge;' 
from    dba_datapump_jobs 
where   state = 'NOT RUNNING';