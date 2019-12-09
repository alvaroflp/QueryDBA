define OWNER = 'SCHEMA'
DEFINE TABLE_NAME = 'TABELA'

SELECT dbms_metadata.get_ddl('TABLE', object_name, owner)
    FROM all_objects
    WHERE owner = UPPER('&&owner')
      AND object_name = UPPER('&&table_name')
      AND object_type = 'TABLE'
UNION ALL
SELECT dbms_metadata.get_dependent_ddl('COMMENT', table_name, owner)
    FROM (SELECT table_name, owner
              FROM all_col_comments
              WHERE owner = UPPER('&&owner')
                AND table_name = UPPER('&&table_name')
                AND comments IS NOT NULL
          UNION 
          SELECT table_name, owner
              FROM sys.all_tab_comments
              WHERE owner = UPPER('&&owner')
                AND table_name = UPPER('&&table_name')
                AND comments IS NOT NULL)
UNION ALL
SELECT dbms_metadata.get_dependent_ddl('INDEX', table_name, table_owner)
    FROM (SELECT table_name, table_owner
              FROM all_indexes
              WHERE table_owner = UPPER('&&owner')
                AND table_name = UPPER('&&table_name')
                AND NOT index_name IN (SELECT constraint_name
                         FROM sys.all_constraints
                         WHERE table_name = table_name
                           AND constraint_type = 'P')
                AND rownum = 1)
UNION ALL
SELECT dbms_metadata.get_ddl('TRIGGER', trigger_name, owner)
    FROM all_triggers
    WHERE table_owner = UPPER('&&owner')
      AND table_name = UPPER('&&table_name');