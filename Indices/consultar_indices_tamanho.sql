-- consulta TAMANHO dos indices conforme estatisticas do BD (ver data ultima analise na coluna "Last Analyzed")
SELECT    i.owner,
          i.index_name AS "Index Name", 
          nvl(i.num_rows,0) AS "Rows",           
          ROUND((nvl(i.leaf_blocks,0) * p.value)/1024/1024,2) AS "Size MB", 
          i.last_analyzed AS "Last Analyzed"
FROM      dba_indexes i,
          v$parameter p
WHERE     i.owner = UPPER(NVL('&P_OWNER',i.owner))
AND       p.name = 'db_block_size'
UNION ALL
SELECT    i.owner,
          NULL,
          NULL,
          SUM(ROUND((nvl(i.leaf_blocks,0) * p.value)/1024/1024,2)) AS "Size MB", 
          NULL
FROM      dba_indexes i,
          v$parameter p
WHERE     i.owner = UPPER(NVL('&P_OWNER',i.owner))
AND       p.name = 'db_block_size'
GROUP BY  I.OWNER
ORDER by  4 desc;