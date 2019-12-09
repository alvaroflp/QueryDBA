-- No DGMGRL (gerenciador do broker):

-- 1: ver um relatório de status reportando erros
DGMGRL> show database xxx StatusReport;   -- substituir xxx pelo nome da instancia
        	
-- 2: ver status da configuracao:
DGMGRL> show configuration;	
	
-- 3: ver status de um BD:
DGMGRL> show database xxx;

-- 4: ver propriedades inconsistentes (problemas de configuracao) de um BD:
DGMGRL> show database xxx InconsistentProperties;
	
-- 5: ver todas as propriedades de um BD:
DGMGRL> show database verbose xxx;