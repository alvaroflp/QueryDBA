DECLARE
    v_TbsTempName VARCHAR2(30);
    v_TempFileName VARCHAR2(200);
    v_SQL VARCHAR2(1000);
BEGIN
    -- pesquisa nome do temporary tablespace
    SELECT  property_value INTO v_TbsTempName
    FROM    DATABASE_PROPERTIES 
    where   PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';
    
    -- pesquisa nome do datafile temporario
    SELECT  name INTO v_TempFileName
    FROM    V$TEMPFILE;

    -- apaga datafile temporario
    v_SQL:='ALTER DATABASE TEMPFILE ''' || v_TempFileName || ''' DROP INCLUDING DATAFILES';
    EXECUTE IMMEDIATE v_SQL;

    -- recria datafile temporario
    v_SQL:='ALTER TABLESPACE ' || v_TbsTempName || ' ADD TEMPFILE ''' || v_TempFileName|| ''' SIZE 10M AUTOEXTEND ON NEXT 10M';
    dbms_output.put_line(v_SQL);
    EXECUTE IMMEDIATE v_SQL;
END;