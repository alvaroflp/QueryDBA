-- altera amostragem de coleta de estatisticas de objetos (11G):
exec DBMS_STATS.SET_PARAM (PNAME => 'ESTIMATE_PERCENT', pval => DBMS_STATS.AUTO_SAMPLE_SIZE);

-- altera quantidade de processos paralelos que serao utilizados na coleta de estatisticas de objetos (11G):
exec DBMS_STATS.SET_PARAM (PNAME => 'DEGREE', pval => 4);