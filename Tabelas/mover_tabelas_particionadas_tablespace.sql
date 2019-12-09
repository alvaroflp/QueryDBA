declare
  p_Mensagem_Retorno VARCHAR2(1000);
  v_txtSQL VARCHAR2(1000);
  v_tbs_temp VARCHAR2(100):=UPPER('&TBS_TEMP');
BEGIN
    dbms_output.enable(null);
    FOR cur_tab IN (  SELECT      t.owner, 
                                  t.table_name,
                                  tp.PARTITION_NAME
                        FROM      dba_tables t
                        inner join  dba_tab_partitions tp
                            on      t.owner = tp.TABLE_OWNER
                            and     t.table_name = tp.table_name
                        WHERE     owner = UPPER('&SCHEMA_NAME')
                        AND       partitioned = 'YES'
                        --AND     (owner, table_name) NOT IN (SELECT OWNER, MVIEW_NAME FROM DBA_MVIEWS)
                        ORDER BY  1, 2 ) loop
      BEGIN
          v_txtSQL:= 'ALTER TABLE ' || cur_tab.owner || '.' ||  cur_tab.table_name || ' MOVE PARTITION ' || cur_tab.PARTITION_NAME || ' TABLESPACE ' || v_tbs_temp;          
          dbms_output.put_line(v_txtSQL);
          EXECUTE IMMEDIATE v_txtSQL;
          dbms_output.put_line('Partição ' || cur_tab.PARTITION_NAME || ' movida com sucesso p/ o tablespace ' || v_tbs_temp || '!');
      EXCEPTION
          WHEN OTHERS THEN
            dbms_output.put_line('ERRO: ' || SQLCODE || ' ao mover partição ' || cur_tab.PARTITION_NAME || ' da tabela ' || cur_tab.owner || '.' ||  cur_tab.table_name);
      END;
   END LOOP;
END;