Select    username,v.sid||','||v.serial# sid_session,round((s.value/y.value)*100,2) cpu_used_percentage
from      v$session v, v$sesstat s,v$sysstat y
where     v.username is not null
and       v.sid = s.sid
and       s.statistic#=y.statistic#
and       y. name = 'CPU used by this session'
Order by  3 desc;