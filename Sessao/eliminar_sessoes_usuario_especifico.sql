SET SERVEROUTPUT ON
BEGIN
    -- elimina sess�es de um determinado usu�rio conectado no Bd
    DBMS_OUTPUT.ENABLE(NULL);
    FOR CUR_TAB IN (SELECT  SID, 
                            USERNAME,
                            'ALTER system DISCONNECT SESSION '''||sid||', '||serial#||''' IMMEDIATE' as cmd
                    FROM    V$SESSION 
                    WHERE   USERNAME = UPPER('&USER')
                    AND     USERNAME IS NOT NULL) LOOP
        BEGIN
          EXECUTE IMMEDIATE CUR_TAB.CMD;
          dbms_output.put_line('Sess�o ' || CUR_TAB.SID || ' do usu�rio ' ||  CUR_TAB.USERNAME || ' eliminada!');
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao eliminar sess�o ' || CUR_TAB.SID || '. ' || SQLERRM);
        END;
    END LOOP;
END;
