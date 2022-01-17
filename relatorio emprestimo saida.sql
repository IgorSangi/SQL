 Select Dt_emprestimo
              ,cd_saida
             --,Ds_fornecedor
             --,Produto
              ,cProduto
              ,Unidade
              ,Qt_entrada
            --,vl_unitario
            --,vl_total
              ,decode(dbamv.pkg_mges_emprestimo.retorna_tp_emprestimo_sai(cd_itmvto_estoque),'PER','Pagto de Empréstimo Recebido','Empréstimo Concedido')  tp_emprestimo
              ,decode(dbamv.pkg_mges_emprestimo.retorna_tp_emprestimo_sai(cd_itmvto_estoque),'PER','PER','EC')  tp_emprestimo_2
              ,cd_ent_pro


          From (SELECT mvto_estoque.dt_mvto_estoque                                         dt_emprestimo
                      ,fornecedor.nm_fornecedor                                             Ds_fornecedor
                      ,Produto.ds_produto                                                   Produto
                      ,Produto.cd_produto                                                   cProduto
                      ,Uni_pro.ds_unidade                                                   Unidade
                      ,ItMvto_Estoque.Qt_Movimentacao                                       Qt_entrada
                      ,mvto_estoque.hr_mvto_estoque                                         hr_mvto_estoque
                      ,itmvto_estoque.cd_produto                                            cd_produto
                      ,(uni_pro.Vl_Fator * Verif_Vl_Custo_Medio(produto.Cd_Produto,mvto_estoque.dt_mvto_estoque,'H',null,mvto_estoque.hr_mvto_estoque)) Vl_Unitario
                      ,(ItMvto_Estoque.Qt_Movimentacao * uni_pro.Vl_Fator * Verif_Vl_Custo_Medio(produto.Cd_Produto,mvto_estoque.dt_mvto_estoque,'H',null,mvto_estoque.hr_mvto_estoque)) vl_total
                      ,uni_pro.Vl_Fator                                                     vl_fator
                      ,itmvto_estoque.cd_itmvto_estoque                                     cd_itmvto_estoque
                      ,Mvto_Estoque.Cd_Mvto_Estoque                                          cd_saida
                      ,Itent_pro.cd_ent_pro                                                  cd_ent_pro

                  FROM Dbamv.Mvto_Estoque
                      ,Dbamv.Uni_Pro
                      ,Dbamv.ItMvto_Estoque
                      ,Dbamv.Produto
                      ,Dbamv.Fornecedor
                      ,Dbamv.Itent_pro
                      ,dbamv.itmvto_ent
                      ,dbamv.Ent_Pro
                 WHERE Mvto_Estoque.Dt_Mvto_Estoque    Between '01/05/2016' And '18/05/2021'
                   AND ItMvto_Estoque.Cd_Mvto_Estoque = Mvto_Estoque.Cd_Mvto_Estoque
                   AND ItMvto_Estoque.Cd_Produto         = Produto.Cd_Produto
                   AND Uni_Pro.Cd_Uni_Pro(+)             = ItMvto_Estoque.Cd_Uni_Pro
                   AND mvto_estoque.tp_mvto_estoque      = 'E'
                   AND mvto_estoque.cd_fornecedor        = fornecedor.cd_fornecedor
                   AND itmvto_ent.cd_itent_pro(+)      = Itent_pro.cd_itent_pro
                   AND itmvto_estoque.cd_itmvto_estoque(+) = itmvto_ent.cd_itmvto_estoque
                   AND ent_pro.cd_ent_pro               = Itent_pro.cd_ent_pro

                   AND Fornecedor.cd_fornecedor  = 646
                  -- AND Produto.cd_produto = 2399
                )

       ORDER BY  dt_emprestimo  DESC