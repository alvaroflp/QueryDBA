-- restaurar estatisticas de objeto de um determinado schema, como elas eram em uma determinada data
BEGIN
    DBMS_STATS.RESTORE_SCHEMA_STATS( 
      ownname                => '&SCHEMA_NAME', 
      as_of_timestamp        => TO_TIMESTAMP('&DD/MM/YYYY','dd/mm/yyyy'), 
      force                  => true);
END;