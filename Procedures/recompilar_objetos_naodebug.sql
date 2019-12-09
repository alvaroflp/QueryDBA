SELECT    'ALTER ' || DECODE(type, 'PACKAGE BODY', 'PACKAGE', type) || ' ' || owner || '.' || name || ' compile ' || DECODE(type, 'PACKAGE BODY', 'BODY', '') || ';'
FROM      DBA_PLSQL_OBJECT_SETTINGS
WHERE     PLSQL_DEBUG <> 'FALSE'
ORDER BY  owner, type, name;