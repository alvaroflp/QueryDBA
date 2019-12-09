-- qtde de transacoes por segundo (dos ultimos 60 segundos)
SELECT      'Txns Per Sec', a.epx / b.ept
FROM        (   SELECT  value epx
                FROM    v$sysmetric
                WHERE   group_id = 2 -- 60 sec interval
                AND     metric_name = 'Executions Per Sec' ) a,
            (   SELECT  value ept
                FROM    v$sysmetric
                WHERE   group_id = 2 -- 60 sec interval
AND         metric_name = 'Executions Per Txn' ) b