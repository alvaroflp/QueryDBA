-- esse recurso chama-se FLASHBACK VERSION QUERY e permite ver todas as versoes disponives em UNDO de linhas de uma tabela:

select versions_starttime stime,
       versions_endtime endtime,
       versions_xid xid,
       CASE
          when versions_operation = 'I' then 'INSERT'
          when versions_operation = 'U' then 'UPDATE'
          when versions_operation = 'D' then 'DELETE'
       END AS OPERATION ,
       coluna(s)
from   tabela versions between timestamp minvalue and maxvalue;