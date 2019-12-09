-- script que pode ser utilizado para redimensionar datafiles p/ o menor tamanho possivel (ate HWM do datafile):
set serveroutput on
declare  
  v_txtCmd VARCHAR2(4000);
BEGIN   
  dbms_output.enable(null);
  
  -- limpa recyclebin do database, pois se existirem objetos na lixeira, eles ainda ocupam blocos nos datafiles
  EXECUTE IMMEDIATE 'PURGE DBA_RECYCLEBIN';
  
  FOR CUR IN (SELECT      FILE_NAME,
                          ceil( (nvl(hwm,1)*t.block_size)/1024/1024 ) smallest,
                          ceil( blocks*t.block_size/1024/1024) currsize,
                          ceil( blocks*t.block_size/1024/1024) -
                              ceil( (nvl(hwm,1)*t.block_size)/1024/1024 ) savings
              FROM        DBA_DATA_FILES A
              INNER JOIN  DBA_TABLESPACES T
                  on      T.TABLESPACE_NAME = a.TABLESPACE_NAME
              left join  ( select    file_id, 
                                      max(block_id+blocks-1) hwm
                            from      dba_extents
                            group by  file_id ) b
                  ON        A.FILE_ID = B.FILE_ID
              WHERE a.TABLESPACE_NAME='AUDSYS'
              )
              
  LOOP
      if cur.savings > 0 then
          v_txtCmd:='';
          
          select      'alter database datafile '''|| cur.file_name||''' resize ' || cur.smallest || 'm'
          INTO        v_txtCmd
          from        dual;
          
          BEGIN
              execute immediate v_txtCmd;
              DBMS_OUTPUT.PUT_LINE('Comando executado com sucesso: ' || v_txtCmd);
          EXCEPTION
              WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ' || SQLERRM || ' ao executar o comando: ' || v_txtCmd);
          END;
      ELSE
          DBMS_OUTPUT.PUT_LINE('Não há espaço para reduzir o datafile ' || cur.file_name || ' acima de HWM');
      end if;  
  END LOOP;
END;