-- consultar comandos executados no BD
-- &NOME_ESQUEMA: Parâmetro de filtro por esquema. Se nulo ou vazio, pesquisa todos, caso contrário, filtra pelo valor do parametro digitado
-- utilizar s.command_type para filtrar tipo de comando. 2=insert, 3=select, 6=update, 7=delete

SELECT      u.username,
            sc.username schema_name,            
            s.LAST_LOAD_TIME,
            s.module,            
            s.rows_processed,
            s.sql_text                     
FROM        v$sql s
INNER JOIN  dba_users u
    ON      s.parsing_user_id = u.user_id
INNER JOIN  dba_users sc
    ON      s.parsing_schema_id = sc.user_id
    AND     sc.username = NVL(UPPER('&NOME_ESQUEMA'),sc.username)
WHERE       s.command_type IN (2,3,6,7)
AND         u.username <> 'SYS'
AND         s.sql_text not like '%$%' -- utilizar p/ nao retornar pesquisas em visões dinamicas