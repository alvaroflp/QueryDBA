
SET SERVEROUTPUT ON
UNDEFINE SCHEMA_NAME
-- compacta tabelas, indices e lobs de um determinado schema.
BEGIN
    DBMS_OUTPUT.ENABLE(NULL);
    
    -- passo 1: habilita row movement
    FOR CUR_TAB IN (    SELECT  'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' ENABLE ROW MOVEMENT' AS CMD,
                        OWNER, TABLE_NAME
                        FROM    ALL_TABLES
                        WHERE   OWNER = UPPER('&&SCHEMA_NAME')
                        AND     IOT_NAME IS NULL
                        AND     IOT_TYPE IS NULL
                        AND     STATUS = 'VALID'
                        AND     TABLE_NAME NOT LIKE 'DR$%'
                        AND     ROW_MOVEMENT = 'DISABLED') 
    LOOP
        BEGIN
            EXECUTE IMMEDIATE cur_tab.CMD;
            dbms_output.put_line(cur_tab.OWNER || '.' || cur_tab.TABLE_NAME || ' ENABLE ROW MOVEMENT OK!');
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('*** ENABLE ROW MOVEMENT FAILED: '|| SQLERRM);
        END;
    END LOOP;
    
    -- passo 2: compacta tabelas e indices
    FOR CUR_TAB2 IN (   SELECT  'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' SHRINK SPACE CASCADE' AS CMD,
                                OWNER, TABLE_NAME
                        FROM    ALL_TABLES
                        WHERE   OWNER = UPPER('&&SCHEMA_NAME')
                        AND     IOT_NAME IS NULL
                        AND     IOT_TYPE IS NULL
                        AND     STATUS = 'VALID'                        
                        AND     TABLE_NAME NOT LIKE 'DR$%')
    LOOP
        BEGIN
            EXECUTE IMMEDIATE cur_tab2.CMD;
            dbms_output.put_line(cur_tab2.OWNER || '.' || cur_tab2.TABLE_NAME || ' SHRINK SPACE CASCADE OK!');
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('*** SHRINK TABLE/INDEX FAILED: '|| cur_tab2.OWNER || '.' || cur_tab2.TABLE_NAME || ' - ' || SQLERRM);
        END;
    END LOOP;
    
    -- passo 3: compacta lobs
     FOR CUR_LOBS IN (  SELECT     'ALTER TABLE ' || owner || '.' || table_name || ' MODIFY LOB (' || column_name || ') (SHRINK SPACE)' as CMD,
                                  TABLE_NAME, OWNER, column_name
                        FROM      DBA_LOBS
                        WHERE     OWNER = UPPER('&&SCHEMA_NAME')
                         AND      TABLE_NAME NOT LIKE 'DR$%')
    LOOP
        BEGIN
            EXECUTE IMMEDIATE CUR_LOBS.CMD;
            dbms_output.put_line(CUR_LOBS.OWNER || '.' || CUR_LOBS.TABLE_NAME || '.' || CUR_LOBS.column_name || ' SHRINK LOB OK!');
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('*** SHRINK LOB FAILED: '|| CUR_LOBS.OWNER || '.' || CUR_LOBS.TABLE_NAME || ' - ' || SQLERRM);
        END;
    END LOOP;    
END;