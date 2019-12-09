--1: VERIFICANDO SE O AMBIENTE DG ESTA FUNCIONANDO:
/*  Executar consulta abaixo nos bds primario e standby para verificar replicacao dos redo logs. 
        No BD primario vc deverá ver o processo LNS escrevendo para o ultimo log. 
        No BD standby vc deverá ver 1 ou mais processos RFS e o processo MRPn aplicando o log (APPLYING_LOG) de mesmo numero que o LNS esta escrevendo no primario
*/    
    select process, status, sequence#, block# from v$managed_standby;

-- 2: CONSULTAR LOGS (ver nome, caminho, tipo, versão e mais detalhes:
    select * from v$log;
    select * from v$logfile order by 1;
    select * from v$standby_log;

-- 3: Ver histórico do progresso de recuperação de redos no standby
SELECT * FROM V$RECOVERY_PROGRESS;

-- 4: Ver status do Data Guard, detalhes de estatisticas de atraso de aplicacao de redos no standby (executar no Bd primario) e historico de operacoes executadas:
SELECT 	    timestamp, facility, dest_id, message_num, error_code, message
FROM	    V$DATAGUARD_STATUS
ORDER BY    TIMESTAMP DESC;

-- 5: Identificar archive logs que NAO foram aplicados no stand by (executar no Bd primario)
SELECT      SEQUENCE#,APPLIED FROM V$ARCHIVED_LOG 
WHERE       REGISTRAR = 'LGWR' AND STANDBY_DEST <> 'YES'  
ORDER BY    SEQUENCE# DESC;
 
-- 6: Ver se existem gaps (atrasos ou problemas) na aplicacao dos redo logs (executar no Bd primario)
select * from v$archive_gap;

-- 7: Consultar nome, papel, status, e se broker e flashback database estao ativos:
select 	name, db_unique_name, database_role, switchover_status, dataguard_broker, flashback_on 
from 	v$database;

--  8: Ver info sobre Redo Apply e status de transporte de redo em um stand by fisico: 
SELECT		process, status, group#, thread#, sequence#
FROM		V$managed_standby
ORDER BY	process, group#, thread#, sequence#;

-- 9: Verifique em cada standby o tempo p/ troca de papeis, qtde de redo gerado etc: (executar no Bd primario)
SELECT	name, value, to_char(time_computed,'dd/mm/yyyy hh24:mi:ss')
FROM	v$dataguard_stats;


