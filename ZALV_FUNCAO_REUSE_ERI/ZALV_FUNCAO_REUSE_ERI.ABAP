*&---------------------------------------------------------------------*
*& Report zalv_funcao_eri
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zalv_funcao_reuse_eri.


INCLUDE ZALV_FUNCAO_REUSE_ERI_S01.

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

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
 EXPORTING
*   I_PROGRAM_NAME               =
   I_INTERNAL_TABNAME           = 'GT_ITENS'
   I_STRUCTURE_NAME             = 'ZITENSRECUSA_ERI'

  CHANGING
    ct_fieldcat                  = gt_fieldcat
 EXCEPTIONS
   INCONSISTENT_INTERFACE       = 1
   PROGRAM_ERROR                = 2
   OTHERS                       = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


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
