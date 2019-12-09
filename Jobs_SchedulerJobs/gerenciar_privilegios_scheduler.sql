-- executar scripts abaixo conectado com SYS

-- concendendo alguns privilegios para a criacao de scheduler jobs e filas de mensagens
GRANT CREATE JOB TO HR;
GRANT CREATE EXTERNAL JOB TO HR;
GRANT EXECUTE ANY PROGRAM TO HR;
GRANT AQ_ADMINISTRATOR_ROLE TO HR;

-- concedendo todos os privilegios para trabalhar com scheduler jobs
GRANT SCHEDULER_ADMIN TO HR;

-- revogando todos os privilegios para trabalhar com scheduler jobs
REVOKE SCHEDULER_ADMIN FROM HR;