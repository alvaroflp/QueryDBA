BACKUP INCREMENTAL LEVEL 0 section size 500M 
  FORMAT '/home/oracle/Desktop/Backup/backup_%d_set%s_piece%p_%T_%U.bkp' DATABASE ;
  
  
BACKUP INCREMENTAL LEVEL 1 database;

BACKUP INCREMENTAL LEVEL 1 CUMULATIVE DATABASE;
