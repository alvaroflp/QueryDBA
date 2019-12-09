BACKUP AS BACKUPSET
  FORMAT '/home/oracle/Desktop/Backup/backup_%d_set%s_piece%p_%T_%U.bkp'
    TABLESPACE USERS;