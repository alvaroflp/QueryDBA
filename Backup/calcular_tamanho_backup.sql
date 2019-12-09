-- consulta para calcular tamanho dos backups a partir do tamanho dos datafiles - blocos nao utilizados (o bkp ficara menor ainda do que o valor retornado abaixo pq nao tem como ver os blocos NULL)
select ((select sum(bytes) from v$datafile) - (select sum(bytes) from dba_free_space)) /1024/1024/1024 as tam_gb from dual;

