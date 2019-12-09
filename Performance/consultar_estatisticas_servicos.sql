-- ver estatisticas relacionadas a servicos
select  service_name,
        stat_name,
        value
from    v$service_stats
order by 3 desc, 1, 2