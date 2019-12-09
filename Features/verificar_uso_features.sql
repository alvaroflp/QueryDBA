-- atualizar uso de feature:
EXEC DBMS_FEATURE_USAGE_INTERNAL.EXEC_DB_USAGE_SAMPLING(SYSDATE);

-- verificar features utilizadas:
SELECT NAME, DETECTED_USAGES, CURRENTLY_USED, FIRST_USAGE_DATE, LAST_USAGE_DATE FROM DBA_FEATURE_USAGE_STATISTICS where DETECTED_USAGES > 0;

-- ver se AWR foi utilizado:
 SELECT name,
  detected_usages,
  currently_used,
  TO_CHAR(last_sample_date,'DD-MON-YYYY:HH24:MI') last_sample
FROM dba_feature_usage_statistics
WHERE name = 'AWR Report' ;
