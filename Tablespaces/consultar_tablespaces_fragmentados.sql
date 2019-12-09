SELECT   dfsc.tablespace_name tablespace_name,
         DECODE (
            dfsc.percent_extents_coalesced,
            100,
            (DECODE (
                GREATEST ((SELECT COUNT (1)
                             FROM dba_free_space dfs
                            WHERE dfs.tablespace_name = dfsc.tablespace_name), 1),
                1,
                'No Frag',
                'Bubble Frag'
             )
            ),
            'Possible Honey Comb Frag'
         )
               fragmentation_status
    FROM dba_free_space_coalesced dfsc
ORDER BY 2,1