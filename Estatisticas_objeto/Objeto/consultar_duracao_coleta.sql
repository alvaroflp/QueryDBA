-- verificar duracao da coleta de estatisticas
	select  operation,target,start_time,end_time 
	from    dba_optstat_operations
	where   operation='gather_database_stats(auto)' order by 3 desc;