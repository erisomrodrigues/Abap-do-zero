*&---------------------------------------------------------------------*
*& Report zalv_funcao_eri
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zalv_funcao_eri.


INCLUDE zalv_funcao_eri_s01.

PERFORM f_selecionar_dados.
PERFORM f_montar_tabela_alv.
PERFORM F_EXIBIR_ALV.
*&---------------------------------------------------------------------*
*& Form F_SELECIONAR_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_selecionar_dados .

  SELECT
          vbeln,
          posnr,
          matnr,
          arktx,
          kwmeng,
          vrkme,
          abgru
          FROM vbap
          INTO TABLE @gt_itens
          WHERE vbeln IN @s_doc.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_MONTAR_TABELA_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_montar_tabela_alv .

  DATA: ls_fieldcat TYPE slis_fieldcat_alv.

  ls_fieldcat-reptext_ddic = 'Documento de Vendas'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'VBELN'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Item'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'POSNR'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Material'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'MATNR'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Descrição'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'ARKTX'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Documento de Vendas'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'VBELN'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Quantidade'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'KWMENG'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Unidade de Venda'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'VRKME'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat-reptext_ddic = 'Motivo de Recusa'.
  ls_fieldcat-tabname = 'GT_ITENS'.
  ls_fieldcat-fieldname = 'ABGRU'.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR ls_fieldcat.

  ls_fieldcat = VALUE #( reptext_ddic = 'Motivo de Recusa'
                         tabname      = 'GT_ITENS'
                         fieldname    = 'ABGRU'   ).
  CLEAR ls_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_EXIBIR_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exibir_alv .

 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    IT_FIELDCAT                       = GT_FIELDCAT
    I_DEFAULT                         = 'X'
    I_SAVE                            = 'A'
   TABLES
     t_outtab                          = GT_ITENS
  EXCEPTIONS
    PROGRAM_ERROR                     = 1
    OTHERS                            = 2 .

 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.

ENDFORM.
