-- top REDO gerado pelas sessoes abertas
SELECT    S.SID, S.SERIAL#, S.USERNAME, S.PROGRAM,
          i.block_changes
FROM      v$session s, v$sess_io i
WHERE     S.SID = I.SID
ORDER BY  5 desc, 1, 2, 3, 4;