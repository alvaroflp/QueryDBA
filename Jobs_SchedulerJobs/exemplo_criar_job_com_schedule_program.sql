-- EXECUTAR SCRIPTS ABAIXO CONECTADO COM HR

-- criando um program p/ executar coleta de estatisticas na tabela HR.EMPLOYEES
BEGIN 
  DBMS_SCHEDULER.create_program (
      program_name   => 'HR.PRG_GATHER_EMP_STATS',
      program_type   => 'PLSQL_BLOCK',
      program_action => 'BEGIN dbms_stats.gather_table_stats(OWNNAME => ''HR'', TABNAME => ''EMPLOYEES''); END;',
      enabled        => TRUE,
      comments       => 'Programa para coleta de estatisticas da tabela HR.EMPLOYEES');
END;

-- EXEC DBMS_SCHEDULER.DROP_PROGRAM('HR.PRG_GATHER_EMP_STATS');

-- criando um schedule de dias uteis em horario comercial
BEGIN
  DBMS_SCHEDULER.create_schedule (
    schedule_name   => 'HR.SCH_DIAS_UTEIS_HOR_COM',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=HOURLY; BYHOUR=8,9,10,11,12,14,15,16,17,18; BYDAY=MON,TUE,WED,THU,FRI',
    end_date        => NULL,
    comments        => 'Schedule para execucao em dias uteis, horario comercial');
END;

-- EXEC DBMS_SCHEDULER.drop_schedule('HR.SCH_FERIADOS');

-- criando um scheduler job com SCHEDULE e PROGRAM
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name      => 'HR.JOB_GATHER_EMP_STATS',
    program_name  => 'HR.PRG_GATHER_EMP_STATS',
    schedule_name => 'HR.SCH_DIAS_UTEIS_HOR_COM',
    enabled       => TRUE,
    comments      => 'Job para atualizar estatisticas da tabela HR.EMPLOYEES');
END;


-- Scripts scheduler jobs: http://www.fabioprado.net/2011/02/scripts-scheduler-jobs.html

-- criando um novo scheduler job reutilizando um SCHEDULE existente
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name      => 'HR.JOB_GATHER_DEP_STATS',
    job_type      => 'PLSQL_BLOCK',
    job_action    => 'BEGIN dbms_stats.gather_table_stats(OWNNAME => ''HR'', TABNAME => ''DEPARTMENTS''); END;',
    schedule_name => 'HR.SCH_DIAS_UTEIS_HOR_COM',
    enabled       => TRUE,
    comments      => 'Job para atualizar estatisticas da tabela HR.DEPARTMENTS');
END;



-----------------------------------------------------------------------------------------------------------------------------------------------

-- criando um schedule de feriados da empresa
BEGIN
  DBMS_SCHEDULER.create_schedule (
    schedule_name   => 'HR.SCH_FERIADOS',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=YEARLY; BYDATE=0101, 0217, 0403, 0421, 0501, 1115, 1231',
    end_date        => NULL,
    comments        => 'Schedule para execucao em feriados');
END;

-- alterando o SCHEDULE SCH_DIAS_UTEIS_HOR_COM p/ nao executar nos feriados 
BEGIN
    DBMS_SCHEDULER.SET_ATTRIBUTE (
                name           =>   'HR.SCH_DIAS_UTEIS_HOR_COM',                
                attribute      =>   'repeat_interval',
                value          =>   'FREQ=HOURLY; BYHOUR=8,9,10,11,12,14,15,16,17,18; BYDAY=MON,TUE,WED,THU,FRI; EXCLUDE=HR.SCH_FERIADOS');
END;
