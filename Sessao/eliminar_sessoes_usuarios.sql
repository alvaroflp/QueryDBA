SET SERVEROUTPUT ON
BEGIN
    -- elimina sessões de todos os usuários conectados em um Bd, exceto as contas SYS, SYSTEM, DBSNMP, CTXSYS e 
    --      processos do Oracle (USERNAME IS NULL)
    -- * ACRESCENTAR NA CLÁUSULA NOT IN demais usuários que as sessões não podem ser eliminadas
    DBMS_OUTPUT.ENABLE(NULL);
    FOR CUR_TAB IN (SELECT  SID, 
                            USERNAME,
                            'ALTER system DISCONNECT SESSION '''||sid||', '||serial#||''' IMMEDIATE' as cmd
                    FROM    v$session 
                    WHERE   USERNAME NOT IN ('SYS','SYSTEM','DBSNMP','CTXSYS')
                    AND     USERNAME IS NOT NULL) LOOP
        EXECUTE IMMEDIATE CUR_TAB.CMD;
        dbms_output.put_line('Sessão ' || CUR_TAB.SID || ' do usuário ' ||  CUR_TAB.USERNAME || ' eliminada!');
    END LOOP;
END;

