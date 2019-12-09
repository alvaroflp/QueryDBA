SET SERVEROUTPUT ON
BEGIN
-- reconstroi indices de um determinado schema (exceto LOB e IOT).
    dbms_output.enable(null);
    FOR cur_tab IN (select  'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' REBUILD ' || 
                          DECODE(INDEX_TYPE,'DOMAIN','',' ONLINE') CMD,
                            OWNER, 
                            INDEX_NAME 
                    FROM    ALL_INDEXES
                    WHERE   OWNER = UPPER('&SCHEMA_NAME')
                    AND     index_type NOT IN ('IOT - TOP','LOB')) LOOP
        EXECUTE IMMEDIATE cur_tab.CMD;
        dbms_output.put_line(cur_tab.OWNER || '.' || cur_tab.INDEX_NAME || ' reconstruido!');
    END LOOP;
END;