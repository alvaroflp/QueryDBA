SELECT      job_name, enabled, STATE, STOP_ON_WINDOW_CLOSE
FROM        DBA_SCHEDULER_JOBS 
WHERE       JOB_NAME = 'GATHER_STATS_JOB';

-- habilitar agendamento de coleta de estatisticas
/*
begin
    dbms_scheduler.enable('GATHER_STATS_JOB');
END;
*/