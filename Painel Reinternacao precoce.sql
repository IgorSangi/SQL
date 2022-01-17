 ---DADOS FORMULARIO ---
 SELECT EC.*
 FROM pw_documento_clinico pdc
 ,pw_editor_clinico pec
 ,Editor_Registro_Campo erc
 ,editor_campo ec
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
-- AND pdc.tp_status <> 'CANCELADO'
-- AND ec.cd_metadado = 416908
 AND PDC.cd_atendimento = 18101456
-- AND ec.ds_identificador = '1054_AUDITORIA_REINTERNACAO_SIM_1'
 AND ec.cd_metadado = 417552
--  AND erc.cd_campo = 418686


-----------------------------------------------------------------------------------------------------

 ---TOTAL AUDITADO ---
 SELECT * --Count(*) TOTAL
 FROM pw_documento_clinico pdc, atendime a
 WHERE a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND Trunc (dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'




------------------------------------------------------------------------------------------------------

  --- TOTAL PROGRAMADO E NÃO PROGRAMADA -----
 SELECT
    CASE WHEN To_Char(lo_valor) = 'true' THEN 'PROGRAMADA'
         WHEN To_Char(lo_valor) = 'false' THEN 'NÃO PROGRAMADA'
         END  TIPO
      ,Count(*) TOTAL
 FROM pw_documento_clinico pdc
 ,pw_editor_clinico pec
 ,Editor_Registro_Campo erc
 ,editor_campo ec
 ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND ec.ds_identificador = '1054_AUDITORIA_REINTERNACAO_SIM_1'
 AND ec.cd_metadado = 417529
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'

 GROUP BY To_Char(lo_valor)



-----------------------------------------------------------------------------------
    --- NÃO PROGRAMADA COM DQ E SEM DQ -----

 SELECT
       'NÃO PROGRAMADA SEM DQ' TIPO
      ,Count(*) TOTAL
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND ec.ds_identificador = '1054_AUDITORIA_REINTERNACAO_IMPRESSAO_2'
 AND To_Char(lo_valor) = 'true'
 AND ec.cd_metadado = 417531
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'   BETWEEN #DT_INICIAL# AND #DT_FINAL#
 GROUP BY To_Char(lo_valor)

UNION ALL

 SELECT
       'NÃO PROGRAMADA COM DQ' TIPO
      ,Count(*) TOTAL
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND ec.ds_identificador = '1054_AUDITORIA_REINTERNACAO_IMPRESSAO_3'
 AND To_Char(lo_valor) = 'true'
 AND ec.cd_metadado = 417531
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'
 GROUP BY To_Char(lo_valor)



------------------------------------------------------------------------------------------------

    --- Aparentes ou possíveis desvios de qualidade -----

 SELECT
       To_Char(lo_valor) TIPO
      ,Count(*) TOTAL
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND To_Char(lo_valor) IS NOT NULL
 AND ec.cd_metadado = 416771
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'  -- BETWEEN #DT_INICIAL# AND #DT_FINAL#
 GROUP BY To_Char(lo_valor)


 ------------------------------------------------------------------------------------
     --- Aparentes ou possíveis ocorrências - incidentes - eventos -----

 SELECT
       To_Char(lo_valor) TIPO
      ,Count(*) TOTAL
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND To_Char(lo_valor) IS NOT NULL
 AND ec.cd_metadado = 416775
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'  -- BETWEEN #DT_INICIAL# AND #DT_FINAL#
 GROUP BY To_Char(lo_valor)


-------------------------------------------------------------------------------------------

 ---------------- FEEDBACK ----------------------------------------

 SELECT CRM
      ,TIPO
      ,Count(DQ.TIPO) TOTAL

 FROM

      --- FEEDBACK CRM -----

 (SELECT
       To_Char(lo_valor) CRM
      ,PDC.cd_documento_clinico
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND To_Char(lo_valor) IS NOT NULL
 AND ec.cd_metadado = 417552
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'  -- BETWEEN #DT_INICIAL# AND #DT_FINAL#
 ) CRM

 ,(
  --- Aparentes ou possíveis desvios de qualidade -----

 SELECT
       'DESVIOS' TIPO
      ,PDC.cd_documento_clinico
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND To_Char(lo_valor) IS NOT NULL
 AND ec.cd_metadado = 416771
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'  -- BETWEEN #DT_INICIAL# AND #DT_FINAL#

 UNION ALL

      --- Aparentes ou possíveis ocorrências - incidentes - eventos -----

 SELECT
       'OCORRENCIA' TIPO
      ,PDC.cd_documento_clinico
 FROM pw_documento_clinico pdc
      ,pw_editor_clinico pec
      ,Editor_Registro_Campo erc
      ,editor_campo ec
      ,ATENDIME a
 WHERE pdc.cd_documento_clinico = pec.cd_documento_clinico
 AND pec.cd_editor_registro = erc.cd_registro
 AND erc.cd_campo = ec.cd_campo
 AND a.cd_atendimento = pdc.cd_atendimento
 AND pdc.nm_documento = 'AUDITORIA DA REINTERNAÇÃO PRECOCE'
 AND pdc.tp_status <> 'CANCELADO'
 AND To_Char(lo_valor) IS NOT NULL
 AND ec.cd_metadado = 416775
 AND Trunc (a.dt_atendimento) BETWEEN '01/01/2021' AND '31/12/2021'  -- BETWEEN #DT_INICIAL# AND #DT_FINAL#

 )DQ

 WHERE CRM.cd_documento_clinico = DQ.cd_documento_clinico
 GROUP BY CRM , TIPO


