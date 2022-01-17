Select Ent_pro.dt_entrada                                                                       Dt_emprestimo
              ,Fornecedor.nm_fornecedor                                                                 ds_fornecedor
              ,Produto.ds_produto                                                                       produto
              ,Produto.cd_produto                                                                       cProduto
              ,Uni_pro.ds_unidade                                                                       unidade
              ,Itent_pro.qt_entrada                                                                     qt_entrada
              ,Itent_pro.vl_unitario                                                                    vl_unitario
              ,(Nvl(ItEnt_Pro.Qt_Entrada, 0) * Nvl(Vl_Custo_Real, 0))                                   vl_Total
              ,decode(dbamv.pkg_mges_emprestimo.retorna_tp_emprestimo_ent(itent_pro.cd_itent_pro) ,'PEC','Pagto Empréstimo Concedido','Empréstimo Recebido')   tp_emprestimo
              ,decode(dbamv.pkg_mges_emprestimo.retorna_tp_emprestimo_ent(itent_pro.cd_itent_pro) ,'PEC','PEC','ER')             tp_emprestimo_2
              ,Ent_pro.cd_ent_pro
              ,Itent_pro.cd_itent_pro
              ,itmvto_estoque.cd_mvto_estoque

          From Dbamv.Ent_pro                         Ent_pro,
               Dbamv.Itent_pro                       Itent_pro,
               Dbamv.Estoque                         Estoque,
               Dbamv.Tip_doc                         Tip_doc,
               Dbamv.Fornecedor                      Fornecedor,
               Dbamv.Produto                         Produto,
               Dbamv.Uni_pro                         Uni_pro,
               Dbamv.itmvto_ent                      itmvto_ent,
               Dbamv.itmvto_estoque                  itmvto_estoque
         Where Ent_Pro.Cd_Ent_Pro           = ItEnt_Pro.Cd_Ent_Pro
           AND Ent_Pro.Dt_Entrada           Between '01/01/2016' And '18/05/2021'
           AND Ent_Pro.Cd_Estoque           = Estoque.Cd_Estoque
           AND Tip_Doc.Tp_Entrada           = 'E'
           AND Uni_Pro.Cd_Uni_Pro(+)        = ItEnt_Pro.Cd_Uni_Pro
           AND Ent_Pro.Cd_Tip_Doc           = Tip_Doc.Cd_Tip_Doc

           And Ent_pro.cd_fornecedor        = Fornecedor.cd_fornecedor
           And Itent_pro.cd_produto         = Produto.cd_produto
           AND itmvto_ent.cd_itent_pro(+)      = Itent_pro.cd_itent_pro
           AND itmvto_estoque.cd_itmvto_estoque(+) = itmvto_ent.cd_itmvto_estoque
           AND Fornecedor.cd_fornecedor     = 646
          -- AND Produto.cd_produto = 2399


          ORDER BY dt_emprestimo DESC
