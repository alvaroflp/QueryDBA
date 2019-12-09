-- consultar informacoes detalhadas sobre os datafiles: status, autoincremento, tamanho do autoincremento, espaco alocado etc.
SELECT      F.TABLESPACE_NAME,
            F.FILE_NAME,            
            F.STATUS,            
            F.AUTOEXTENSIBLE AS AUTO_EXT,
            DECODE(F.AUTOEXTENSIBLE, 'NO', 0,
              ROUND((F.INCREMENT_BY * (F.BYTES/F.BLOCKS))/1048576,2)) AS INCREMENT_BY_MB,
            ROUND((F.BYTES/1048576),2) TAM_MB,
            ROUND((F.BYTES-NVL(S.LIVRES,0))/1048576,2) ALOCADO_MB,
            ROUND(F.USER_BYTES/1048576,2) AS USER_BYTES_MB,            
            ROUND(DECODE((F.BYTES-NVL(S.LIVRES,0))/1048576,0,0,                          
                ((((F.BYTES-NVL(S.LIVRES,0))/1048576)/(F.BYTES/1048576))*100)),2) PCT_OCUP,
            ROUND(F.MAXBYTES/1048576,2) MAX_MB
FROM        DBA_DATA_FILES F
LEFT JOIN  (  SELECT    FILE_ID, SUM(BYTES) LIVRES 
              FROM      DBA_FREE_SPACE S 
              GROUP BY  FILE_ID ) S
    ON      F.FILE_ID = S.FILE_ID
ORDER BY    F.TABLESPACE_NAME, F.FILE_NAME