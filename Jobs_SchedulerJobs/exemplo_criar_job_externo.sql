-- Abrir janela de terminal e entrar como root digitando apenas su. Depois, editar arquivo
--    "externaljob.ora" para ele executar scripts externos com os privilegios do usuario oracle do SO
gedit $ORACLE_HOME/rdbms/admin/externaljob.ora

-- conectado com HR, criar o job externo executando o script abaixo:
BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
            job_name=>'HR.JOB_LIMPA_ARQUIVOS',
            job_type => 'EXECUTABLE',
            job_action => '/home/oracle/Desktop/scripts/Capitulo_09/apagar_logs.sh',
            start_date=> SYSDATE,
            repeat_interval=>'FREQ=HOURLY;INTERVAL=1',
            enabled => true,
            comments => 'Job para limpar arquivos de log do BD e evitar que falte espaco em disco na VM'
            );
END;

-- testar execucao do job:
exec DBMS_SCHEDULER.run_JOB(job_name=>'HR.JOB_LIMPA_ARQUIVOS');

-- consultar log para ver se ele foi executado:
SELECT      *
FROM        DBA_SCHEDULER_JOB_RUN_DETAILS
where       owner = 'HR'
and         job_name = 'JOB_LIMPA_ARQUIVOS';