-- 1: Remover configuracao do broker:
--  a) Conecte-se no utilitário dgmgrl na máquina do Bd primario:
       $>  dgmgrl sys/XXXXXXX
--  b) Execute o comando abaixo:
       DGMGRL>  REMOVE CONFIGURATION PRESERVE DESTINATIONS;
--  c) No prompt de comandos do SO, verifique se na pasta $ORACLE_HOME/dbs das máquinas dos BDs primario e standby e ainda existe os arquivos de configuracao do Data Guard (arquivos com nome dr1 | dr2 + instance_name + .dat). Se existir, apague-os e CUIDADO PARA NÃO APAGAR OS ARQUIVOS DE CONF DE OUTRO BD.

-- 2: Apagar BD standby físico:
--     a) Conectar no Bd standby via sqlplus na maquina servidora do Bd e executar os seguintes comandos:
    SQL>    ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
    SQL>    SHUTDOWN IMMEDIATE;
    SQL>    STARTUP MOUNT RESTRICT;
    SQL>    DROP DATABASE;

-- 3: Interromper a limpeza dos Archives do bd de produção: 
--     a) Entrar na sp9 e ler o aquivo 'LEIAME' que está localizado na pasta 'scripts': sp9:/orabkp/rman/scripts/LEIAME. Este arquivo descreve o conteudo do arquivo sp9:/orabkp/rman/scripts/bancos, que eh utilizado pela rotina diaria de backups.

--     b) Antes de iniciar a duplicação será necessário desabilitar a limpeza de archives dos bds de produção. Para isso, deve-se entrar na sp9 e editar o arquivo 'bancos', que se encontra na pasta 'scripts' (sp9:/orabkp/rman/scripts/bancos), da seguinte forma:

--        - Alterar para 'n' o terceiro parâmetro da linha referente ao banco que está sendo recriado. Esse parâmetro indica se o banco de dados esta ou não em modo archive log. Exemplo:

--        a linha original para o bd intranet é intranet:sp1:y:n:y:n:/ora00/app/oracle/product/11GR2:oracle:/oraexp e deverá ficar assim:
--        intranet:sp1:n:n:y:n:/ora00/app/oracle/product/11GR2:oracle:/oraexp

--	   c) ATENÇÃO: após o término da duplicação, deve-se voltar o parâmetro para 'y'.
    
-- 4: Seguir roteiros de criação de standby físico (arquivos "./criacao_ambientes/criacao_ambiente_dg_*.sql", onde * deve ser o nome do bd standby a ser reconstruído), a partir do item 3

