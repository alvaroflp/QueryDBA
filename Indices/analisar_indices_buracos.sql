BEGIN
    EXECUTE IMMEDIATE 'ANALYZE INDEX ' || UPPER('&SCHEMA_NAME') || '.' || UPPER('&INDEX_NAME') || ' VALIDATE STRUCTURE';
END;

-- identificando indices que tenham muitas linhas deletadas (30% ou mais)
SELECT    BLOCKS, 
          PCT_USED,
          DISTINCT_KEYS,
          LF_ROWS,
          DEL_LF_ROWS,
          CASE 
            WHEN ((DEL_LF_ROWS/LF_ROWS)*100) >= 30 THEN 'TRUE'
            ELSE 'FALSE' 
          END AS REORGANIZE
FROM      index_stats;


  
  