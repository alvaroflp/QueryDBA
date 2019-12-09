-- 1: Realizar switchover com broker:
--      a) Conectar-se no utilitário dgmgrl com a senha do SYS (se colocar senha errada o processo completo irá falhar e será necessário restartar BD novo standby manualmente), 
--          no BD que é o atual BD standby e futuro primario. 
	$>  dgmgrl sys/XXXXXXX
--      b) Executar switchover para o BD que será o novo primario:
    DGMGRL> SWITCHOVER TO xxx;  -- xxx indica nome do Bd que será o novo bd primário


-- 2: Realizar um failover manual:
--	a) Realizar failover manual (indicar novo bd primario), a partir da máquina que será o novo primário:
		DGMGRL> failover to stby;
			
--  b) Reestabelecer antigo bd primario como BD standby:
        DGMGRL> reinstate database pmry;		
        DGMGRL> enable database pmry;


-- 3: Para desabilitar aplicaçao e envio de logs, execute no DGMGRL:
    edit database stby set state='LOG-TRANSPORT-OFF';
        
-- 4: Para habilitar envio de logs para bd standby, execute os comandos abaixo no primario:	
	edit database stby set state='LOG-TRANSPORT-ON';
	edit database pmry set state='ONLINE';        
        
    
-- 5: Para remover o broker execute os procedimentos abaixo:
--    a) Conecte-se no utilitário dgmgrl na máquina do Bd primario:
            $>  dgmgrl sys/XXXXXXX
--    b) Execute o comando abaixo:
            DGMGRL>  REMOVE CONFIGURATION PRESERVE DESTINATIONS;
--    c) Conecte-se no SQL Plus nos Bds primario e standby e execute o comando abaixo:
            SQL> ALTER SYSTEM SET DG_BROKER_START = FALSE;
--    d) No prompt de comandos do SO, entre na pasta $ORACLE_HOME/dbs das máquinas dos BDs primario e stand by e apague os arquivos de configuracao do Data Guard (arquivos com nome dr1 | dr2 + instance_name + .dat      CUIDADO PARA NÃO APAGAR OS ARQUIVOS DE CONF DE OUTRO BD

            
         
/* Erro ORA-16552: "error occurred while generating directives for client" ou ORA-12514: TNS:listener does not currently know of service requested in connect descriptor
 Indica que o listener não está configurado apropriadamente para o broker. Para resolver o problema configure via broker o parametro staticConnectidentifier 
 em cada BD com o valor da entrada estática correspondente ao BD no listener. O tnsnames dos BDs devem conter entradas de todos os BDs da configuração. 
 */
    -- a) Para ver o valor do parametro staticConnectidentifier, execute o comando abaixo:    
    DGMGRL> show database XXXX staticConnectidentifier
    -- a) Para alterar o valor do parametro staticConnectidentifier, execute o comando abaixo:    
    DGMGRL> edit database XXXX set property staticConnectidentifier=XXXX

        
        
    
