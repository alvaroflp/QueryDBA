select      TABLE_OWNER,
            TABLE_NAME,
            COLUMN_NAME,
            COUNT(1) QTDE_INDEXES
from        all_ind_columns 
where       TABLE_OWNER not in ('SYS','SYSTEM')
group by    TABLE_OWNER, TABLE_NAME, COLUMN_NAME
HAVING      COUNT(1) > 1
ORDER BY    1, 2

