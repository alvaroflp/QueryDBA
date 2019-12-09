-- Verifica se existem linhas encadeadas/migradas em todas as tabelas do BD:
declare 
    v_SQL VARCHAR2(1000);
    v_contador NUMBER;
begin
        dbms_output.enable(null);
        FOR cur_tab IN (SELECT      owner, 
                                    table_name
                        FROM        dba_tables
                        WHERE       owner NOT IN ('SYS','SYSTEM','WKSYS','WMSYS','XDB','DBSNMP','OLAPSYS','MDSYS','EXFSYS','CTXSYS')
                        AND         status = 'VALID'
                        AND         num_rows > 0
                        AND         (owner, table_name) NOT IN (SELECT OWNER, MVIEW_NAME FROM DBA_MVIEWS)
                        ORDER BY    1, 2 ) loop
            
            v_SQL:='ANALYZE TABLE ' || cur_tab.owner || '.' || cur_tab.table_name || ' COMPUTE STATISTICS';
            EXECUTE IMMEDIATE v_SQL;
            
             --Verifica se existem linhas encadeadas/migradas
            v_SQL:='SELECT  NVL(SUM(Chain_cnt),0)
                FROM    DBA_TABLES
                WHERE   owner = ''' || cur_tab.owner || '''
                AND     table_name = ''' || cur_tab.table_name || '''
                AND     status = ''VALID''
                AND     chain_cnt > 0';
            EXECUTE IMMEDIATE v_SQL INTO v_contador;
            dbms_output.put_line('A tabela ' || cur_tab.owner || '.' || cur_tab.table_name || ' possui ' || v_contador || ' lem(s)');            
        end loop;
exception
    when others then
        rollback;
        raise;
end;