-- *** TESTES em lab

CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1,38 CHANNEL c1)
        (DATAFILE 2,39 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 1min38s
    
    
-- sem paralelismo    
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1,38 CHANNEL c1)
        (DATAFILE 2,39 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }
-- tempo: 1min35s    

CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';    
    BACKUP INCREMENTAL LEVEL = 0 datafile 1, 2, 38, 39;        
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }
-- tempo: 11:30s
    
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1,38 CHANNEL c1)
        (DATAFILE 2,39 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 10:36

CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1,38 CHANNEL c1)
        (DATAFILE 2,39 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 07:48

CONFIGURE DEVICE TYPE DISK PARALLELISM 3 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';
    ALLOCATE CHANNEL c3 DEVICE TYPE disk format '/tmp/bkp/cf_bkp3_%U';
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1 CHANNEL c1)
        (DATAFILE 2 CHANNEL c2)
        (DATAFILE 38,39 CHANNEL c3);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }
-- tempo:  09:58

CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0 section size = 400M datafile 1, 2, 38, 39;
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    } -- deste modo ocorre backup em paralelo 
-- tempo: 03:14 min 
  
  CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1,38 CHANNEL c1)
        (DATAFILE 2,39 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 01:28 min.

CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    ALLOCATE CHANNEL c3 DEVICE TYPE disk format '/tmp/bkp/cf_bkp3_%U';
    BACKUP INCREMENTAL LEVEL = 0 section size = 1G datafile 1, 2, 38, 39;        
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 01:37 min.

CONFIGURE DEVICE TYPE DISK PARALLELISM 3 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/cf_bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/cf_bkp2_%U';    
    ALLOCATE CHANNEL c3 DEVICE TYPE disk format '/tmp/bkp/cf_bkp3_%U';
    BACKUP INCREMENTAL LEVEL = 0 section size = 1G datafile 1, 2, 38, 39;        
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 02:33 min.


TAMANHO DO BACKUP: 3g



--- TESTES NA SP1 (/orabkp é storage e /tmp é disco local)
CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/tmp/bkp/bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1 CHANNEL c1)
        (DATAFILE 2 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: c1 = 7s e c2 = 25s
-- tempo: c1 = 15s e c2 = 25s
    
CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/bkp_%U';
    ALLOCATE CHANNEL c2 DEVICE TYPE disk format '/orabkp/testes/bkp2_%U';    
    BACKUP INCREMENTAL LEVEL = 0
        (DATAFILE 1 CHANNEL c1)
        (DATAFILE 2 CHANNEL c2);
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: c1 = 7s e c2 = 35s
-- tempo: c1 = 7s e c2 = 35s

CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/tmp/bkp/bkp_%U';    
    BACKUP INCREMENTAL LEVEL = 0 datafile 1, 2;
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 35s

CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET;
    RUN {
    ALLOCATE CHANNEL c1 DEVICE TYPE disk format '/orabkp/testes/bkp_%U';    
    BACKUP INCREMENTAL LEVEL = 0 datafile 1, 2;
    SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
    }  
-- tempo: 55s