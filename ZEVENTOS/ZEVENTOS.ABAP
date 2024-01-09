*&---------------------------------------------------------------------*
*& Report zeventos
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zeventos.

DATA: total TYPE p DECIMALS 2.

PARAMETERS: p_qtd   TYPE i,
            p_valor TYPE p DECIMALS 2,
            p_data  TYPE sy-datum.

INITIALIZATION.
p_valor = '1.99'.
p_data  = sy-datum - 7.

AT SELECTION-SCREEN.
  IF p_qtd <= 0.
    MESSAGE 'INFORME A QUANTIDADE' TYPE 'E'.
    RETURN.
  ENDIF.

  START-OF-SELECTION.

  total = p_qtd * p_valor.

  WRITE:/ 'O Resultado da Mutiplição é :', total.
