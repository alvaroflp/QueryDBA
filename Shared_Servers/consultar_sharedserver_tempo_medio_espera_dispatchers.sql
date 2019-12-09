select    decode(sum(totalq),0,'No responses',
                sum(wait)/sum(totalq)) "Average wait time"
FROM      v$queue q, 
          v$dispatcher d
WHERE     q.type = 'DISPATCHER'
AND       q.paddr = d.paddr;