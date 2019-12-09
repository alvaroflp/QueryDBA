-- CRIANDO PROGRAMAS QUE IRAO COMPOR O CHAIN
BEGIN 
  DBMS_SCHEDULER.create_program (
      program_name   => 'HR.PRG_GATHER_DEP_STATS',
      program_type   => 'PLSQL_BLOCK',
      program_action => 'BEGIN dbms_stats.gather_table_stats(OWNNAME => ''HR'', TABNAME => ''DEPARTMENTS''); END;',
      enabled        => TRUE,
      comments       => 'Programa para coleta de estatisticas da tabela HR.DEPARTMENTS');
END;

BEGIN 
  DBMS_SCHEDULER.create_program (
      program_name   => 'HR.PRG_PASSO3',
      program_type   => 'PLSQL_BLOCK',
      program_action => 'NULL;',
      enabled        => TRUE,
      comments       => 'Programa criado apenas para testar passo 3 do chain');
END;



-- Criando o chain:
BEGIN
  DBMS_SCHEDULER.CREATE_CHAIN (
    chain_name            => 'HR.COLETA_TABS_HR',
    rule_set_name         => NULL,
    evaluation_interval   => NULL,
    comments              => 'Jobs para efetuar coleta de estatisticas de tabelas do schema HR');
END;
 
--- Cria 3 passos no chain
BEGIN
  DBMS_SCHEDULER.DEFINE_CHAIN_STEP('HR.COLETA_TABS_HR', 'step1', 'HR.PRG_GATHER_EMP_STATS');
  DBMS_SCHEDULER.DEFINE_CHAIN_STEP('HR.COLETA_TABS_HR', 'step2', 'HR.PRG_GATHER_DEP_STATS');
  DBMS_SCHEDULER.DEFINE_CHAIN_STEP('HR.COLETA_TABS_HR', 'step3', 'HR.PRG_PASSO3');
END;
 
--- Cria regras para execucao do chain
BEGIN
    DBMS_SCHEDULER.DEFINE_CHAIN_RULE ('HR.COLETA_TABS_HR', 'TRUE', 'START step1');
    DBMS_SCHEDULER.DEFINE_CHAIN_RULE ('HR.COLETA_TABS_HR', 'step1 SUCCEEDED', 'Start step2');
    DBMS_SCHEDULER.DEFINE_CHAIN_RULE ('HR.COLETA_TABS_HR', 'step1 COMPLETED AND step1 NOT SUCCEEDED', 'Start step3');
    DBMS_SCHEDULER.DEFINE_CHAIN_RULE ('HR.COLETA_TABS_HR', 'step2 COMPLETED OR step3 COMPLETED', 'END');
END;

-- habilita chain:
EXEC DBMS_SCHEDULER.ENABLE ('HR.COLETA_TABS_HR');

-- limpa logs de execucao de jobs
EXEC DBMS_SCHEDULER.PURGE_LOG();

-- executa chain
EXEC DBMS_SCHEDULER.RUN_CHAIN(chain_name => 'HR.COLETA_TABS_HR', start_steps  => null);

-- apaga chain:
EXEC DBMS_SCHEDULER.DROP_CHAIN (chain_name   => 'HR.COLETA_TABS_HR', force => TRUE);


-- consultando informacoes detalhadas sobre jobs executados:
SELECT      *
FROM        DBA_SCHEDULER_JOB_RUN_DETAILS
where       owner = 'HR';

-- verificar se estatisticas foram coletadas:
SELECT  OWNER, TABLE_NAME, LAST_ANALYZED 
FROM    ALL_TABLES 
WHERE   TABLE_NAME IN ('EMPLOYEES','DEPARTMENTS');
