-- esse recurso chama-se FLASHBACK VERSION QUERY e serve para pesquisar versoes anteriores de linha(s) de uma tabela em um determinado tempo:

-- a) consultando em uma data/hora especifica:
SELECT coluna(s) FROM tabela AS OF TIMESTAMP to_date('xx/xx/xxxx xx:xx:ss','dd/mm/yyyy hh24:mi:ss');

-- b) consultando por um SCN específico:
SELECT * FROM tabela AS OF scn xxxxxxx
