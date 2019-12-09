SET SERVEROUTPUT ON
DECLARE
  v_nome_schema VARCHAR2(30):='&NOME_SCHEMA';  
BEGIN
  -- 1. Desabilita Fk큦
  FOR LINHA_CUR1 IN  ( SELECT      'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME || ' DISABLE CONSTRAINT ' || A.CONSTRAINT_NAME  AS CMD
                  FROM        DBA_CONSTRAINTS A
                  INNER JOIN  DBA_CONSTRAINTS C
                    ON        A.R_CONSTRAINT_NAME = C.CONSTRAINT_NAME
                  WHERE       A.OWNER = v_nome_schema
                  AND         A.CONSTRAINT_TYPE = 'R'
                  AND         C.CONSTRAINT_TYPE = 'P')
  LOOP
    EXECUTE IMMEDIATE LINHA_CUR1.CMD;    
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Passo 1 (desabilita fk큦) executado com sucesso');
                       
  -- 2. Limpa tabelas                       
  FOR LINHA_CUR2 IN   ( SELECT  'TRUNCATE TABLE ' || OWNER || '.' || TABLE_NAME AS CMD
                        FROM    DBA_TABLES 
                        WHERE   OWNER=v_nome_schema)
  LOOP
      EXECUTE IMMEDIATE LINHA_CUR2.CMD;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Passo 2 (limpa tabelas ) executado com sucesso');

  -- 3. Reabilita Fk큦
  FOR LINHA_CUR3 IN   ( SELECT      'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME || ' ENABLE CONSTRAINT ' || A.CONSTRAINT_NAME AS CMD
                        FROM        DBA_CONSTRAINTS A
                        INNER JOIN  DBA_CONSTRAINTS C
                          ON        A.R_CONSTRAINT_NAME = C.CONSTRAINT_NAME
                        WHERE       A.OWNER = v_nome_schema
                        AND         A.CONSTRAINT_TYPE = 'R'
                        AND         C.CONSTRAINT_TYPE = 'P')
  LOOP
     EXECUTE IMMEDIATE LINHA_CUR3.CMD;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Passo 3 (reabilita Fk큦) executado com sucesso');
END;