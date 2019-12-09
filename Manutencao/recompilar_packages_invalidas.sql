-- compila packages invalidas com mensagem de status informando se compilou com sucesso ou nao
BEGIN
  FOR cur_rec IN (SELECT owner,
                         object_name,
                         object_type,
                         DECODE(object_type, 'PACKAGE', 1,
                                             'PACKAGE BODY', 2, 2) AS recompile_order
                  FROM   dba_objects
                  WHERE  object_type IN ('PACKAGE', 'PACKAGE BODY')
                  AND    status != 'VALID'
                  ORDER BY 4)
  LOOP
    BEGIN
      IF cur_rec.object_type = 'PACKAGE' THEN
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || 
            ' "' || cur_rec.owner || '"."' || cur_rec.object_name || '" COMPILE';
            
        DBMS_OUTPUT.put_line(cur_rec.object_type || ' : ' || cur_rec.owner || 
                             ' : ' || cur_rec.object_name || ' -> COMPILED');
      ElSE
        EXECUTE IMMEDIATE 'ALTER PACKAGE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '" COMPILE BODY';
            
        COMMIT;
            
        DBMS_OUTPUT.put_line(cur_rec.owner || ' : ' || cur_rec.object_name || ' -> COMPILED');
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(cur_rec.object_type || ' : ' || cur_rec.owner || 
                             ' : ' || cur_rec.object_name || ' -> COMPILE FAILED');
    END;
  END LOOP;
END;