DECLARE
    v_UNDO_name VARCHAR2(30);
    v_instance_name VARCHAR2(30);
    v_SQL VARCHAR2(1000);
BEGIN
    -- pesquisa undo tablespace configurado atualmente
    select VALUE INTO v_UNDO_name
    from v$parameter 
    where name = 'undo_tablespace';
    
    -- pesquisa nome da instancia
    select instance_name into v_instance_name from v$instance;
    
    -- cria undo tablespace temporario para possibilitar apagar o atual
    v_SQL:= 'create undo tablespace UNDOTBS2 datafile ''/u01/dados/' || v_instance_name || '/undotbs02.dbf'' size 100m';
    --dbms_output.put_line(v_SQL);
    EXECUTE IMMEDIATE v_SQL;
    
    -- alterar gravacao undo para undo tablespace temporario
    v_SQL:='alter system set undo_tablespace=UNDOTBS2';
    EXECUTE IMMEDIATE v_SQL;
    
    -- apaga undo tablespace atual
    v_SQL:= 'drop tablespace ' || v_UNDO_name || ' including contents AND DATAFILES ';
    EXECUTE IMMEDIATE v_SQL;
    
    -- recria tablespace original
    v_SQL:= 'create undo tablespace ' || v_UNDO_name || ' datafile ''/u01/dados/' || v_instance_name || '/' || v_instance_name || '_undotbs01.dbf'' size 100m AUTOEXTEND ON NEXT 10M';
    EXECUTE IMMEDIATE v_SQL;
    
    -- alterar gravacao undo para undo tablespace original
    v_SQL:= 'alter system set undo_tablespace=' || v_UNDO_name;
    EXECUTE IMMEDIATE v_SQL;
    
    -- apaga undo tablespace temporario
    v_SQL:='drop tablespace UNDOTBS2 including contents AND DATAFILES';
    EXECUTE IMMEDIATE v_SQL;
    
    
--drop tablespace UNDOTBS1 including contents AND DATAFILES 
--alter system set undo_tablespace=UNDOTBS1
--create undo tablespace UNDOTBS1 datafile '/u01/dados/bd1/undotbs01.dbf' size 100m AUTOEXTEND ON NEXT 10M
END;