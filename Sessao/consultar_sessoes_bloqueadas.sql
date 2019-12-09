with s as (select * from v$session),
     l as (select * from v$lock),
     sq as (select * from v$sqlarea)
          
select      s1.username || '@' || s1.machine 
                || ' ' || s1.program
                || ' ( SID=' || s1.sid || ' )  is blocking '
                || s2.username || '@' || s2.machine || ' ' || s2.program || ' ( SID=' || s2.sid || ' ) '
                || ' SQL 1: ' || sql1.sql_text
                || ' SQL 2: ' || sql2.sql_text AS blocking_status,
                s2.wait_time time_waiting,
                'ALTER system KILL SESSION '''||s1.sid || ',' ||s1.serial# ||''' IMMEDIATE;',
                'ALTER system KILL SESSION '''||s2.sid || ',' ||s2.serial#||''' IMMEDIATE;'
from        l l1
inner join  s s1
    on      s1.sid=l1.sid
inner join  l l2
    on      l1.id1 = l2.id1
    and     l1.id2 = l2.id2                   
inner join  s s2
    on      s2.sid=l2.sid
left join   sq sql1
    on       s1.sql_hash_value = sql1.hash_value  
left join   sq sql2
    on       s2.sql_hash_value = sql2.hash_value  
where       l1.BLOCK=1 and l2.request > 0
order by    s2.wait_time;



