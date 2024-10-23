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

  GS_LAYOUT-box_fieldname = 'SEL'.
  DATA(LV_PROGRAMA) = SY-repid.

 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program                = lv_programa
    i_callback_pf_status_set          = 'F_STATUS'
    i_callback_user_command            = 'F_USER_COMMAND'
    IT_FIELDCAT                       = GT_FIELDCAT
    is_layout                         = gs_layout
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
*&---------------------------------------------------------------------*
*& Form F_STATUS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_STATUS USING RT_EXTAB TYPE slis_t_extab.

  SET PF-STATUS 'ZSTANDARD'." EXCLUDING RT_EXTAB.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_USER_COMMAND USING COMANDO TYPE SY-UCOMM
                          LINHASELECIONADA TYPE slis_selfield.

  CASE comando.
    WHEN 'RECUSAR'.

      LOOP AT gt_itens INTO DATA(LS_ITEM) WHERE sel = 'X'.
        PERFORM F_RECUSAR_ITEM USING LS_ITEM.
      ENDLOOP.

      PERFORM f_selecionar_dados.
      linhaselecionada-refresh = 'X'.


    WHEN 'APROVAR'.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_RECUSAR_ITEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITEM
*&---------------------------------------------------------------------*
FORM f_recusar_item  USING IS_ITEM TYPE TY_ITENS.

DATA: LS_CAB_X  TYPE bapisdh1x,
      LT_RETURN TYPE STANDARD TABLE OF bapiret2,
      LT_ITENS  TYPE STANDARD TABLE OF bapisditm,
      LT_ITENS_X  TYPE STANDARD TABLE OF bapisditmx,
      LS_ITENS  TYPE bapisditm,
      LS_ITENS_X  TYPE bapisditmx.

      ls_itens-itm_number = is_item-posnr.
      ls_itens-reason_rej = '00'.
      APPEND ls_itens TO lt_itens.

      ls_itens_x-itm_number = is_item-posnr.
      ls_itens_x-reason_rej = 'X'.
      ls_itens_x-updateflag = 'U'.
      APPEND ls_itens_x TO lt_itens_x.

      ls_cab_x-updateflag = 'U'.

      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument               = IS_ITEM-vbeln
          order_header_inx            = ls_cab_x
        TABLES
          return                      = lt_return
         ORDER_ITEM_IN               = lt_itens
         ORDER_ITEM_INX              = lt_itens_x .

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
       EXPORTING
         WAIT          = 'X'
*       IMPORTING
*         RETURN        =
                .


ENDFORM.
