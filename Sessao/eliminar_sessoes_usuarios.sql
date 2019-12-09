SET SERVEROUTPUT ON
BEGIN
    -- elimina sess�es de todos os usu�rios conectados em um Bd, exceto as contas SYS, SYSTEM, DBSNMP, CTXSYS e 
    --      processos do Oracle (USERNAME IS NULL)
    -- * ACRESCENTAR NA CL�USULA NOT IN demais usu�rios que as sess�es n�o podem ser eliminadas
    DBMS_OUTPUT.ENABLE(NULL);
    FOR CUR_TAB IN (SELECT  SID, 
                            USERNAME,
                            'ALTER system DISCONNECT SESSION '''||sid||', '||serial#||''' IMMEDIATE' as cmd
                    FROM    v$session 
                    WHERE   USERNAME NOT IN ('SYS','SYSTEM','DBSNMP','CTXSYS')
                    AND     USERNAME IS NOT NULL) LOOP
        EXECUTE IMMEDIATE CUR_TAB.CMD;
        dbms_output.put_line('Sess�o ' || CUR_TAB.SID || ' do usu�rio ' ||  CUR_TAB.USERNAME || ' eliminada!');
    END LOOP;
END;

