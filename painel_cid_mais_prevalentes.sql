--------------CID's mais prevalentes 5+ -------------

SELECT ranking , DS_CID, QTDE,   Round( (QTDE/total_geral)*100,2)||'%' perc
 FROM (
SELECT ranking , DS_CID, QTDE, total_geral
  FROM (
SELECT 1 ORD, cid.cd_cid ||' - '||ds_cid ds_cid,
       Count(*) qtde,
       Dense_Rank() OVER(ORDER BY Count(*) desc) ranking,
       (SELECT Count(*) QTDE
          FROM DBAMV.ATENDIME, LEITO, UNID_INT, SETOR,
              DBAMV.CID
        WHERE ATENDIME.CD_CID = CID.CD_CID
        AND Trunc (atendime.dt_atendimento) BETWEEN  $pgmvDataIni$  AND  $pgmvDataFim$
        AND ATENDIME.CD_MULTI_EMPRESA  IN (1)
        AND atendime.tp_atendimento = 'I'
        AND ATENDIME.CD_LEITO = LEITO.CD_LEITO (+)
        AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT
        AND SETOR.CD_SETOR = UNID_INT.CD_SETOR (+)
        AND SETOR.CD_SETOR IN ()
        ) total_geral
  FROM DBAMV.ATENDIME,LEITO, UNID_INT, SETOR,
       DBAMV.CID
 WHERE ATENDIME.CD_CID = CID.CD_CID
 AND Trunc (atendime.dt_atendimento) BETWEEN  $pgmvDataIni$  AND  $pgmvDataFim$
 AND ATENDIME.CD_MULTI_EMPRESA  IN (1)
 AND atendime.tp_atendimento = 'I'
 AND ATENDIME.CD_LEITO = LEITO.CD_LEITO (+)
 AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT
 AND SETOR.CD_SETOR = UNID_INT.CD_SETOR (+)
  AND SETOR.CD_SETOR IN ()

GROUP BY cid.cd_cid ||' - '||ds_cid
         ) WHERE ranking <= 5

UNION ALL

SELECT 11 ranking,
       'Outros' DS_CID,
       Sum(QTDE) qtde,
       (SELECT Count(*) QTDE
          FROM DBAMV.ATENDIME, LEITO, UNID_INT, SETOR,
              DBAMV.CID
        WHERE ATENDIME.CD_CID = CID.CD_CID
        AND Trunc (atendime.dt_atendimento) BETWEEN  $pgmvDataIni$  AND  $pgmvDataFim$
        AND ATENDIME.CD_MULTI_EMPRESA  IN (1)
        AND atendime.tp_atendimento = 'I'
        AND ATENDIME.CD_LEITO = LEITO.CD_LEITO (+)
        AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT
        AND SETOR.CD_SETOR = UNID_INT.CD_SETOR (+)
         AND SETOR.CD_SETOR IN ()
        ) total_geral
  FROM (
SELECT 6 ORD, cid.cd_cid ||' - '||ds_cid ds_cid,
       Count(*) qtde,
       Dense_Rank() OVER(ORDER BY Count(*)
 desc) ranking
  FROM DBAMV.ATENDIME, LEITO, UNID_INT, SETOR,
       DBAMV.CID
 WHERE ATENDIME.CD_CID = CID.CD_CID
 AND Trunc (atendime.dt_atendimento) BETWEEN  $pgmvDataIni$  AND  $pgmvDataFim$
 AND ATENDIME.CD_MULTI_EMPRESA  IN (1)
 AND atendime.tp_atendimento = 'I'
 AND ATENDIME.CD_LEITO = LEITO.CD_LEITO (+)
 AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT
 AND SETOR.CD_SETOR = UNID_INT.CD_SETOR (+)
 AND SETOR.CD_SETOR IN ()

GROUP BY cid.cd_cid ||' - '||ds_cid
             ) WHERE ranking > 5 GROUP BY ord

ORDER BY ranking
)