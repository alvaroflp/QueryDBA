-- 1: Remover configuracao do broker:
--  a) Conecte-se no utilit�rio dgmgrl na m�quina do Bd primario:
       $>  dgmgrl sys/XXXXXXX
--  b) Execute o comando abaixo:
       DGMGRL>  REMOVE CONFIGURATION PRESERVE DESTINATIONS;
--  c) No prompt de comandos do SO, verifique se na pasta $ORACLE_HOME/dbs das m�quinas dos BDs primario e standby e ainda existe os arquivos de configuracao do Data Guard (arquivos com nome dr1 | dr2 + instance_name + .dat). Se existir, apague-os e CUIDADO PARA N�O APAGAR OS ARQUIVOS DE CONF DE OUTRO BD.

-- 2: Apagar BD standby f�sico:
--     a) Conectar no Bd standby via sqlplus na maquina servidora do Bd e executar os seguintes comandos:
    SQL>    ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
    SQL>    SHUTDOWN IMMEDIATE;
    SQL>    STARTUP MOUNT RESTRICT;
    SQL>    DROP DATABASE;

-- 3: Interromper a limpeza dos Archives do bd de produ��o: 
--     a) Entrar na sp9 e ler o aquivo 'LEIAME' que est� localizado na pasta 'scripts': sp9:/orabkp/rman/scripts/LEIAME. Este arquivo descreve o conteudo do arquivo sp9:/orabkp/rman/scripts/bancos, que eh utilizado pela rotina diaria de backups.

--     b) Antes de iniciar a duplica��o ser� necess�rio desabilitar a limpeza de archives dos bds de produ��o. Para isso, deve-se entrar na sp9 e editar o arquivo 'bancos', que se encontra na pasta 'scripts' (sp9:/orabkp/rman/scripts/bancos), da seguinte forma:

--        - Alterar para 'n' o terceiro par�metro da linha referente ao banco que est� sendo recriado. Esse par�metro indica se o banco de dados esta ou n�o em modo archive log. Exemplo:

--        a linha original para o bd intranet � intranet:sp1:y:n:y:n:/ora00/app/oracle/product/11GR2:oracle:/oraexp e dever� ficar assim:
--        intranet:sp1:n:n:y:n:/ora00/app/oracle/product/11GR2:oracle:/oraexp

--	   c) ATEN��O: ap�s o t�rmino da duplica��o, deve-se voltar o par�metro para 'y'.
    
-- 4: Seguir roteiros de cria��o de standby f�sico (arquivos "./criacao_ambientes/criacao_ambiente_dg_*.sql", onde * deve ser o nome do bd standby a ser reconstru�do), a partir do item 3

