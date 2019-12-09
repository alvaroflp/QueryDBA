-- ver lista de jobs 
SELECT      /*+ ALL_ROWS */ LPAD(J.JOB,4,'0') JOB, 
            J.LOG_USER,          
            TO_CHAR(J.LAST_DATE,'dd/mm/yyyy hh:mm') as LAST_DATE,
            TO_CHAR(J.NEXT_DATE,'dd/mm/yyyy hh:mm') as NEXT_DATE, 
            J.INTERVAL, 
            DECODE(J.BROKEN, 'Y', 'YES', 'NO') BROKEN,
            r.sid,
            DECODE(R.JOB, NULL, '  NO', LPAD(R.SID, 4, ' ') ) RUNNING, 
            J.FAILURES,
            J.WHAT,
            J.NLS_ENV
FROM        DBA_JOBS J
LEFT JOIN   DBA_JOBS_RUNNING R
    ON      J.JOB = R.JOB
ORDER BY    j.what;