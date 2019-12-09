 SELECT         ROUND((1-(PR.VALUE/
                    (BG.VALUE+CG.VALUE)))*100,2) DB_BUFFER
 FROM           V$SYSSTAT PR, V$SYSSTAT BG, V$SYSSTAT CG
 WHERE          PR.NAME = 'physical reads' 
 AND            BG.NAME = 'db block gets' 
 AND            CG.NAME = 'consistent gets';
