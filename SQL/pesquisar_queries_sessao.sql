-- Retorna dados das sessoes ativas e seus respectivos SQLs
SELECT /*+ ALL_ROWS */
                p.spid, p.pid,
                a.sid,
                --  a.serial#, -- identifica objeto de sessão, útil para distinguir objeto quando uma sessão possui o mesmo sid de uma sessão anterior
                a.program,    
                a.username,  
                a.status,  -- active, inactive, killed (marcada p/ finalizar), cached (temporiaramente em cache p/ uso pelo Oracle XA), sniped (inativa, esperando no cliente)
                a.server, -- dedicated, shared, pseudo, none
                a.schemaname,
                a.osuser,
                a.process,
                a.machine,                    
                to_char(a.logon_time, 'DD-MON-YYYY HH24:MI:SS') as logon_time,
                to_char(sysdate - last_call_et / 86400,'DD-MON-YYYY HH24:MI:SS') as last_activity,
                b.executions,
                b.loads, -- num. de X q o objeto foi lido ou relido
                b.rows_processed,
                b.open_versions, -- num. de cursores abertos
                b.users_opening, -- num. de usuarios com cursores abertos
                b.first_load_time,            
                b.parse_calls,
                b.disk_reads,
                b.buffer_gets,
                --round(((c.CONSISTENT_GETS+c.BLOCK_GETS-c.PHYSICAL_READS) / (c.CONSISTENT_GETS+c.BLOCK_GETS) * 100),2) Ratio,
                b.application_wait_time/(1000000) as application_wait_time,
                b.concurrency_wait_time/(1000000) as concurrency_wait_time,
                b.user_io_wait_time/(1000000) as user_io_wait_time,
                b.optimizer_cost,
                b.OPTIMIZER_MODE,
                b.cpu_time/(1000000) as cpu_time,
                b.elapsed_time/(1000000) as elapsed_time,
                (b.elapsed_time/(1000000))  / b.executions elapsed_time_per_exec,
                (b.sharable_mem + b.persistent_mem + b.runtime_mem) /1024/1024 "used_memory (mb)",
                b.sql_text
FROM            V$SESSION A
LEFT JOIN      V$PROCESS P
    ON          a.PADDR = P.ADDR
left join       v$sqlarea b
    --on          a.sql_address = b.address
    on          a.sql_hash_value = b.hash_value       
LEFT join      v$sess_io c
    ON          A.SID = C.SID
WHERE           A.USERNAME IS NOT NULL
and             a.status = 'ACTIVE';
 -- order by    sid, serial#