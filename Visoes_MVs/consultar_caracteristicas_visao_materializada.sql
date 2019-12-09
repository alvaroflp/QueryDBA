-- consultar características de uma visão materializada
BEGIN
    DBMS_MVIEW.EXPLAIN_MVIEW ('SCHEMA.TABLE');
END;

select * from MV_CAPABILITIES_TABLE;
