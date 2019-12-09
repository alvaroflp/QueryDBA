Passo 1- Cria��o do BD auxiliar:
     
     Criar BD auxiliar em uma m�quina de testes, separada do BD target, via DBCA, utilizando como template o BD target. Durante o processo de instala��o � necess�rio configurar os seguintes par�metros de inicializa��o:

    - DB_FILES: Configure para o mesmo valor do Bd target.
          Ex.: DB_FILES = 1000

    - DB_FILE_NAME_CONVERT: Configure para conter o valor do diret�rio de datafiles do BD target e um valor correspondente ao mesmo diret�rio p/ o BD auxiliar. Todos os diret�rios de datafiles do bd target devem estar contidos neste par�metro. Antes de configurar este par�metro crie no bd auxiliar os diret�rios correspondentes.
           Ex.:    DB_FILE_NAME_CONVERT = '/oradata/prod','/oradata/aux','/oraind/prod/','/oraind/aux'
        
    - LOG_FILE_NAME_CONVERT:  Configure p/ conter o valor do diret�rio de logfiles do bd target e um valor correspondente ao mesmo diret�rio p/ o BD auxiliar. Todos os diret�rios de logfiles do bd target devem estar contidos neste par�metro. Antes de configurar este par�metro, crie no BD auxiliar os diret�rios correspondentes.
           Ex.: LOG_FILE_NAME_CONVERT='/oralog/prod/log1','/oralog/aux/log1'
            
    - SGA_TARGET, SGA_MAX_SIZE e PGA_AGGREGATE_TARGET: Configure para conter um valor que possa ser configurado na m�quina de testes, de acordo com a qtde. de RAM dispon�vel.


Passo 2- Recupera��o dos dados desejados utilizando o BD auxiliar: 
      
     a) Copie p/ a m�quina do BD auxiliar a pasta contendo todas as pe�as de backup e archive logs (se existir) do BD target;

     b) Na m�quina do BD auxiliar acrescente no arquivo tnsnames.ora um �lias p/ a inst�ncia do BD target. Nome sugerido: PROD.
     
     c) Na m�quina do BD auxiliar, inicie o BD auxiliar em modo NOMOUNT:
        
     d) Na m�quina do BD auxiliar, conecte-se no RMAN referenciando o BD target e o bd auxiliar:
            Ex.:   export ORACLE_SID=bd_auxiliar
                     rman target sys/XXX@bd_target auxiliary sys/YYY

    e) No prompt de comandos do RMAN, execute o restore e recover de um controlfile do BD target no BD auxiliar e mounte o BD auxiliar (que tamb�m ser� chamado de BD clone):
       Ex.:
             run{
                   set until time "to_date('2011-10-19-12:30:00','yyyy-mm-dd-hh24:mi:ss')";
                   restore clone controlfile;
                   sql clone 'alter database mount clone database';
                   sql 'alter system archive log current';
                   sql 'begin dbms_backup_restore.AutoBackupFlag(FALSE); end;';
             }
        
     f) Execute o restore e recover dos principais datafiles (system, system e undo) do BD target e do(s) datafile(s) correspondente(s) ao tablespace que ser� recuperado. Para este passo ser� necess�rio consultar no BD target o n�mero do(s) datafile(s) desejado(s), atrav�s da consulta  abaixo:
              select file_id from DBA_DATA_FILES where TABLESPACE_NAME = 'TSEXEMPLO';

      Depois execute no prompt do RMAN, o script:

        RUN{
            set until time "to_date('2011-10-19-12:30:00','yyyy-mm-dd-hh24:mi:ss')";
            set newname for datafile 1 to "/oradata/aux/system01.dbf";
            set newname for datafile 2 to "/oradata/aux/undotbs01.dbf";
            set newname for datafile 3 to "/oradata/aux/aux01.dbf";
            set newname for datafile 211 to "/oradata/aux/exemplo.dbf";
            switch clone tempfile all;
            restore clone datafile 1, 2, 3, 211;
            switch clone datafile all;
            sql clone "alter database datafile 1 online";
            sql clone "alter database datafile 2 online";
            sql clone "alter database datafile 3 online";    
            sql clone "alter database datafile 211 online";


          recover clone database tablespace "TSEXEMPLO", "SYSAUX", "SYSTEM", "UNDOTBS1" delete archivelog; 
           alter clone database open resetlogs; 
           sql clone "create tablespace temp datafile '/oradata/aux/temp01.dbf' size 500K";
         }
      
   
Passo 3- Exporta��o dos dados desejados, do BD auxiliar para o BD de produ��o:
     
     a) Na m�quina do BD auxiliar, execute um export convencional (Datapump n�o ir� funcionar) do(s) schema(s) referente(s) ao tablespace recuperado:
           Ex.: exp userid sys/XXX as sysdba file=file.dmp log=file.log owner=YYY
             Obs.: Substitua XXX pela senha do usu�rio SYS no Bd auxiliar e YYY pelo nome do usu�rio que vc precisa recuperar os dados
       
     b) Na m�quina do BD target, apague o(s) objeto(s) que vc ir� recuperar:
           Ex.: DROP TABLE SCHEMA.TABLE_NAME;
   
     c) Na m�quina do BD target copie o dump gerado no item a) deste passo e fa�a um import convencional dos dados desejados:
           Ex.: export ORACLE_SID=bd_target
                  imp userid =sys/XXX as sysdba file=file.dmp log=file.log full=y
           Obs.: Substitua XXX pela senha do usu�rio sys
    
     d) Pronto, agora � s� conferir se os dados foram recuperados com sucesso!
    