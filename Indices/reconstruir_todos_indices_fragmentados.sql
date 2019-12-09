DECLARE
    V_PCT_USED_ANTES NUMBER;
    V_PCT_USED_DEPOIS NUMBER;
    V_SQL VARCHAR2(1000);
    V_SPACE_ANTES NUMBER;
    v_space_DEPOIS NUMBER;
BEGIN
    DBMS_OUTPUT.ENABLE(null);

    FOR CUR IN (SELECT  OWNER, INDEX_NAME, INDEX_TYPE
                FROM    DBA_INDEXES 
                WHERE   OWNER NOT IN ('SYS', 'SYSTEM','XDB','CTXSYS','EXFSYS','MDSYS')
                AND   OWNER = 'ADMSADP'
                and     index_type not in ('LOB','IOT - TOP'))
    LOOP
          -- analisa o indice
          BEGIN
                EXECUTE IMMEDIATE 'ANALYZE INDEX ' || cur.OWNER || '.' || cur.INDEX_NAME || ' VALIDATE STRUCTURE';
          EXCEPTION
                  WHEN OTHERS THEN
                      DBMS_OUTPUT.PUT_LINE('ERRO AO RECONSTRUIR INDICE ' || CUR.OWNER  || '.' || CUR.INDEX_NAME);
          END;
              
          -- verifica o espaço utilizado pelo indice
          SELECT  PCT_USED,  BTREE_SPACE INTO V_PCT_USED_ANTES, V_SPACE_ANTES
          FROM    INDEX_STATS;                   
          
          -- reconstroi indice se espaco usado for menor que 50%
          IF V_PCT_USED_ANTES < 50 AND V_SPACE_ANTES > 8000 THEN
              SELECT  'ALTER INDEX ' || CUR.OWNER || '.' || CUR.INDEX_NAME || ' REBUILD nologging ' ||
                          DECODE(cur.INDEX_TYPE,'DOMAIN','',' ONLINE') INTO V_SQL
              FROM    DUAL;
              
              BEGIN
              --DBMS_OUTPUT.PUT_LINE(V_SQL);
                  EXECUTE IMMEDIATE V_SQL;
              EXCEPTION
                  WHEN OTHERS THEN
                      DBMS_OUTPUT.PUT_LINE('ERRO AO RECONSTRUIR INDICE ' || CUR.OWNER  || '.' || CUR.INDEX_NAME);
              END;
              
              BEGIN
                  -- analisa o indice apos reconstrucao
                  EXECUTE IMMEDIATE 'ANALYZE INDEX ' || cur.OWNER || '.' || cur.INDEX_NAME || ' VALIDATE STRUCTURE';
              EXCEPTION
                  WHEN OTHERS THEN
                      DBMS_OUTPUT.PUT_LINE('ERRO AO RECONSTRUIR INDICE ' || CUR.OWNER  || '.' || CUR.INDEX_NAME);
              END;
                  
              -- verifica o espaco depois da reconstrucao
              SELECT  PCT_USED,  BTREE_SPACE INTO V_PCT_USED_depois, V_SPACE_depois
              FROM    INDEX_STATS;
    
              DBMS_OUTPUT.PUT_LINE(CUR.OWNER || '.' || CUR.INDEX_NAME || 
                  ' -> PCT USED/BTREE SPACE ANTES: ' || V_PCT_USED_ANTES || '/' ||  V_SPACE_ANTES || 
                  ' --- PCT USED/BTREE SPACE DEPOIS: ' || V_PCT_USED_DEPOIS || '/' ||  V_SPACE_DEPOIS);                                             
          END IF;
          
    END LOOP;
END;