SELECT      d.tablespace_name "Name",
            d.status "Status",
            a.bytes/ 1024 / 1024 "TOTAL(M)",
            F.bytes / 1024 / 1024 "LIVRE(M)",
            ((a.bytes - DECODE(f.bytes, NULL, 0, f.bytes)) / 1024 / 1024) "ALOCADO(M)",
            d.block_size
FROM        sys.dba_tablespaces d, 
            sys.sm$ts_avail a, 
            sys.sm$ts_free f
WHERE       d.tablespace_name = a.tablespace_name 
AND         f.tablespace_name (+) = d.tablespace_name
ORDER BY    3 DESC

-- tamanho total do BD
SELECT      d.tablespace_name "Name",            
            SUM(((a.bytes - DECODE(f.bytes, NULL, 0, f.bytes)) / 1024 / 1024)) "TOTAL_UTILIZADO (MB)"            
FROM        sys.dba_tablespaces d,
            sys.sm$ts_avail a, 
            sys.sm$ts_free f
WHERE       d.tablespace_name = a.tablespace_name 
AND         f.tablespace_name (+) = d.tablespace_name
GROUP BY    ROLLUP(d.tablespace_name);
