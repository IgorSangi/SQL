 SELECT MOD(ROWNUM , 2 ) linha
 , estoque
 ,cd_solsai_pro
 ,hr_solicit
 ,dt_solsai_pro
 ,nm_paciente
 ,cd_atendimento
 ,ds_leito
 ,produtos_prescritos
 , hr_med
 ,ds_unid_int



 FROM (



SELECT SOLSAI_PRO.cd_solsai_pro
 , estoque.ds_estoque estoque
 , to_char ( hr_solsai_pro , 'hh24:mi' ) hr_solicit
 , to_char ( dt_solsai_pro, 'dd/mm/yyyy' ) dt_solsai_pro
 ,PACIENTE.nm_paciente
 ,PACIENTE.cd_paciente
 ,ATENDIME.cd_atendimento
 , ATENDIME.cd_leito
 , LEITO.ds_leito
 , unid_int.ds_unid_int
 , CASE WHEN QTD_ATENDIDA = 0 THEN 1
 WHEN QTD_ATENDIDA < QTD_SOLICITADA THEN 2
 END ORD



 , f_retorna_prod_itsolsaipro_hu ( cd_solsai_pro , 'PRODUTO_PRESCRITO' ) produtos_prescritos
 , hr_med


 FROM SOLSAI_PRO
 ,ATENDIME
 , PACIENTE
 , ESTOQUE
 , LEITO
 , unid_int

 , ( SELECT
 ITSOLSAI_PRO.CD_SOLSAI_PRO CD_SOLSAI_PRO_qtd
 , Sum ( Decode ( ITSOLSAI_PRO.CD_ITSOLSAI_PRO, NULL , 0 , 1 )) QTD_SOLICITADA
 , Sum ( Decode ( ITMVTO_ESTOQUE.CD_ITSOLSAI_PRO , NULL , 0 , 1 )) QTD_ATENDIDA

 FROM ITSOLSAI_PRO , ITMVTO_ESTOQUE
 WHERE ITMVTO_ESTOQUE.cd_itsolsai_pro (+) = itsolsai_pro.cd_itsolsai_pro
 -- AND ITSOLSAI_PRO.CD_SOLSAI_PRO = 119646
 GROUP BY ITSOLSAI_PRO.CD_SOLSAI_PRO
 )
 COMPARA_QTD



 , (

select cd_pre_med
 , replace ( to_char ( wm_concat ( hr_med ) ) , ',' , '</p></p> ' ) hr_med

from (


SELECT cd_pre_med
 , '<font color="043a18">' || ds_produto || ' </font>' || '</p></p> '|| '<font color="ff000c">'||REPLACE ( To_Char ( wm_concat ( diahrmed )) , ',' , '</p></p> ')||'</font ></p></p> ' ||'</p></p> ' ||'-------' hr_med
 FROM (

 SELECT DISTINCT
 cd_pre_med
 , ds_produto
 , felipe_retorna_hritpremed_sw( hritpre_med.cd_itpre_med , dh_medicacao ) diahrmed

 FROM hritpre_med
 , itpre_med
 , produto

 WHERE itpre_med.cd_produto = produto.cd_produto
 --AND hritpre_med.cd_itpre_med = 781
 AND hritpre_med.cd_itpre_med = itpre_med.cd_itpre_med
 AND itpre_med.cd_produto IN (2723,3663,2724,2725,2903,3861,2730,3263,2732,2733,3266,3268,3864,2900,3276,3279,2736,2735,2738,2739,2740,2763,2741,3288,2906,
 2742,2743,4136,2744,2884,3296,2745,2926,2927,2759,2713,3312,2746,2747,2756,2754,4236,2753,2752,3851,9170,3854,3208,12013)
 AND Nvl(sn_cancelado, 'N') = 'N'
 )
 GROUP BY
 cd_pre_med
 , ds_produto
order by ds_produto
)
 group by cd_pre_med
 )produtoss


 WHERE ATENDIME.cd_atendimento = SOLSAI_PRO.cd_atendimento
 AND ATENDIME.cd_paciente = PACIENTE.cd_paciente
and produtoss.cd_pre_med = solsai_pro.cd_pre_med
AND solsai_pro.cd_estoque = ESTOQUE.cd_estoque
AND COMPARA_QTD.cd_solsai_pro_qtd = solsai_pro.cd_solsai_pro
AND LEITO.cd_leito (+) = ATENDIME.cd_leito
AND atendime.cd_multi_empresa = 1
AND LEITO.cd_unid_int = unid_int.cd_unid_int


and QTD_SOLICITADA <> QTD_ATENDIDA
-- AND SOLSAI_PRO.CD_ESTOQUE IN ( 1 , 18 )
 --AND SOLSAI_PRO.cd_atendimento = 129764
 --AND SOLSAI_PRO.cd_pre_med = 435334
and trunc( dt_solsai_pro) =  Trunc (sysdate)



 ORDER BY ORD, HR_SOLSAI_PRO DESC


) WHERE ( estoque in ('TODOS','FARMACIA PRONTO ATENDIMENTO','FARMACOTECNICA','FARMACIA UTI ADULTO','FARMACIA 5 PAV','FARMACIA - UC','FARMACIA CENTRAL','FARMACIA CENTRO CIRURGICO') )
AND (dt_solsai_pro BETWEEN '01/10/2021' and '30/11/2021')
AND (ds_unid_int in ('SALA VERMELHA','ISOLAMENTO','PRONTO ATENDIMENTO -  PA','6° PAVIMENTO','UTI ADULTO 01','8º PAVIMENTO (VIRTUAL)','UTI ADULTO 02','7º PAVIMENTO','UNIDADE HEMODINÂMICA','UNID TEMPORARIA ADULTO','MATERNIDADE E PEDIATRIA','PRONTO ATENDIMENTO ADULTO','SALA DE OBSERVACAO  - HI','UNID TEMPORARIA PEDIATRICA','HOSPITAL DIA','PRONTO ATENDIMENTO INFANTIL','POSTO DE INTERNACAO - HI') )