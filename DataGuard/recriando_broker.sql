-- 1: Remover configuracao do broker:
--  a) Conecte-se no utilit�rio dgmgrl na m�quina do Bd primario:
       $>  dgmgrl sys/XXXXXXX
--  b) Execute o comando abaixo:
       DGMGRL>  REMOVE CONFIGURATION PRESERVE DESTINATIONS;

-- 2: Recrie a configura��o do broker
    DGMGRL> CREATE CONFIGURATION 'DGConfig1' AS PRIMARY DATABASE IS primario CONNECT IDENTIFIER IS primario;
    DGMGRL> ADD DATABASE standby AS CONNECT IDENTIFIER IS standby;
    
-- 3: Verificar se configuracao esta OK. Configuration Status deve retornar "SUCCESS"
    DGMGRL> SHOW CONFIGURATION VERBOSE;