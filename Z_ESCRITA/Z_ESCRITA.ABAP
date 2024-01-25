*&---------------------------------------------------------------------*
*& Report z_escrita
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_escrita.

DATA: s_materiais TYPE ztab_materiais,
      t_materiais TYPE TABLE OF ztab_materiais.

" INSERINDO OS REGISTROS DIRETO NA TABELA TRANSPARENTE
*S_MATERIAIS-codigo = 0001.
*S_MATERIAIS-descricao = 'Agua Santitaria'.
*S_MATERIAIS-peso = 700.
*S_MATERIAIS-un_peso = 'G'.
*S_MATERIAIS-un_venda = 'UN'.
*INSERT ZTAB_MATERIAIS TABLE T_MATERIAIS.

*
*S_MATERIAIS-codigo = 0002.
*S_MATERIAIS-descricao = 'Palito de Dente'.
*S_MATERIAIS-peso = 150.
*S_MATERIAIS-un_peso = 'G'.
*S_MATERIAIS-un_venda = 'CX'.
*INSERT ZTAB_MATERIAIS TABLE T_MATERIAIS.

*S_MATERIAIS-codigo = 0003.
*S_MATERIAIS-descricao = 'Sabão em Pó'.
*S_MATERIAIS-peso = 500.
*S_MATERIAIS-un_peso = 'G'.
*S_MATERIAIS-un_venda = 'CX'.
*INSERT ZTAB_MATERIAIS TABLE T_MATERIAIS.


" INSERINDO OS REGISTRO USANDO UMA TABELA INTERNA
*S_MATERIAIS-codigo = 0004.
*S_MATERIAIS-descricao = 'Batata Palha'.
*S_MATERIAIS-peso = 150.
*S_MATERIAIS-un_peso = 'G'.
*S_MATERIAIS-un_venda = 'PT'.
*APPEND S_MATERIAIS TO T_MATERIAIS.
*INSERT ZTAB_MATERIAIS FROM TABLE T_MATERIAIS.

" INSERINDO OS REGISTROS ATRAVÉS DOS PARAMETERS
*PARAMETERS: p_codigo TYPE ztab_materiais-codigo,
*            p_descri TYPE ztab_materiais-descricao,
*            p_peso   TYPE ztab_materiais-peso,
*            p_un_p   TYPE ztab_materiais-un_peso,
*            p_un_v   TYPE ztab_materiais-un_venda.
*
*
*s_materiais-codigo = p_codigo.
*s_materiais-descricao = p_descri.
*s_materiais-peso      = p_peso.
*s_materiais-un_peso = p_un_p.
*s_materiais-un_venda = p_un_v.
*APPEND s_materiais TO t_materiais.
*INSERT ztab_materiais FROM TABLE t_materiais.

" ALTERANDO OS VALORES DIRETO NA TABELA TRANSARENTE
*s_materiais-codigo = 0001.
*s_materiais-descricao = 'ARROZ PARBORIZADO'.
*s_materiais-peso = 700.
*s_materiais-un_peso = 'G'.
*s_materiais-un_venda = 'UN'.
*MODIFY ztab_materiais FROM s_materiais.

" ALTERANDO DADOS USANDO O UPDATE
*s_materiais-codigo = 0002.
*s_materiais-descricao = 'Pizza 4 Queijos'.
*s_materiais-peso = 800.
*s_materiais-un_peso = 'G'.
*s_materiais-un_venda = 'UN'.
*UPDATE ztab_materiais FROM s_materiais.

" ALTERANDO OS DADOS PELA TABELA INTERNA
*S_MATERIAIS-codigo = 0003.
*S_MATERIAIS-descricao = 'Sabão em Barras'.
*S_MATERIAIS-peso = 30.
*S_MATERIAIS-un_peso = 'G'.
*s_materiais-un_venda = 'BAR'.
*APPEND S_MATERIAIS TO T_MATERIAIS.
*UPDATE ZTAB_MATERIAIS FROM TABLE T_MATERIAIS.

" ALTERANDO APENAS UM VALOR USANDO UPDATE
UPDATE ztab_materiais
SET un_peso = 'TON'
WHERE un_venda = 'PT'
AND   PESO = 150.

write: / 'ERROS: ', sy-subrc,
       / 'LINHA GRAVADAS: ', sy-dbcnt.
