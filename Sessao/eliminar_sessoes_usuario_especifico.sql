SET SERVEROUTPUT ON
BEGIN
    -- elimina sessões de um determinado usuário conectado no Bd
    DBMS_OUTPUT.ENABLE(NULL);
    FOR CUR_TAB IN (SELECT  SID, 
                            USERNAME,
                            'ALTER system DISCONNECT SESSION '''||sid||', '||serial#||''' IMMEDIATE' as cmd
                    FROM    V$SESSION 
                    WHERE   USERNAME = UPPER('&USER')
                    AND     USERNAME IS NOT NULL) LOOP
        BEGIN
          EXECUTE IMMEDIATE CUR_TAB.CMD;
          dbms_output.put_line('Sessão ' || CUR_TAB.SID || ' do usuário ' ||  CUR_TAB.USERNAME || ' eliminada!');
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao eliminar sessão ' || CUR_TAB.SID || '. ' || SQLERRM);
        END;
    END LOOP;
END;
