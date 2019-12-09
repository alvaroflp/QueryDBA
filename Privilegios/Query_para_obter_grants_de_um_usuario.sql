
SELECT
  priv.grantee,
  obj.object_name, 
  priv.privilege,
  CASE obj.object_type
      WHEN 'DIRECTORY' THEN 
        'GRANT ' || LOWER(priv.privilege) || ' ON ' || 'DIRECTORY ' || LOWER(obj.owner || '.' || obj.object_name) || 
          ' TO ' || LOWER(priv.grantee) || ';'
      ELSE
        'GRANT ' || LOWER(priv.privilege) || ' ON ' || LOWER(obj.owner || '.' || obj.object_name) || 
          ' TO ' || LOWER(priv.grantee) || DECODE(priv.grantable, 'YES', ' WITH GRANT OPTION')  || DECODE(priv.hierarchy, 'YES', ' WITH HIERARCHY OPTION') || ';'
  END AS Grant_Comand
FROM dba_objects obj
INNER JOIN dba_tab_privs priv ON obj.owner = priv.owner AND obj.object_name = priv.table_name
WHERE obj.owner = '&schema' 
  AND obj.object_type NOT IN ('JAVA CLASS', 'JAVA RESOURCE', 'JAVA SOURCE')
ORDER BY priv.grantee, obj.object_name;


-- Grants em colunas
SELECT  'GRANT ' || LOWER(privilege) || '(' || COLUMN_NAME || ') ON ' || LOWER(OWNER || '.' || table_name) ||
          ' TO ' || LOWER(grantee) || DECODE(grantable, 'YES', ' WITH grant OPTION') || ';' "SQL"
from      Dba_Col_Privs
WHERE     OWNER = '$schema';
