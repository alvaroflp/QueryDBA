SET SERVEROUTPUT ON
BEGIN
-- reconstroi indices de um schema em um "novo" tablespace (exceto LOB, IOT e DOMAIN)
-- necessario que o dono schema tenha privilegios de gravacao no tablespace indicado
    dbms_output.enable(null);
    --alter index <index_name> rebuild tablespace <new_tablespace> online nologging:
    FOR cur_tab IN (select  'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' REBUILD ONLINE nologging TABLESPACE &NOVO_TABLESPACE_NAME' CMD,
                            OWNER,
                            INDEX_NAME
                    FROM    ALL_INDEXES
                    WHERE   OWNER = UPPER('&SCHEMA_NAME')
                     AND     index_type NOT IN ('IOT - TOP','LOB','DOMAIN')) LOOP
        EXECUTE IMMEDIATE CUR_TAB.CMD;
        dbms_output.put_line(cur_tab.OWNER || '.' || cur_tab.INDEX_NAME || ' reconstruido!');
    END LOOP;
END;