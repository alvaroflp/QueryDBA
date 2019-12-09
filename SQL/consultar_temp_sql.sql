select      u.username, 
            s.sql_fulltext, 
            u.segtype, 
            u.extents, 
            u.blocks
FROM        V$TEMPSEG_USAGE U
INNER JOIN  V$SQL S
    ON      s.sql_id = u.sql_id;