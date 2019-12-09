BEGIN
    -- atualiza visão materializada
    -- SE METODO = 'C' ENTAO COMPLETE. SE METODO = 'F' ENTAO FAST
    DBMS_MVIEW.REFRESH('&SCHEMA..&MV_NAME','&METODO'); 
END;



