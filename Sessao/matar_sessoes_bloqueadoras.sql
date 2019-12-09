with s as (select * from v$session),
     l as (select * from v$lock),
     P AS (select * from v$process)

SELECT  'ALTER system DISCONNECT SESSION '''||s.sid||', '||s.serial#||''' IMMEDIATE;',
        'kill -9 ' || p.spid
FROM        s
inner join  p 
    on      s.PADDR = p.ADDR
where (s.USERNAME, s.SID) in (select s1.username, s1.sid                  
                from    l l1, s s1, l l2, s s2
                where   s1.sid=l1.sid and s2.sid=l2.sid
                and     l1.BLOCK=1 and l2.request > 0
                and     l1.id1 = l2.id1
                and     l1.id2 = l2.id2);