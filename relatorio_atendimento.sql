SELECT atendime.cd_atendimento,
paciente.nm_paciente,
prestador.nm_prestador,
especialid.ds_especialid,
To_Char (dt_atendimento, 'dd/mm/yyyy') dt_atendimento

FROM atendime, paciente, prestador, especialid, ori_ate

WHERE atendime.tp_atendimento = 'U'
AND atendime.cd_prestador = prestador.cd_prestador
AND atendime.cd_paciente = paciente.cd_paciente
AND atendime.cd_ori_ate = ori_ate.cd_ori_ate
AND atendime.cd_especialid = especialid.cd_especialid
AND especialid.cd_especialid IN (11,33,73)
AND atendime.dt_atendimento BETWEEN To_Date('01/09/2021', 'dd/mm/yyyy') AND To_Date('30/11/2021', 'dd/mm/yyyy')

ORDER BY atendime.dt_atendimento



