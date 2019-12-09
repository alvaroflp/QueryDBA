-- ver se i/o assincrono esta habilitado nos datafiles:
SELECT  name, asynch_io 
FROM    v$datafile f,v$iostat_file i
WHERE   f.file#        = i.file_no
AND     filetype_name  = 'Data File';