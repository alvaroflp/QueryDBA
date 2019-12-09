begin
    dbms_mview.EXPLAIN_REWRITE( query => 'SELECT * from srh2.servidor', mv => 'SRH2.MV_SERVIDOR', 
            statement_id => 'EXPLAIN_REWRITE demo');
end;

SELECT  *
FROM    rewrite_table
WHERE  statement_id = 'EXPLAIN_REWRITE demo';