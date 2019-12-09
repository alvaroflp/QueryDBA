SELECT      A.TABLESPACE_NAME,
            A.TABLE_NAME,
            COUNT( B.COLUMN_ID ) tot_columns,
            SUM( DECODE( B.DATA_TYPE, 'NUMBER', B.DATA_PRECISION, B.DATA_LENGTH ) ) tam_dados,
            MAX( A.NUM_ROWS ) max_num_rows,
            MAX( A.AVG_ROW_LEN ) max_avg_row_len,
            MAX( A.BLOCKS ) max_blocks,
            MAX( A.EMPTY_BLOCKS ) max_empty_blocks,
            MAX( A.AVG_SPACE ) max_avg_space       
FROM        DBA_TABLES A
INNER JOIN  DBA_TAB_COLUMNS B
    ON      A.OWNER = B.OWNER
WHERE       A.TABLESPACE_NAME NOT IN ('SYSTEM','SYSAUX')
AND         A.TABLE_NAME = B.TABLE_NAME
GROUP BY    A.TABLESPACE_NAME, A.TABLE_NAME
ORDER BY    A.TABLESPACE_NAME, A.TABLE_NAME;