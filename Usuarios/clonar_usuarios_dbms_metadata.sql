 SET SERVEROUTPUT ON 
 DECLARE 
  V_SQL CLOB;
 BEGIN
    FOR LINHA IN (  SELECT  * 
                    FROM    DBA_USERS 
                    WHERE   regexp_like(USERNAME,'^U\d*[0-9]')
                    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Usuário: ' || LINHA.USERNAME);
        SELECT DBMS_METADATA.GET_DDL('USER',LINHA.USERNAME) INTO V_SQL FROM DUAL;
        
        -- cria usuario com D
        V_SQL:=REPLACE(V_SQL, LINHA.USERNAME, 'D' || SUBSTR(LINHA.USERNAME, 2));
        BEGIN
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('Novo usuário ' || REPLACE(LINHA.USERNAME,'U','D') || ' criado!');
        EXCEPTION
            WHEN OTHERS THEN
              IF SQLCODE = -01920 THEN
                DBMS_OUTPUT.PUT_LINE('Usuário ' || REPLACE(LINHA.USERNAME,'U','D') || ' já existe');
              ELSE
                raise_application_error(-20001, 'Erro ' || sqlerrm);
              END IF;
        END;        
        
        -- atribui roles para novo usuário D
        BEGIN
            SELECT DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT',LINHA.USERNAME) INTO V_SQL FROM DUAL;
            V_SQL:=REPLACE(V_SQL, LINHA.USERNAME, 'D' || SUBSTR(LINHA.USERNAME, 2));            
            STBD.EXECUTA_CLOB_N_LINHAS(V_SQL);
            DBMS_OUTPUT.PUT_LINE('Roles atribuídas para o usuário ' || REPLACE(LINHA.USERNAME,'U','D'));
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERRO ATRIBUI ROLES ' || SQLERRM);
        END;
        
        -- atribui grants de objeto para novo usuário D
        BEGIN
            SELECT DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT',LINHA.USERNAME) INTO V_SQL FROM DUAL;
            V_SQL:=REPLACE(V_SQL, LINHA.USERNAME, 'D' || SUBSTR(LINHA.USERNAME, 2));
            STBD.EXECUTA_CLOB_N_LINHAS(V_SQL);
            DBMS_OUTPUT.PUT_LINE('Grants de objeto atribuídos para o usuário ' || REPLACE(LINHA.USERNAME,'U','D'));
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERRO ATRIBUI OBJECT GRANTS ' || SQLERRM);
        END;
        
        -- atribui grants de sistema para novo usuário D
        BEGIN
            SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT',LINHA.USERNAME) INTO V_SQL FROM DUAL;
            V_SQL:=REPLACE(V_SQL, LINHA.USERNAME, 'D' || SUBSTR(LINHA.USERNAME, 2));
            STBD.EXECUTA_CLOB_N_LINHAS(V_SQL);
            DBMS_OUTPUT.PUT_LINE('Grants de sistema atribuídos para o usuário ' || REPLACE(LINHA.USERNAME,'U','D'));
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERRO ATRIBUI SYSTEM GRANTS ' || SQLERRM);
        END;
    END LOOP;
END; 