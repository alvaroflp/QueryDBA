-- deve-se entrar com usuario dono do indice
SELECT table_name,
       index_name,
       monitoring
FROM   v$object_usage
WHERE  index_name IN (SELECT  index_name 
                      FROM    dba_indexes
                      WHERE   UPPER(owner) = UPPER('&SCHEMA_NAME'));