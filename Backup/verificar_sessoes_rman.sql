-- Verificar sessoes rman
SELECT  s.sid, p.spid, s.client_info
FROM    v$process p, v$session s
WHERE   p.addr = s.paddr
AND     CLIENT_INFO LIKE 'rman%';