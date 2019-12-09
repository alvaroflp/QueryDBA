SELECT      T1.SPID AS PROCESSO_SO,
            t2.sid SESSION_ID,
            t2.serial# SESSION_SERIAL, 
            t2.program as PROGRAMA,
            t2.username as USUARIO_BD,
            t2.osuser as USUARIO_SO,
            to_char(t2.logon_time, 'DD/MM/YYYY HH24:MI:SS') AS DATA_HORA_LOGIN,
            ROUND(t2.last_call_et / 60, 2) as time_last_call,
            TO_CHAR(SYSDATE - (1 /24/60/60 * last_call_et),'dd/mm/yy hh24:mi:ss') last_call_time,
            t2.seconds_in_wait as WAIT_SECONDS, 
            t2.action,
            t2.machine as MACHINE
FROM        v$process t1
INNER JOIN  v$session t2
    ON      t1.addr = t2.paddr
WHERE       t2.sid = 682    
WHERE       t1.spid= &NUMERO_PROCESSO;