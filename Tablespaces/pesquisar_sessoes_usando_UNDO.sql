SELECT    S.USERNAME,
          s.sid,
          s.serial#,
          t.used_ublk, 
          t.used_urec,
          rs.segment_name,
          r.rssize,
          R.STATUS
FROM      v$transaction t,
          v$session s,
          v$rollstat r,
          dba_rollback_segs rs
WHERE     S.SADDR = T.SES_ADDR
AND       T.XIDUSN = R.USN
AND       rs.segment_id = t.xidusn
ORDER BY t.used_ublk DESC;