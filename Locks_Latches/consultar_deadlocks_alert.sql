-- consultar deadlocks no alert xml (11g em diante) por mes:
SELECT      TO_CHAR(ORIGINATING_TIMESTAMP,'yyyy/mm') DATA, 
            count(1)
FROM        X$DBGALERTEXT 
WHERE       MESSAGE_TEXT LIKE '%Deadlock%'
GROUP BY    TO_CHAR(ORIGINATING_TIMESTAMP,'yyyy/mm')
ORDER BY    1 DESC;