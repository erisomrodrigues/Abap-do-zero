*&---------------------------------------------------------------------*
*& Report zcobra_pedagio
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcobra_pedagio.

INCLUDE zcobra_pedagio_s01.

INCLUDE zcobra_pedagio_f01.


INITIALIZATION.
  p_ope = sy-uname.
  p_for = '01'.

  MOVE 'RELATORIO' TO sscrfields-functxt_01.

AT SELECTION-SCREEN.
  IF SY-ucomm = 'FC01'.
    SUBMIT ZEXIBE_PEDAGIO VIA SELECTION-SCREEN.

  ENDIF.

START-OF-SELECTION.

  IF p_cat IS INITIAL.
    MESSAGE 'PREENCHER CATEGORIA' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.

  ENDIF.

  PERFORM f_grava_cobranca.

  PERFORM f_exibir_cobranca.
