Passo 1- Criação do BD auxiliar:
     
     Criar BD auxiliar em uma máquina de testes, separada do BD target, via DBCA, utilizando como template o BD target. Durante o processo de instalação é necessário configurar os seguintes parâmetros de inicialização:

    - DB_FILES: Configure para o mesmo valor do Bd target.
          Ex.: DB_FILES = 1000

    - DB_FILE_NAME_CONVERT: Configure para conter o valor do diretório de datafiles do BD target e um valor correspondente ao mesmo diretório p/ o BD auxiliar. Todos os diretórios de datafiles do bd target devem estar contidos neste parâmetro. Antes de configurar este parâmetro crie no bd auxiliar os diretórios correspondentes.
           Ex.:    DB_FILE_NAME_CONVERT = '/oradata/prod','/oradata/aux','/oraind/prod/','/oraind/aux'
        
    - LOG_FILE_NAME_CONVERT:  Configure p/ conter o valor do diretório de logfiles do bd target e um valor correspondente ao mesmo diretório p/ o BD auxiliar. Todos os diretórios de logfiles do bd target devem estar contidos neste parâmetro. Antes de configurar este parâmetro, crie no BD auxiliar os diretórios correspondentes.
           Ex.: LOG_FILE_NAME_CONVERT='/oralog/prod/log1','/oralog/aux/log1'
            
    - SGA_TARGET, SGA_MAX_SIZE e PGA_AGGREGATE_TARGET: Configure para conter um valor que possa ser configurado na máquina de testes, de acordo com a qtde. de RAM disponível.


Passo 2- Recuperação dos dados desejados utilizando o BD auxiliar: 
      
     a) Copie p/ a máquina do BD auxiliar a pasta contendo todas as peças de backup e archive logs (se existir) do BD target;

     b) Na máquina do BD auxiliar acrescente no arquivo tnsnames.ora um álias p/ a instância do BD target. Nome sugerido: PROD.
     
     c) Na máquina do BD auxiliar, inicie o BD auxiliar em modo NOMOUNT:
        
     d) Na máquina do BD auxiliar, conecte-se no RMAN referenciando o BD target e o bd auxiliar:
            Ex.:   export ORACLE_SID=bd_auxiliar
                     rman target sys/XXX@bd_target auxiliary sys/YYY

    e) No prompt de comandos do RMAN, execute o restore e recover de um controlfile do BD target no BD auxiliar e mounte o BD auxiliar (que também será chamado de BD clone):
       Ex.:
             run{
                   set until time "to_date('2011-10-19-12:30:00','yyyy-mm-dd-hh24:mi:ss')";
                   restore clone controlfile;
                   sql clone 'alter database mount clone database';
                   sql 'alter system archive log current';
                   sql 'begin dbms_backup_restore.AutoBackupFlag(FALSE); end;';
             }
        
     f) Execute o restore e recover dos principais datafiles (system, system e undo) do BD target e do(s) datafile(s) correspondente(s) ao tablespace que será recuperado. Para este passo será necessário consultar no BD target o número do(s) datafile(s) desejado(s), através da consulta  abaixo:
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
      
   
Passo 3- Exportação dos dados desejados, do BD auxiliar para o BD de produção:
     
     a) Na máquina do BD auxiliar, execute um export convencional (Datapump não irá funcionar) do(s) schema(s) referente(s) ao tablespace recuperado:
           Ex.: exp userid sys/XXX as sysdba file=file.dmp log=file.log owner=YYY
             Obs.: Substitua XXX pela senha do usuário SYS no Bd auxiliar e YYY pelo nome do usuário que vc precisa recuperar os dados
       
     b) Na máquina do BD target, apague o(s) objeto(s) que vc irá recuperar:
           Ex.: DROP TABLE SCHEMA.TABLE_NAME;
   
     c) Na máquina do BD target copie o dump gerado no item a) deste passo e faça um import convencional dos dados desejados:
           Ex.: export ORACLE_SID=bd_target
                  imp userid =sys/XXX as sysdba file=file.dmp log=file.log full=y
           Obs.: Substitua XXX pela senha do usuário sys
    
     d) Pronto, agora é só conferir se os dados foram recuperados com sucesso!
    