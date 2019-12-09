Select sum(pinhits) / sum(pins) "Hit Ratio",
sum(reloads) / sum(pins) "Reload percent"
From v$librarycache
Where namespace in
('SQL AREA', 'TABLE/PROCEDURE', 'BODY', 'TRIGGER');

/*
The hit ratio should be at least 85% (i.e. 0.85). The reload percent should be very low, 2% (i.e. 0.02) or less.
If this is not the case, increase the initialisation parameter SHARED_POOL_SIZE. Although less likely, the init.ora parameter OPEN_CURSORS may also need to increased
*/