-- consulta linhas encadeadas/migradas em todas as tabelas do BD (necessario ter executado antes ANALYZE para identificá-las):
SELECT      owner,
            table_name,
            num_rows,
            avg_row_len,
            chain_cnt,
            round((chain_cnt / num_rows) * 100,2) as perc_mc
FROM        DBA_TABLES
WHERE       owner = UPPER(NVL('&OWNER',owner))
AND         chain_cnt > 0