-- consultar limites já alcançados de objetos e outros itens do BD (tais como: sessões ativas , total de sessões etc.)
SELECT hwm1.name,
       hwm1.highwater,
       hwm1.last_value
FROM   dba_high_water_mark_statistics hwm1
WHERE  hwm1.version = (SELECT MAX(hwm2.version)
                       FROM   dba_high_water_mark_statistics hwm2
                       WHERE  hwm2.name = hwm1.name)
ORDER BY hwm1.name;