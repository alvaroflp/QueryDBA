--coletar estatisticas de objetos sem estatistica em um determinado schema
BEGIN
   DBMS_STATS.GATHER_SCHEMA_STATS ( '&SCHEMA',
   options            => 'GATHER EMPTY',
   estimate_percent   =>  20,
   block_sample  =>  TRUE,
   cascade            =>  TRUE);
END;
