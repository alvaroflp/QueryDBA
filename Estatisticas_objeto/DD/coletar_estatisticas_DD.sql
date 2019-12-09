-- coletar estatisticas de objetos fixos do DD:
exec dbms_stats.gather_schema_stats('SYS',gather_fixed=>TRUE);

-- coletar estatisticas de objetos fixos do DD: 
exec dbms_stats.gather_fixed_objects_stats('ALL');