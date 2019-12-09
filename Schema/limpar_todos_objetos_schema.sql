-- executar o script 
SET SERVEROUTPUT ON
DECLARE
  v_nome_schema VARCHAR2(30):='&SCHEMA_NAME';
  v_cont NUMBER := 0;
BEGIN
  FOR LINHA_CUR1 IN  (  SELECT  'DROP ' || OBJECT_TYPE || ' ' || OWNER || '.' ||  OBJECT_NAME AS CMD
                                owner, OBJECT_NAME
                        FROM    DBA_OBJECTS 
                        WHERE   OWNER = v_nome_schema)
  LOOP
    BEGIN
        EXECUTE IMMEDIATE LINHA_CUR1.CMD;
        DBMS_OUTPUT.PUT_LINE('Objeto  ' || LINHA_CUR1.owner || '.' || LINHA_CUR1.OBJECT_NAME || ' apagado com sucesso!');
    EXCEPTION
        WHEN OTHERS THEN
            v_cont := v_cont + 1;
            DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
    END;        
  END LOOP;
  
  EXECUTE IMMEDIATE 'purge dba_recyclebin';
  
  IF v_cont = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Todos os objetos do schema ' || v_nome_schema || ' foram apagados com sucesso!');
  ELSE
      DBMS_OUTPUT.PUT_LINE(v_cont || ' objetos do schema ' || v_nome_schema || ' NÃO foram apagados. Execute o script novamente.');
  END IF;
END;