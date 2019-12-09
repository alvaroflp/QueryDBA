-- 1: conectar-se no RMAN localmente no servidor do BD:
rman target / catalog /@rman

-- 2: definir horArio que o tablespace serA recuperado. Se o problema ocorreu às 18h do dia x, escolha um horário anterior nesta data, fazendo as devidas substituições no comando abaixo:
  --  a) NOME_TABLESPACE = Nome do tablespace que será recuperado
  --  b) dd/mm/yyyy = dia, mês, ano e horário em que os dados estavam integros ou que continham as informações desejadas
  --  c) /DIRETORIO = diretório para criar automaticamente a instância auxiliar temporária para efetuar a recuperação (Ex.: /oratmp/aux)
      restore tablespace NOME_TABLESPACE;
      recover tablespace NOME_TABLESPACE until time "to_date('dd/mm/yyyy hh:mi:ss','dd/mm/yyyy hh24:mi:ss')" auxiliary destination 'DIRETORIO';

-- 3: se a recuperação ocorreu com sucesso, para finalizar volte o tablespace para o estado ONLINE:
  -- a) primeiro verifique se o tablespace está offline:
      select tablespace_name, status from dba_tablespaces where tablespace_name='&NOME_TABLESPACE';
  -- b) descubra o file_id do(s) datafile(s) correspondente ao tablespace que esta offline
      select file_id, file_name, tablespace_name from dba_DATA_FILES where tablespace_name='&NOME_TABLESPACE';
  -- c) mude p/ online o status do datafile descoberto no passo anterior (informar file_id)
      alter database datafile file_id online;
  -- d) mude p/ online o status do tablespace
      alter tablespace NOME_TABLESPACE online;


-- Mais informações: http://eduardolegatti.blogspot.com.br/2010/03/database-point-in-time-recovery-dbpitr.html