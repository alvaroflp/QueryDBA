-- EXECUTAR SCRIPTS ABAIXO CONECTADO COM HR

-- criando um scheduler job simples (sem SCHEDULE e sem PROGRAM)
BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
            job_name=>'HR.JOB_GATHER_EMP_STATS',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''HR'', ''EMPLOYEES''); END;',
            start_date=> SYSTIMESTAMP,
            repeat_interval=>'FREQ=HOURLY; BYHOUR=8,9,10,11,12,14,15,16,17,18',
            enabled => true,
            comments => 'Coleta de estatisticas da tabela HR.EMPLOYEES, em horario comercial, somente dias uteis');
END;
/

-- alterando um scheduler job
BEGIN
    DBMS_SCHEDULER.SET_ATTRIBUTE (
                name           =>   'HR.JOB_GATHER_EMP_STATS',
                attribute      =>   'repeat_interval',
                value          =>   'FREQ=HOURLY; BYHOUR=8,9,10,11,12,14,15,16,17,18; BYDAY=MON,TUE,WED,THU,FRI');
END;

-- executando um scheduler job
EXEC DBMS_SCHEDULER.RUN_JOB('HR.JOB_GATHER_EMP_STATS');

-- desabilitando um job
execute DBMS_SCHEDULER.disable('HR.JOB_GATHER_EMP_STATS');

-- habilitando um job
execute DBMS_SCHEDULER.enable('HR.JOB_GATHER_EMP_STATS');

-- apagando um scheduler job
EXEC DBMS_SCHEDULER.DROP_JOB('HR.JOB_GATHER_EMP_STATS');