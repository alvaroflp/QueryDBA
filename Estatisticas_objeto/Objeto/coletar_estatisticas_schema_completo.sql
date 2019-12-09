--coletar estatisticas de todas as tabelas, clusters e indices de um schema
BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS (
    ownname          => UPPER('&SCHEMA_NAME'),
    cascade          => TRUE,
    options          => 'GATHER AUTO');
END;

/* bloco antigo utilizado qdo oracle tinha otimizador baseado em rules
BEGIN
  DBMS_UTILITY.ANALYZE_SCHEMA(UPPER('&SCHEMA'),'COMPUTE');
END;
*/
