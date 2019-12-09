SET SERVEROUTPUT ON
DECLARE 
    v_nome_usuario VARCHAR2(30):='&NOME_USUARIO';
    v_senha_usuario VARCHAR2(30):='&SENHA_USUARIO';
    
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER ' || v_nome_usuario || ' PROFILE "DEFAULT" 
            IDENTIFIED BY ' || v_senha_usuario || ' DEFAULT TABLESPACE "USERS" 
            TEMPORARY TABLESPACE "TEMP" 
            QUOTA UNLIMITED 
            ON "USERS" 
            ACCOUNT UNLOCK';
    
     EXECUTE IMMEDIATE 'GRANT DBA TO ' || v_nome_usuario;
     EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO ' || v_nome_usuario;
     DBMS_OUTPUT.ENABLE(NULL);
     dbms_output.put_line('Usuario ''' || v_nome_usuario || ''' criado com sucesso!');     
END;