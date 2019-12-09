-- retorna objetos em cache que foram utilizados mais de 1 X por ordem dos mais executados (candidatos a pinagem)
-- 
--
-- * TYPE -> Type of the object: INDEX, TABLE, CLUSTER, VIEW, SET, SYNONYM, SEQUENCE, PROCEDURE, FUNCTION, PACKAGE, PACKAGE BODY, TRIGGER, CLASS, OBJECT, USER, DBLINK 
-- * KEPT -> (YES | NO) Depends on whether this object has been "kept" (permanently pinned in memory) with the PL/SQL procedure DBMS_SHARED_POOL.KEEP 

select      OWNER, 
            NAMESPACE, 
            TYPE,             
            ROUND(SHARABLE_MEM /1024/1024,5) as "SHARABLE_MEM (MB)", 
            LOADS, 
            EXECUTIONS, 
            LOCKS,
            KEPT,
            NAME
from        v$db_object_cache
where       type not in ( 'NOT LOADED','NON-EXISTENT','VIEW','TABLE','SEQUENCE') 
and         executions>0 and loads>1 and kept='NO'
order by    executions desc, owner, namespace, type;