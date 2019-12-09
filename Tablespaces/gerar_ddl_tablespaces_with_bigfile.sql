select 'create bigfile tablespace ' || df.tablespace_name || ' datafile ''' || df.file_name || ''' size ' || df.bytes 
 || decode(autoextensible,'N',null, ' autoextend on maxsize ' 
 || MAXBYTES)  
 || ' default storage ( initial ' || initial_extent 
 || decode (next_extent, null, null, ' next ' || next_extent )
 || ' minextents ' || min_extents
 || ' maxextents ' ||  decode(max_extents,'2147483645','unlimited',max_extents) 
 || ') ;'
 from dba_data_files df, dba_tablespaces t
 WHERE DF.TABLESPACE_NAME=T.TABLESPACE_NAME 
 AND    DF.TABLESPACE_NAME NOT IN ('SYSTEM','SYSAUX','UNDOTBS1','USERS');