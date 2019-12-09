-- 1: Parar recuperacao de logs no standby
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

-- 2: Iniciar recuperação de logs no standby
alter database recover managed standby database using current logfile disconnect;

-- 3: Iniciar (startar) manualmente Bd standby
startup mount;
alter database recover managed standby database using current logfile disconnect;
	
-- 4: Realizar switchover manual (sem broker):
--      a) Executar comandos abaixo no atual BD primario:
        SQL> Alter Database Commit to Switchover to standby with session Shutdown;
        SQL>  shutdown immediate;
        SQL>  startup mount;

--      c) Executar comandos abaixo no atual standby que sera o novo primario:
        SQL> Alter Database Recover Managed Standby Database Cancel;
        sql> ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;
        sql> alter database open;
        
--      d) Iniciar recuperacao de logs no novo standby:
        sql> alter database recover managed standby database using current logfile disconnect;
        
--      e) verifique em ambos os BDs se a replicação está funcionando:
        SQL> select process, status, sequence#, block# from v$managed_standby;

        
    
-- Para monitorar a transmissão de dados de redo enviados para o standby habilita trace de archive logs:
-- 	trace_level: 0 = desabilitado, 1 = mapeia arquivamento de redo log file, 2 = status por destino de archive redo log ... 
ALTER SYSTEM SET LOG_ARCHIVE_TRACE = trace_level;

-- Apagar standby redo log group
 alter database drop standby logfile group 4;
 
-- Apagar redo log group
 alter database drop logfile group 4;
		
-- Para desabilitar envio de logs para bd standby, execute o comando abaixo no primario:
alter system set log_archive_dest_state_2=defer scope=both sid='*';

-- Apos shutdown do bd standby é necessário executar os seguintes procedimentos p/ habilitar novamente a replicação e o broker:
    -- a) No Bd primario habilita o 2o destino de archives:
    alter system set log_archive_dest_state_2='ENABLE' scope=both;
    -- b) Entre no DGMGRL no host do bd primario e execute o comando abaixo:
    edit database standby_name set STATE=APPLY-ON