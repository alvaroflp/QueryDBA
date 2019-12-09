-- compila funcoes invalidas com mensagem de status informando se compilou com sucesso ou nao:
BEGIN
  FOR cur_rec IN (SELECT owner,
                         object_name,
                         object_type
                  FROM   dba_objects
                  WHERE  object_type IN ('FUNCTION')
                  AND    status != 'VALID')
  LOOP
    BEGIN
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || 
            ' "' || cur_rec.owner || '"."' || cur_rec.object_name || '" COMPILE';
        
        COMMIT;
            
        DBMS_OUTPUT.put_line(cur_rec.object_type || ' : ' || cur_rec.owner || 
                             ' : ' || cur_rec.object_name || ' -> COMPILED');      
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(cur_rec.object_type || ' : ' || cur_rec.owner || 
                             ' : ' || cur_rec.object_name || ' -> COMPILE FAILED');
    END;
  END LOOP;
END;
