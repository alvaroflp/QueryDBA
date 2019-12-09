-- reabilitar job antigo com estado broken:
EXEC dbms_ijob.broken(&jobnumber,FALSE);