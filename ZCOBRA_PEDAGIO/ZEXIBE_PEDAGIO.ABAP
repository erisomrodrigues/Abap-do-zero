*&---------------------------------------------------------------------*
*& Report zexibe_pedagio
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zexibe_pedagio.

TABLES: ztab_pedagio.

DATA:

  gt_pedagio TYPE STANDARD TABLE OF ztab_pedagio,
  go_alv     TYPE REF TO cl_salv_table.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
              s_dat FOR ztab_pedagio-data_criacao,
              s_op FOR ztab_pedagio-operador,
              s_cat FOR ztab_pedagio-categoria,
              s_for FOR ztab_pedagio-forma_pagto.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

PERFORM f_le_dados.
PERFORM f_exibe_dados.
*&---------------------------------------------------------------------*
*& Form F_LE_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_le_dados .

  SELECT *
           FROM ztab_pedagio
           INTO TABLE gt_pedagio
           WHERE data_criacao in s_dat
           AND operador       in s_op
           AND categoria      in s_cat
           AND forma_pagto    in s_for.

  IF sy-subrc NE 0 .
    MESSAGE 'SEM DADDOS' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_exbe_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exibe_dados .
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_alv
    CHANGING
      t_table        = gt_pedagio
      ).

  GO_ALV->display( ).


ENDFORM.
