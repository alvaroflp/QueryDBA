BEGIN
    dbms_output.enable(null);
    FOR cur_tab IN (select  'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' NOLOGGING' AS CMD,
                    OWNER, INDEX_NAME
                    FROM    DBA_INDEXES
                    WHERE   OWNER = UPPER('&SCHEMA_NAME')
                    AND     index_type NOT IN ('IOT - TOP','LOB','DOMAIN')
                    AND     LOGGING = 'YES') LOOP
        BEGIN
            EXECUTE IMMEDIATE cur_tab.CMD;
            dbms_output.put_line(cur_tab.OWNER || '.' || cur_tab.INDEX_NAME || ' alterado para NOLOGGING!');
        EXCEPTION
            WHEN OTHERS THEN
              dbms_output.put_line('Erro ' || SQLCODE || ' ao alterar ' || cur_tab.OWNER || '.' || cur_tab.INDEX_NAME);
        END;
    END LOOP;
END;