SELECT estoque.cd_estoque cd_estoque,
       estoque.ds_estoque ds_estoque,
       especie.cd_especie cd_especie,
       especie.ds_especie ds_especie,
       classe.cd_classe cd_classe,
       classe.ds_classe ds_classe,
       sub_clas.cd_sub_cla cd_sub_cla,
       sub_clas.ds_sub_cla ds_sub_cla,
       produto.cd_produto cd_produto,
       verif_ds_unid_prod ( produto.cd_produto ) ds_unidade,
       produto.ds_produto ds_produto,
       produto.dt_ultima_entrada dt_ultima_entrada,
       produto.qt_ultima_entrada qt_ultima_entrada,
       To_char (est_pro.dt_ultima_movimentacao, 'dd/mm/yyyy') dt_ultima_movimentacao,
       est_pro.qt_estoque_atual qt_estoque_atual



FROM  estoque,
      est_pro,
      produto,
      sub_clas,
      classe,
      especie


WHERE  estoque.cd_estoque  = est_pro.cd_estoque
AND est_pro.cd_produto  = produto.cd_produto
AND produto.cd_sub_cla  = sub_clas.cd_sub_cla
AND produto.cd_classe     = sub_clas.cd_classe
AND produto.cd_especie  = sub_clas.cd_especie
AND sub_clas.cd_classe   = classe.cd_classe
AND sub_clas.cd_especie = classe.cd_especie
AND classe.cd_especie     = especie.cd_especie
AND produto.sn_mestre = 'N'
AND produto.sn_kit    = 'N'
AND estoque.cd_multi_empresa = 1
AND to_char(est_pro.dt_ultima_movimentacao,'dd/mm/yyyy')BETWEEN '23/12/2021' AND '23/12/2021'

ORDER BY est_pro.dt_ultima_movimentacao
