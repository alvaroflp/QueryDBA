-- ver sessoes gerando mais redo com seu ultimo sql executado:
select      n.name, b.sql_text, s.* 
from        v$sesstat s
join        v$statname n
    on      s.statistic# = n.statistic#
join        v$session ses    
    on      ses.sid = s.sid
left join   v$sqlarea b
    on      ses.sql_hash_value = b.hash_value   
where     name = 'redo size'
and       ses.status = 'ACTIVE'
and       ses.username is not null
order by  value desc;
