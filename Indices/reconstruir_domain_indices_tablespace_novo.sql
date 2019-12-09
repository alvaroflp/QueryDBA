/*
Para reconstruir domain indexes (ex.: Oracle Text), logue-se com o usuario dono deles
*/

set serveroutput on
DECLARE
  V_SQL VARCHAR2(4000);
  v_novo_tbs VARCHAR2(100):='&NOVO_TABLESPACE';
BEGIN
  DBMS_OUTPUT.ENABLE(null);

  -- seleciona domain indexes invalidos de um determinado schema
  FOR CUR_ROW IN  (SELECT OWNER, INDEX_NAME
                   FROM   ALL_INDEXES 
                   WHERE  TABLE_OWNER = UPPER('&OWNER') AND INDEX_TYPE = 'DOMAIN'
                   and    STATUS = 'VALID')
  LOOP
      --ctx_ddl.create_preference('MY_TEXT_STORE', 'BASIC_STORAGE');
      CTX_DDL.SET_ATTRIBUTE('MY_TEXT_STORE', 'I_TABLE_CLAUSE','TABLESPACE ' || v_novo_tbs);
      CTX_DDL.SET_ATTRIBUTE('MY_TEXT_STORE', 'K_TABLE_CLAUSE','TABLESPACE ' || v_novo_tbs);
      CTX_DDL.SET_ATTRIBUTE('MY_TEXT_STORE', 'R_TABLE_CLAUSE','TABLESPACE ' || v_novo_tbs);
      CTX_DDL.SET_ATTRIBUTE('MY_TEXT_STORE', 'N_TABLE_CLAUSE','TABLESPACE ' || v_novo_tbs);
      CTX_DDL.SET_ATTRIBUTE('MY_TEXT_STORE', 'I_INDEX_CLAUSE','TABLESPACE ' || v_novo_tbs);
      ctx_ddl.set_attribute('MY_TEXT_STORE', 'P_TABLE_CLAUSE','TABLESPACE ' || v_novo_tbs);

      BEGIN
        V_SQL :=  'ALTER INDEX ' || CUR_ROW.OWNER || '.' || CUR_ROW.INDEX_NAME || ' REBUILD ONLINE PARAMETERS (''REPLACE STORAGE ' || USER || '.MY_TEXT_STORE'')'; 
        EXECUTE IMMEDIATE V_SQL;
      EXCEPTION
          WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('Erro ao reconstruir domain index ' || CUR_ROW.OWNER || '.' || CUR_ROW.INDEX_NAME || CHR(13) + CHR(10) || SQLERRM);
      END;
      
      CTX_DDL.DROP_PREFERENCE(USER || '.MY_TEXT_STORE');
      
      DBMS_OUTPUT.PUT_LINE('Domain index ' || CUR_ROW.OWNER || '.' || CUR_ROW.INDEX_NAME || ' reconstruído');
  END LOOP;
END;
/*
BEGIN
CTX_DDL.DROP_PREFERENCE(USER || '.MY_TEXT_STORE');
END;
*/