-- retorna lista de queries que executaram mais de 1000 vezes no BD
        select        u.username,
                      sc.username as schemaname,                      
                      a.executions,                       
                      a.cpu_time/(1000000) "cpu_time (s)",
                      a.disk_reads,
                      a.elapsed_time/(1000000) "elapsed_time (s)",
                      (a.sharable_mem + a.persistent_mem + a.runtime_mem) /1024/1024 "used_memory (mb)",
                      a.first_load_time,
                      TO_CHAR(a.last_load_time,'dd/mm/yy HH24:mi:ss') last_load_time,
                      a.buffer_gets,
                      a.sorts,
                      a.loads,
                      a.application_wait_time/(1000000) "application_wait_time (s)",
                      a.concurrency_wait_time/(1000000) "concurrency_wait_time (s)",
                      a.user_io_wait_time/(1000000) "user_io_wait_time (s)",
                      a.plsql_exec_time/(1000000) "plsql_exec_time (s)",
                      a.rows_processed,
                      a.optimizer_mode,
                      a.optimizer_cost,                      
                      --a.sql_text,
                      DBMS_LOB.SUBSTR(a.SQL_FULLTEXT, 4000,1) sql_text
        from          v$sqlarea a
        INNER JOIN    dba_users u
              ON      a.parsing_user_id = u.user_id
        INNER JOIN    dba_users sc
              ON      a.parsing_schema_id = sc.user_id
        where         a.sql_text like '%%'
        
        