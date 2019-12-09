-- utilizacao de recursos (memoria, cpu, disco etc) por schema
        select        u.username,
                      SUM(a.executions) executions,                       
                      SUM(a.cpu_time)/(1000000) "cpu_time (s)",
                      SUM(A.DISK_READS) "disk_reads",
                      sum(a.DIRECT_WRITES) "direct_writes",
                      sum(a.buffer_gets) "buffer_gets",
                      SUM(a.elapsed_time)/(1000000) "elapsed_time (s)",
                      SUM((a.sharable_mem + a.persistent_mem + a.runtime_mem))/1024/1024 "used_memory (mb)"
        from          v$sqlarea a
        INNER JOIN    dba_users u
              ON      a.parsing_user_id = u.user_id
        INNER JOIN    dba_users sc
              ON      a.parsing_schema_id = sc.user_id
        where         a.command_type = 3
        and           u.username <> 'SYS'
        GROUP BY      U.USERNAME
        ORDER BY      u.username;