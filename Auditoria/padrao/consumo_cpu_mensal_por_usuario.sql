-- ver consumo mensal (ultimo mes) de cpu dos usuarios auditados:
select username, mes_ano, session_cpu / 100 as session_cpu_sec, total
from (  select    username, 
                  to_char(logoff_time,'mm/yyyy') mes_ano,
                  sum(session_cpu) session_cpu,
                  count(1) total
        from      dba_audit_trail
        where     to_char(logoff_time,'mm/yyyy') = to_char(sysdate,'mm/yyyy')
        group by  username, to_char(logoff_time,'mm/yyyy')
        having    sum(session_cpu) is not null      
    )
order by  session_cpu_sec desc;