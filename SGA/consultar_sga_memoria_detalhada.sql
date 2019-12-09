 select             name,
                    mb as mb_total,
                    nvl(inuse,0) as mb_used,
                    round(100 - ((nvl(inuse,0) / mb) * 100),2) "perc_mb_free"                    
            from  (
                  select   name, 
                          round(sum(mb),2) mb, 
                          round(sum(inuse),2) inuse        
                  from (
                          select case when name = 'buffer_cache' then 'buffer cache'
                                       when name = 'log_buffer'   then 'log buffer'
                                      else pool                     
                                  end name,                      
                                  bytes/1024/1024 mb,
                                  case when name = 'buffer_cache'
                                        then (bytes - (select count(*) 
                                                       from v$bh where status='free') *
                                                      (select value 
                                                      from v$parameter 
                                                      where name = 'db_block_size')
                                              )/1024/1024
                                      when name <> 'free memory'
                                            then bytes/1024/1024
                                  end inuse
                          from    v$sgastat
                        )
                WHERE     NAME is not null
                group by  name
            )
            UNION ALL    
            select      'SGA',
                        round(sum(bytes)/1024/1024,2),
                        (round(sum(bytes)/1024/1024,2)) - round(sum(decode(name,'free memory',bytes,0))/1024/1024,2),
                        round((sum(decode(name,'free memory',bytes,0))/sum(bytes))*100,2)                        
            from        v$sgastat;
            
