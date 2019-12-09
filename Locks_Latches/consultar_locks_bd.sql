-- consultar objetos bloqueados por usuario
SELECT    LO.SESSION_ID, LO.PROCESS, LO.ORACLE_USERNAME, O.OWNER, O.OBJECT_NAME
FROM      V$LOCKED_OBJECT LO
JOIN      DBA_OBJECTS O
  ON      O.OBJECT_ID = LO.OBJECT_ID;

-- consultar locks que estao bloqueando outras sessoes
SELECT  L.SESSION_ID, L.LOCK_TYPE, L.MODE_HELD, L.LOCK_ID1, L.LOCK_ID2, L.BLOCKING_OTHERS
FROM    DBA_LOCKS L
WHERE   L.BLOCKING_OTHERS <> 'Not Blocking';

-- consultar sessoes bloqueadoras
select * from dba_blockers;

-- consultar sessoes bloqueadas
select * from dba_waiters;


select      /*+ ALL_ROWS */
            b.sid, 
            c.username, 
            c.osuser, 
            c.terminal, 
            c.status, 
            a.owner, 
            decode (NVL (b.id2, 0), 0, a.object_name, 'Trans-'||to_char(b.id1)) object_name, 
            b.type,
            decode (NVL (b.lmode, 0), 0, '--Waiting--',
                              1, 'Null',
                              2, 'Row Share',
                              3, 'Row Excl',
                              4, 'Share',
                              5, 'Sha Row Exc',
                              6, 'Exclusive',
                              'Other') "Lock Mode",
            decode(NVL (b.request, 0), 0, ' - ',
                              1, 'Null',
                              2, 'Row Share',
                              3, 'Row Excl',
                              4, 'Share',
                              5, 'Sha Row Exc',
                              6, 'Exclusive',
                              'Other') "Req Mode"
from          dba_objects a
right join    v$lock b
    on        a.object_id = b.id1
inner join    v$session c
    on        b.sid = c.sid
where         c.username is not null;
-- order by b.sid, b.id2 