-- ver qtde de indices por tabela:
select      OWNER,
            TABLE_NAME,
            COUNT(1) index_count
from        dba_indexes 
where       OWNER not in ('SYS','SYSTEM')
group by    OWNER, TABLE_NAME 
order by    COUNT(1) desc, OWNER, TABLE_NAME
