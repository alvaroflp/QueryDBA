-- consulta TAMANHO das tabelas conforme estatísticas do BD (ver data última análise na coluna "Last Analyzed")
-- se desejar ver todas as tabelas do BD informar 'ALL'
WITH TAB AS
  ( SELECT UPPER('&P_OWNER') AS OWNER FROM DUAL) 
SELECT    t.owner,
          t.table_name AS "Table Name", 
          t.num_rows AS "Rows", 
          t.avg_row_len AS "Avg Row Len (bytes)", 
          ROUND((t.blocks * p.value)/1024/1024,2) AS "Size MB", 
          t.last_analyzed AS "Last Analyzed"
FROM      dba_tables t,
          v$parameter p,
          TAB
WHERE     t.owner = NVL(UPPER(TAB.OWNER),t.owner)
AND       p.name = 'db_block_size'
AND       t.num_rows is not null
AND       t.blocks is not null
UNION ALL
SELECT    t.owner,
          NULL, 
          NULL,
          NULL,
          SUM(ROUND((t.blocks * p.value)/1024/1024,2)),
          NULL
FROM      dba_tables t,
          v$parameter p,
          TAB
WHERE     t.owner = NVL(UPPER(TAB.OWNER),t.owner)
AND       p.name = 'db_block_size'
AND       t.num_rows is not null
AND       t.blocks is not null
GROUP BY  (T.OWNER)
ORDER by  5 desc;