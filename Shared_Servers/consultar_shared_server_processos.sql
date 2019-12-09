select      d.network,
            d.name disp,
            p.username os_user,
            p.terminal terminal,
            s.program program
FROM        v$dispatcher d,
            v$circuit c,
            v$session s,
            v$process p
WHERE       d.paddr = c.dispatcher(+)
AND         c.saddr = s.saddr(+)
AND         s.paddr = p.addr(+)
ORDER BY    d.network, d.name, s.username;
            
            