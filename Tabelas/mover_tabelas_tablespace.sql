declare
  p_Mensagem_Retorno VARCHAR2(1000);
  v_txtSQL VARCHAR2(1000);
  v_tbs_temp VARCHAR2(100):=UPPER('&TBS_NOVO');
BEGIN
    dbms_output.enable(null);
    FOR cur_tab IN (  SELECT      owner, 
                                  table_name
                        FROM      dba_tables
                        WHERE     owner = UPPER('&SCHEMA_NAME')
                        AND       partitioned = 'NO'
                        AND       tablespace_name <> v_tbs_temp
                        --AND     (owner, table_name) NOT IN (SELECT OWNER, MVIEW_NAME FROM DBA_MVIEWS)
                        ORDER BY  1, 2 ) loop
      BEGIN
          v_txtSQL:= 'ALTER TABLE ' || cur_tab.owner || '.' ||  cur_tab.table_name || ' MOVE TABLESPACE ' || v_tbs_temp;
          --dbms_output.put_line(v_txtSQL);
          EXECUTE IMMEDIATE v_txtSQL;
          dbms_output.put_line('Tabela ' || cur_tab.owner || '.' ||  cur_tab.table_name || ' movida com sucesso p/ o tablespace ' || v_tbs_temp || '!');
      EXCEPTION
          WHEN OTHERS THEN
            dbms_output.put_line('ERRO: ' || SQLCODE || ' ao mover tabela ' || cur_tab.owner || '.' ||  cur_tab.table_name);
      END;
   END LOOP;
END;