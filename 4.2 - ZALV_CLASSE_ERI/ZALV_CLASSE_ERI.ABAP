
*&---------------------------------------------------------------------*
*& Report zalv_classe_eri
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zalv_classe_eri.

CLASS tratar_eventos DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events IMPORTING e_salv_function.

ENDCLASS.

CLASS tratar_eventos IMPLEMENTATION.

  METHOD on_user_command.
    PERFORM f_user_command USING e_salv_function.
  ENDMETHOD.


ENDCLASS.

DATA: go_tratar_eventos TYPE REF TO tratar_eventos.

TABLES: ZEST_PEDAgio_eri.

DATA: gt_pedagio TYPE STANDARD TABLE OF zest_pedagio_eri,
      go_alv     TYPE REF TO cl_salv_table.

SELECTION-SCREEN: BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_dat FOR zest_pedagio_eri-data_criacao,
                  s_ope FOR zest_pedagio_eri-operador,
                  s_cat FOR zest_pedagio_eri-categoria,
                  s_for FOR zest_pedagio_eri-forma_pagto.
SELECTION-SCREEN: END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM f_ler_dados.
  PERFORM f_exibir_dados.
*&---------------------------------------------------------------------*
*& Form F_LER_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_ler_dados .

  SELECT *
     FROM ztab_pedagio_eri
           INTO TABLE @gt_pedagio
           WHERE data_criacao IN @s_dat
           AND operador_pedagio IN @s_ope
           AND categoria_pedagio IN @s_cat
           AND forma_pagto  IN @s_for.

  IF sy-subrc NE 0.
    MESSAGE 'Sem dados para os parâmetros informados' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_EXIBIR_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exibir_dados .

  TRY.
      cl_salv_table=>factory(
          IMPORTING
          r_salv_table   = go_alv                       " Basis Class Simple ALV Tables
        CHANGING
          t_table        = gt_pedagio
      ).
    CATCH cx_salv_msg.
  ENDTRY.

  DATA: lo_columns TYPE REF TO cl_salv_columns_table,
        lr_column  TYPE REF TO cl_salv_column.

  lo_columns = go_alv->get_columns( ).

  TRY.
      lr_column = lo_columns->get_column( columnname = 'DATA_CRIACAO').
      lr_column->set_long_text( value = 'Data de Criação').
      lr_column->set_medium_text( value = 'Data Criação').
      lr_column->set_short_text( value = 'Dt Criação').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'RECIBO').
      lr_column->set_long_text( value = 'Número Recibo').
      lr_column->set_medium_text( value = 'Recibo').
      lr_column->set_short_text( value = 'Recibo').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'CATEGORIA').
      lr_column->set_long_text( value = 'Categoria').
      lr_column->set_medium_text( value = 'Categoria').
      lr_column->set_short_text( value = 'Cat').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'FORMA_PAGTO').
      lr_column->set_long_text( value = 'Forma de Pagamento').
      lr_column->set_medium_text( value = 'Forma Pag').
      lr_column->set_short_text( value = 'For Pg').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'VALOR').
      lr_column->set_long_text( value = 'Valor').
      lr_column->set_medium_text( value = 'Valor').
      lr_column->set_short_text( value = 'Vr').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'PLACA').
      lr_column->set_long_text( value = 'Placa').
      lr_column->set_medium_text( value = 'Placa').
      lr_column->set_short_text( value = 'Placa').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'OPERADOR').
      lr_column->set_long_text( value = 'Operador').
      lr_column->set_medium_text( value = 'Operador').
      lr_column->set_short_text( value = 'Oper').
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column = lo_columns->get_column( columnname = 'MANDT').
      lr_column->set_visible( abap_false ).
    CATCH cx_salv_not_found.
  ENDTRY.

*  DATA: FUNCTIONS TYPE REF TO cl_salv_functions_list.
*
*  functions = go_alv->get_functions( ).
*  functions->set_all( ABAP_TRUE ).

  go_alv->set_screen_status(
  pfstatus = 'SALV_STANDARD'
  report = sy-repid
  set_functions = go_alv->c_functions_all ).

  DATA: lo_selections TYPE REF TO cl_salv_selections.

  lo_selections = go_alv->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  DATA: lr_eventos TYPE REF TO cl_salv_events_table.
  lr_eventos = go_alv->get_event( ).

  CREATE OBJECT GO_tratar_eventos.
  SET HANDLER go_tratar_eventos->on_user_command FOR lr_eventos.

  go_alv->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM f_user_command  USING i_function TYPE salv_de_function.

  DATA: lo_selections TYPE REF TO cl_salv_selections,
        lt_Rows       TYPE salv_t_row.

BREAK-POINT.
  CASE i_function .
    WHEN 'IMP'.
      lo_selections = go_alv->get_selections( ).
      lt_rows = lo_selections->get_selected_rows( ).

      LOOP AT lt_rows INTO DATA(ls_row).

        READ TABLE gt_pedagio INTO DATA(ls_pedagio) INDEX ls_row.

        CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
          EXPORTING
            titel     = 'Impressão'
            textline1 = 'Recibo'
            textline2 = ls_pedagio-recibo
*           START_COLUMN       = 25
*           START_ROW = 6.
.
      ENDLOOP.

    WHEN 'IMP_ALL'.
    WHEN OTHERS.
  ENDCASE.



ENDFORM.
