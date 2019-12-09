/* O número de Reloads deverá ser menor que 1% dos pins. Se for maior que 1%, podem estar ocorrendo 2 situações:
        1- A SQL Area tem pouco espaço e os objetos estão expirando. Neste caso aumente o valor do parametro SHARED_POOL_SIZE
        2- Objetos estão sendo invalidados. Neste caso faça tarefas de manutenção do BD, tais como criação de indices, somente em periodos de menor uso do BD.
*/

            SELECT  SUM(pins) "Executions",
                    SUM(reloads) "Cache Misses",
                    SUM(reloads)/SUM(pins) "%"
            FROM    V$LIBRARYCACHE;