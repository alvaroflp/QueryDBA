SET SERVEROUTPUT ON
BEGIN
-- reconstroi indices invalidos de um determinado schema, sem logging e com paralelismo (exceto LOB, IOT e DOMAIN).
    dbms_output.enable(null);
    FOR CUR_TAB IN (SELECT  'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' REBUILD ' || 
                          DECODE(INDEX_TYPE,'DOMAIN','',' ONLINE') || ' PARALLEL 4 NOLOGGING' CMD,
                            OWNER, 
                            INDEX_NAME 
                    FROM    ALL_INDEXES
                    WHERE   OWNER = UPPER('&SCHEMA_NAME')
                    AND     INDEX_TYPE NOT IN ('IOT - TOP','LOB','DOMAIN')
                    AND     STATUS <> 'VALID') LOOP
      BEGIN
          EXECUTE IMMEDIATE cur_tab.CMD;
          EXECUTE IMMEDIATE 'ALTER INDEX ' || OWNER || '.' || INDEX_NAME ' NOPARALLEL';
          DBMS_OUTPUT.PUT_LINE(CUR_TAB.OWNER || '.' || CUR_TAB.INDEX_NAME || ' reconstruido!');
      EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Indice ' || CUR_TAB.OWNER || '.' || CUR_TAB.INDEX_NAME || CHR(13) || CHR(10) || SQLERRM);
      END;
    END LOOP;
END;