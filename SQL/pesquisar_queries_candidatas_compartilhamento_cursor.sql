-- Identificar cursores que devem ser compartilhados, com mais de 100 vezes executados            
            
            SELECT      DISTINCT sql_text,
                        executions
            FROM        V$SQLAREA
            WHERE       plan_hash_value IN (SELECT    plan_hash_value
                                            FROM      V$SQL
                                            GROUP BY  plan_hash_value
                                            HAVING    count(1) > 100)
        