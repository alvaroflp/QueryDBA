-- pegue o resultado e execute-o no prompt do SO
SELECT        'kill -9 ' || P.SPID
FROM          V$SESSION S
INNER JOIN    V$PROCESS P
    ON        S.PADDR = P.ADDR
where         S.username = UPPER('&USERNAME');