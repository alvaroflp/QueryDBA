-- habilita auditoria DML e execucao de blocos PLSQL nomeados para um determinado usuario (pode-se habilitar p/ mais de um usuario separando-os por virgula)
AUDIT SELECT TABLE, INSERT TABLE, DELETE TABLE, UPDATE TABLE, EXECUTE PROCEDURE
      BY &username BY SESSION;
      --WHENEVER NOT SUCCESSFUL;   -- incluir essa clausula se quiser habilitar somente tentativa de acesso com erro
	    
-- remover auditoria habilitada anteriormente
NOAUDIT SELECT TABLE, INSERT TABLE, DELETE TABLE, UPDATE TABLE, EXECUTE PROCEDURE by &USERNAME;