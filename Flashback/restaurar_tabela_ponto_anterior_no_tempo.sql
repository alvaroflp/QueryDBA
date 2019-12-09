-- este recurso chama-se FLASHBACK TABLE e permite voltar uma tabela no tempo:

-- a) recuperando (voltar) a tabela para um SCN especifico:
FLASHBACK TABLE table_name TO SCN XXXXXX;

-- b) recuperando (voltar) a tabela para uma data/hora específica:
FLASHBACK TABLE table_name TO TIMESTAMP to_date('xx/xx/xxxx xx:xx:xx','dd/mm/yyyy hh24:mi:ss');

-- c) se for necessario recuperar varias tabelas no mesmo ponto inclua todas elas no mesmo comando:
FLASHBACK TABLE table_name1, table_name2, table_name3 TO TIMESTAMP to_date('xx/xx/xxxx xx:xx:xx','dd/mm/yyyy hh24:mi:ss');