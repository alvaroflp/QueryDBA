/*
Permite gerar um conjunto de comandos para atribuir todos os privilegios possíveis em todos os objetos de um determinado schema.
Possui os parametros OWNER e USER_NAME. Se desejar apenas recuperar todos os privilegios possiveis dos objetos de um schema forneca o mesmo valor para os 2 parametros. Se alem de recuperar for desejado atribuir os privilegios para outro usuario, forneça o nome do usuario correspondente para o parametro USER_NAME.
*/                        
undefine OWNER;
undefine USER_NAME;
DEFINE OWNER='&_OWNER'
DEFINE USER_NAME='&_USERNAME'

select  'GRANT SELECT, INSERT, UPDATE, DELETE ON ' || owner || '.' || object_name || ' TO &&USER_NAME;'
from    dba_objects o
where   owner = UPPER('&&owner')
and     object_type = 'TABLE'
and     (owner, object_name) not in (select owner, mview_name from dba_mviews m where m.owner = o.owner)
union all
select  'GRANT SELECT ON ' || owner || '.' || object_name || ' TO &&USER_NAME;'
from    dba_objects
where   owner = UPPER('&&owner')
and     object_type IN ('VIEW','MATERIALIZED VIEW')
UNION ALL
select  'GRANT SELECT ON ' || owner || '.' || object_name || ' TO &&USER_NAME;'
from    dba_objects
where   owner = UPPER('&&owner')
and     object_type = 'SEQUENCE'
union all
select  'GRANT EXECUTE ON ' || owner || '.' || object_name || ' TO &&USER_NAME;'
from    dba_objects
where   owner = UPPER('&&owner')
and     object_type in ('PROCEDURE','PACKAGE')