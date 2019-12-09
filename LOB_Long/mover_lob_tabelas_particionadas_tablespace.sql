-- mover LOB de uma tabela particionada para um novo tablespace:
DECLARE
    p_Mensagem_Retorno  VARCHAR2(1000);
    v_txtSQL            VARCHAR2(1000);
    v_tbs_temp          VARCHAR2(100) := UPPER('&TBS_LOB');

BEGIN
    dbms_output.enable(null);
    
    FOR cur_tab IN (  SELECT      L.owner, 
                                  L.table_name,
                                  LP.PARTITION_NAME,
                                  L.column_name,
                                  TP.TABLESPACE_NAME
                        FROM      dba_lob_partitions LP
                                  INNER JOIN  dba_lobs L
                                      ON      LP.TABLE_OWNER = L.owner
                                      AND     LP.table_name = L.table_name
                                      AND     LP.COLUMN_NAME = L.COLUMN_NAME
                                  INNER JOIN DBA_TAB_PARTITIONS TP
                                      ON LP.PARTITION_NAME = TP.PARTITION_NAME
                                      AND LP.TABLE_NAME = TP.TABLE_NAME
                                      AND LP.TABLE_OWNER = TP.TABLE_OWNER
                        WHERE     L.owner = UPPER('&SCHEMA_NAME')
                        ORDER BY  2, 3, 4 ) LOOP
      BEGIN
          v_txtSQL:= 'ALTER TABLE ' || cur_tab.owner || '.' ||  cur_tab.table_name || ' MOVE PARTITION ' || cur_tab.PARTITION_NAME ||
                     ' TABLESPACE ' || cur_tab.TABLESPACE_NAME || ' LOB (' || cur_tab.column_name || ') STORE AS (TABLESPACE ' || v_tbs_temp || ')';          

          dbms_output.put_line(v_txtSQL);

          EXECUTE IMMEDIATE v_txtSQL;

          dbms_output.put_line('LOB em ' || cur_tab.owner || '.' ||  cur_tab.table_name || '.' || cur_tab.column_name || ' da partição ' || cur_tab.PARTITION_NAME || ' movido com sucesso p/ o tablespace ' || v_tbs_temp || '!');

      EXCEPTION
          WHEN OTHERS THEN
            dbms_output.put_line('ERRO: ' || SQLCODE || ' ao mover partição ' || cur_tab.PARTITION_NAME || ' da tabela ' || cur_tab.owner || '.' ||  cur_tab.table_name);

      END;
   END LOOP;
END;