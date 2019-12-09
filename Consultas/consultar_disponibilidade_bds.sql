-- consultar disponibilidade dos bds (executar no BD do repositorio do EM)
SELECT    Periodo,
          TARGET_NAME,          
          TOT_DIAS_DISP,
          TOT_DIAS_INDISP,          
          ROUND(((TOT_DIAS_DISP-TOT_DIAS_INDISP)/TOT_DIAS_DISP)*100,2) AS "% TEMPO DISPONÍVEL"
FROM      (SELECT     AH.TARGET_NAME,
                      to_char(AH.START_TIMESTAMP,'yyyy/mm') as Periodo,
                      ROUND(SUM(DECODE(AH.AVAILABILITY_STATUS,'Target Up',(AH.END_TIMESTAMP - AH.START_TIMESTAMP),0)),2) TOT_DIAS_DISP, 
                      ROUND(SUM(DECODE(AH.AVAILABILITY_STATUS,'Target Down',(AH.END_TIMESTAMP - AH.START_TIMESTAMP),0)),2) TOT_DIAS_INDISP
            FROM      MGMT$AVAILABILITY_HISTORY AH
            --WHERE     AH.TARGET_NAME IN ('bd1','bd2','bd3')  -- preencher aqui o nome dos BDs desejados e descomentar essa linha
            GROUP BY  AH.TARGET_NAME, TO_CHAR(AH.START_TIMESTAMP,'yyyy/mm'))
WHERE     TOT_DIAS_DISP > 0
ORDER BY  1,2;