-- historico de areas de trabalho usadas pelos cursores desde o startup
SELECT      low_optimal_size/1024 as low_kb,
            (high_optimal_size +1)/1024 as high_kb,
            total_executions,
            round(100*optimal_executions/total_executions) as optimal,  -- cursor interagiu com work area sem usar temp
            round(100*onepass_executions/total_executions) as onepass, -- cursor interagiu com work area usando 1 vez o temp
            round(100*multipasses_executions/total_executions) as multipass -- cursor interagiu com work area usando mais de 1 vez o temp
FROM        v$sql_workarea_histogram
WHERE       total_executions <> 0
ORDER BY    3 DESC;


-- areas de trabalho usadas pelos cursores atuais
select sum(OPTIMAL_EXECUTIONS) OPTIMAL, sum(ONEPASS_EXECUTIONS) ONEPASS , sum(MULTIPASSES_EXECUTIONS) MULTIPASSES
from v$sql_workarea where POLICY='AUTO';  -- aumentar pga se houver valor alto de onepass ou multipasses

-- top 10 sql requerendo mais memoria work area
select c.sql_text, w.operation_type, top_ten.wasize / 1024 / 1024
From (Select *
      From (Select workarea_address, actual_mem_used wasize
            from v$sql_workarea_active
            Order by actual_mem_used)
      Where ROWNUM <=10) top_ten,
      v$sql_workarea w,
      v$sql c
Where    w.workarea_address=top_ten.workarea_address
        And c.address=w.address
        And c.child_number = w.child_number
        And c.hash_value=w.hash_value;  
        
        
select * 
from
	(select workarea_address, operation_type, policy, estimated_optimal_size
  	 from v$sql_workarea
 	order by estimated_optimal_size DESC)
where ROWNUM <=10;
        