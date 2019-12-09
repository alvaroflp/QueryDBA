-- Criando fila de eventos 'my_agent':
BEGIN
   DBMS_SCHEDULER.add_event_queue_subscriber ('my_agent');
END;

-- exec DBMS_SCHEDULER.REMOVE_EVENT_QUEUE_SUBSCRIBER ('my_agent');

-- criando job que sera disparado por evento 
BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'HR.MY_JOB_CONSUMER',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'NULL;',
      event_condition   => 'tab.user_data.event_type = ''JOB_SUCCEEDED'' and tab.user_data.object_name = ''MY_JOB''',
      queue_spec        => 'sys.scheduler$_event_queue,my_agent',
      enabled           => TRUE);
END;

BEGIN
   -- criando job que sera executado de hora em hora
   DBMS_SCHEDULER.create_job (
        job_name     => 'HR.MY_JOB',
        job_type     => 'PLSQL_BLOCK',
        job_action   => 'NULL;',
        start_date   => SYSTIMESTAMP,
        REPEAT_INTERVAL => 'FREQ=HOURLY',
        enabled      => FALSE);

    -- configurando job para disparar evento quando for executado com sucesso
    DBMS_SCHEDULER.set_attribute ('HR.MY_JOB', 'raise_events', DBMS_SCHEDULER.job_succeeded);

    -- habilitando o job
    DBMS_SCHEDULER.enable ('HR.MY_JOB');
END;

-- executa job MY_JOB
EXEC DBMS_SCHEDULER.RUN_JOB('HR.MY_JOB');

-- verificar nos logs se o job MY_JOB_CONSUMER tambem foi executado
SELECT      *
FROM        DBA_SCHEDULER_JOB_LOG
where       owner = 'HR'
AND         JOB_NAME IN ('MY_JOB','MY_JOB_CONSUMER');