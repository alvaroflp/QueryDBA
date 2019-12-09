-- mover LOB para um novo tablespace:
SET serveroutput on
declare
  v_txtSQL VARCHAR2(1000);
  v_tbs_novo VARCHAR2(100):=UPPER('&TABLESPACE_NOVO');
BEGIN
    dbms_output.enable(null);
    FOR cur_tab IN ( SELECT     owner,
                                table_name,
                                column_name
                      FROM      dba_lobs
                      WHERE     tablespace_name = UPPER('&TABLESPACE_ORIGINAL')
                      AND       OWNER = '&SCHEMA_NAME'
                      ORDER BY  1, 2 ) loop
      BEGIN
          v_txtSQL:= 'ALTER TABLE ' || cur_tab.owner || '.' || cur_tab.table_name || ' MOVE LOB(' || cur_tab.column_name  || ')' || 'STORE AS (TABLESPACE ' || v_tbs_novo || ')';
          dbms_output.put_line(v_txtSQL);
          EXECUTE IMMEDIATE v_txtSQL;
          dbms_output.put_line('LOB em ' || cur_tab.owner || '.' ||  cur_tab.table_name || '.' || cur_tab.column_name || ' movido com sucesso p/ o tablespace ' || v_tbs_novo || '!');
      EXCEPTION
          WHEN OTHERS THEN
            dbms_output.put_line('ERRO: ' || SQLCODE || ' ao mover lob ' || cur_tab.owner || '.' ||  cur_tab.table_name || '.' || cur_tab.column_name);
      END;
   END LOOP;
END;