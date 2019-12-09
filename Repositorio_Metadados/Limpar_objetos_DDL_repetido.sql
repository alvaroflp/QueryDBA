-- script para limpar objetos no repositorio de metadados com codigo ddl repetidos em datas sequenciais 
SET SERVEROUTPUT ON
DECLARE
  S_DDL_LINHA_ANTERIOR CLOB;
  S_DDL_LINHA_ATUAL CLOB;
  v_NOME_COMPLETO_OBJETO_ATUAL VARCHAR2(4000) := NULL;
  v_NOME_COMPLETO_OBJETO_ANT VARCHAR2(4000) := NULL;
  V_CONT NUMBER:=0;
  CURSOR CR IS
    SELECT    --ROWID, 
              OBJECT_DDL, SCHEMA, OBJECT, OBJECT_TYPE
    FROM      STBD.DBA_METADATA_OBJ M    
    ORDER BY  SCHEMA, OBJECT_TYPE, OBJECT FOR UPDATE;
BEGIN
  -- efetua loop para verificar objetos de BD tais como: indices, tabelas, procedures, packages e funções
  FOR LINHA IN CR
  LOOP
      DBMS_OUTPUT.ENABLE(NULL);
      
      -- recupera DDL e nome do objeto da linha atual
     S_DDL_LINHA_ATUAL := LINHA.OBJECT_DDL;
     v_NOME_COMPLETO_OBJETO_ATUAL := LINHA.SCHEMA || '.' || LINHA.OBJECT_TYPE || '.' || LINHA.OBJECT;
           
      -- exclui linha atual da tabela somente se o codigo DDL dela for igual ao da linha anterior
      IF (v_NOME_COMPLETO_OBJETO_ANT IS NOT NULL
            AND v_NOME_COMPLETO_OBJETO_ANT = v_NOME_COMPLETO_OBJETO_ATUAL
            AND S_DDL_LINHA_ANTERIOR IS NOT NULL 
            AND dbms_lob.compare(S_DDL_LINHA_ANTERIOR, S_DDL_LINHA_ATUAL) = 0) THEN
          DBMS_OUTPUT.PUT_LINE(v_NOME_COMPLETO_OBJETO_ATUAL || ' É = LINHA ANTERIOR: ');
          --DELETE FROM STBD.DBA_METADATA_OBJ WHERE ROWID = LINHA.ROWID;
          DELETE FROM STBD.DBA_METADATA_OBJ WHERE current of CR;
      ELSE
          DBMS_OUTPUT.PUT_LINE(v_NOME_COMPLETO_OBJETO_ATUAL || ' É <> LINHA ANTERIOR: ');
      END IF;
      
      -- recupera DDL e nome do objeto da linha atual para comparar na proxima iteracao como linha anterior 
      S_DDL_LINHA_ANTERIOR := LINHA.OBJECT_DDL;
      v_NOME_COMPLETO_OBJETO_ANT := LINHA.SCHEMA || '.' || LINHA.OBJECT_TYPE || '.' || LINHA.OBJECT;
  END LOOP;
  
  COMMIT;
END;
/

-- Efetua manutencao na tabela do repositorio
ALTER TABLE STBD.DBA_METADATA_OBJ ENABLE ROW MOVEMENT;
ALTER TABLE STBD.DBA_METADATA_OBJ shrink space;