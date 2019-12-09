select  OWNER,
        TABLE_NAME
from    dba_tables dt
where   not exists (
        select  'TRUE'
        from    dba_constraints dc
        where   dc.TABLE_NAME = dt.TABLE_NAME
        and     dc.CONSTRAINT_TYPE='P')
and 	OWNER not in ('SYS','SYSTEM','WKSYS','XDB','WMSYS','MDSYS','WK_TEST',
                    'OLAPSYS','DBSNMP','DISCADMSP1','D4OSYS','EXFSYS','CTXSYS','DMSYS')
order	by OWNER, TABLE_NAME
