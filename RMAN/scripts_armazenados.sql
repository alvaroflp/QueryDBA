-- criar script armazenado no repositorio a partir de um arquivo texto (nao conseguir gerar script diretamente, sem arquivo texto)
create global script backup_delete_archivelogs comment 'Script p/ gerar backup dos archives e deletar archives backupeados em seguida'
FROM FILE '/tmp/teste.txt';

-- conteudo do arquivo '/tmp/teste.txt':
run
{
     backup archivelog all delete input format '/rman/&1/logs/bkplog_%d_%s_%p' tag='bkp_log_&1';
}

-- dentro do RMAN, execute o comando abaixo para executar o script criado anteriormente
run { execute script backup_delete_archivelogs using 'bd1';}

run { execute script backup_delete_archivelogs using 'bd1';}

-- para executar o script diretamente do prompt de comandos do SO, execute o comando abaixo:
rman target sys/xxxxx@bd1 catalog /@rman script backup_delete_archivelogs using 'bd1'

-- ver lista de scripts armazenados
select * from rc_stored_scripts;

-- ver lista de scripts armazenados
select * from RMAN.rc_stored_script_line;

-- apagar script armazenado
delete script backup_delete_archivelogs;


-- chamar script shell
rman target user/senha cmdfile run cmdfilename.cmd

-- ver conteudo de scripts armazenados
print script script_name;


