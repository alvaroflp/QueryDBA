-- habilita auditoria em todos os objetos auditaveis de um usuario especifico
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    V_SQL VARCHAR2(4000);
BEGIN
    FOR LINHA IN  ( SELECT  OWNER, OBJECT_NAME, OBJECT_TYPE
                    FROM    DBA_OBJECTS 
                    WHERE   OWNER = '&USERNAME'
                    AND     OBJECT_TYPE IN ('TABLE', 'SEQUENCE', 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'MATERIALIZED VIEW, VIEW')
                  )
    LOOP
        IF LINHA.OBJECT_TYPE = 'TABLE' THEN
            V_SQL := 'AUDIT SELECT, INSERT, UPDATE, DELETE ON ' || LINHA.OWNER || '.' || LINHA.OBJECT_NAME || ' BY ACCESS';
        ELSIF LINHA.OBJECT_TYPE IN ('SEQUENCE','MATERIALIZED VIEW', 'VIEW') THEN
            V_SQL := 'AUDIT SELECT ON ' || LINHA.OWNER || '.' || LINHA.OBJECT_NAME || ' BY ACCESS';
        ELSE
            V_SQL := 'AUDIT EXECUTE ON ' || LINHA.OWNER || '.' || LINHA.OBJECT_NAME || ' BY ACCESS';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(V_SQL || ' - EXECUTADO COM SUCESSO!' );
        
        EXECUTE IMMEDIATE V_SQL;
    END LOOP;
END;


-- desabilita auditoria em todos os objetos auditaveis de um usuario especifico
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    V_SQL VARCHAR2(4000);
BEGIN
    FOR LINHA IN  ( SELECT  OWNER, OBJECT_NAME, OBJECT_TYPE
                    FROM    DBA_OBJECTS 
                    WHERE   OWNER = '&USERNAME'
                    AND     OBJECT_TYPE IN ('TABLE', 'SEQUENCE', 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'MATERIALIZED VIEW,  VIEW')
                  )
    LOOP
        IF LINHA.OBJECT_TYPE = 'TABLE' THEN
            V_SQL := 'NOAUDIT SELECT, INSERT, UPDATE, DELETE ON ' || LINHA.OWNER || '.' || LINHA.OBJECT_NAME;
        ELSIF LINHA.OBJECT_TYPE IN ('SEQUENCE','MATERIALIZED VIEW',  'VIEW') THEN
            V_SQL := 'NOAUDIT SELECT ON ' || LINHA.OWNER || '.' || LINHA.OBJECT_NAME;
        ELSE
            V_SQL := 'NOAUDIT EXECUTE ON ' || LINHA.OWNER || '.' || LINHA.OBJECT_NAME;
        END IF;
        
		DBMS_OUTPUT.PUT_LINE(V_SQL || ' - EXECUTADO COM SUCESSO!' );
		
        EXECUTE IMMEDIATE V_SQL;
    END LOOP;
END;