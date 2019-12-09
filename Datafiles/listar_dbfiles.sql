-- listar arquivos do BD
select 'datafile' as type, name, round(bytes/1048576,2) as mbytes, blocks, block_size from v$datafile
union all
select 'tempfile' as type, name, round(bytes/1048576,2) as mbytes, blocks, block_size from v$tempfile
union all
select 'controlfile' as type, name, round((block_size*file_size_blks)/1048576,2) as mbytes, file_size_blks, block_size from v$controlfile
union all
select 'logfile' as type, member, null, null, null from v$logfile;