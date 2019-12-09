-- move colunas e indices lob para outro tablespace
BEGIN
    dbms_output.enable(null);
    --alter index <index_name> rebuild tablespace <new_tablespace> online nologging:
    FOR cur_tab IN (select    'ALTER TABLE ' || I.OWNER || '.' || I.TABLE_NAME || ' MOVE LOB (' || 
                        C.COLUMN_NAME || ') STORE AS (TABLESPACE ' || UPPER('&TABLESPACE_INDICE') || ')' CMD,
                              I.OWNER,
                              I.INDEX_NAME
                    FROM          DBA_INDEXES I
                    INNER JOIN    DBA_LOBS C
                        ON        I.OWNER = C.OWNER
                        AND       I.table_name = C.TABLE_NAME
                        AND       I.index_name = C.INDEX_NAME
                    WHERE         I.OWNER = UPPER('&SCHEMA_NAME')
                     AND     index_type = 'LOB') LOOP
        EXECUTE IMMEDIATE cur_tab.CMD;
        dbms_output.put_line(cur_tab.OWNER || '.' || cur_tab.INDEX_NAME || ' movido para o novo tablespace!');
    END LOOP;
END;