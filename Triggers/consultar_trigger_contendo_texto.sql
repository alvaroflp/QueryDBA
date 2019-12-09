-- drop table STBD.TMP_TRIGGERS;

-- cria tabela temporaria p/ armazenar lista de triggers e possibilitar pesquisa posterior em campo CLOB, pois no original LONG não é possível usar like
CREATE TABLE STBD.TMP_TRIGGERS (OWNER VARCHAR2(30), VIEW_NAME VARCHAR2(30), TEXT CLOB) NOLOGGING;

-- popula tabela temp c/ registros das views existentes
BEGIN
    FOR LINHA IN (SELECT OWNER, trigger_name, trigger_body FROM DBA_triggers WHERE OWNER NOT LIKE '%SYS%')
    LOOP
        INSERT INTO STBD.TMP_TRIGGERS VALUES (LINHA.OWNER, LINHA.TRIGGER_NAME, LINHA.TRIGGER_BODY);
    END LOOP;
    COMMIT;
END;

-- pesquisar triggers que contem referencias a uma determinada string
SELECT * FROM STBD.TMP_VIEWS_MIGRACAO WHERE UPPER(TEXT) LIKE upper('%&STRING_PESQUISA%');
