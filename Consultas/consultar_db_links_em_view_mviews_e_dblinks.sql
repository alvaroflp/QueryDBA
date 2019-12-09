SELECT 'VISÃO' objeto,
        owner DONO,
        view_name NOME_OBJETO,  
CASE 
     WHEN nvl(INSTR(trim(UPPER(TEXTO)),'WHERE'),0) > 0  
     then 
            SUBSTR(trim(UPPER(TEXTO)), 
               NVL(INSTR(UPPER(TEXTO),'@'),0), 
               INSTR(UPPER(TEXTO),'WHERE') - INSTR(UPPER(TEXTO),'@'))
    when    nvl(INSTR(trim(UPPER(TEXTO)),' JOIN '),0) <> 0 and nvl(INSTR(trim(UPPER(TEXTO)),'WHERE'),0) <= 0
    THEN      
            SUBSTR(trim(UPPER(TEXTO)), 
               NVL(INSTR(UPPER(TEXTO),'@'),0), 
               INSTR(UPPER(TEXTO),' JOIN ')- 5 - INSTR(UPPER(TEXTO),'@'))               
    when    nvl(INSTR(trim(UPPER(TEXTO)),' BY '),0) <> 0 and nvl(INSTR(trim(UPPER(TEXTO)),'WHERE'),0) <= 0
    THEN      
         SUBSTR(trim(UPPER(TEXTO)), 
               NVL(INSTR(UPPER(TEXTO),'@'),0), 
               INSTR(UPPER(TEXTO),' BY ') - 5 - INSTR(UPPER(TEXTO),'@'))                
    when    nvl(INSTR(trim(UPPER(TEXTO)),'UNION'),0) <> 0 and nvl(INSTR(trim(UPPER(TEXTO)),'WHERE'),0) <= 0
    THEN      
         SUBSTR(trim(UPPER(TEXTO)), 
               NVL(INSTR(UPPER(TEXTO),'@'),0), 
               INSTR(UPPER(TEXTO),'UNION') - 5 - INSTR(UPPER(TEXTO),'@'))                
    when    nvl(INSTR(trim(UPPER(TEXTO)),')'),0) <> 0 and nvl(INSTR(trim(UPPER(TEXTO)),'WHERE'),0) <= 0
    THEN      SUBSTR(UPPER(TEXTO), 
               nvl(INSTR(trim(UPPER(TEXTO)),'@'),0), 
               INSTR(UPPER(TEXTO),')') - INSTR(UPPER(TEXTO),'@'))
               
  else

        SUBSTR(trim(UPPER(TEXTO)), 
               NVL(INSTR(UPPER(TEXTO),'@'),0), 
               LENGTH(UPPER(TEXTO))+1 - INSTR(UPPER(TEXTO),'@'))

END DB_LINK,  
        trim(TEXTO) Ref_ao_db_link

FROM 
(
select UPPER(trim(RAW_TO_VARCHAR(DBA_VIEWS.owner,DBA_VIEWS.view_name))) texto,text, DBA_VIEWS.owner,DBA_VIEWS.view_name
FROM DBA_VIEWS
--WHERE DBA_VIEWS.OWNER LIKE 'ADM%'
--AND DBA_VIEWS.view_name LIKE 'V%'
--and DBA_VIEWS.owner not like '%SYS%'
WHERE DBA_VIEWS.owner not like '%SYS%'
) X
WHERE UPPER(TEXTO) LIKE '%@%'
AND INSTR(UPPER(TEXTO),'@') > 0

union all

select 
'Materializada',
OWNER,
MVIEW_NAME,
dba_mviews.master_link,
CONTAINER_NAME

from dba_mviews

union all

select 
'db_link',
OWNER                           ,
DB_LINK                         ,
HOST                            ,
USERNAME                        
from dba_db_links


--create view teste as (select a.dummy a, b.dummy b from dual@eleicao.world a,dual@db_rhsp.world b)
