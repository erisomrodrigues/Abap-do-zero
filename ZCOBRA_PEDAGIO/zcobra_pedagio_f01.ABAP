*&---------------------------------------------------------------------*
*& Include          ZCOBRA_PEDAGIO_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form F_GRAVA_COBRANCA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_grava_cobranca .
  S_PEDAGIO-DATA_CRIACAO = SY-DATUM.
  S_PEDAGIO-HORA_CRIACAO = SY-UZEIT.
  S_PEDAGIO-OPERADOR = P_OPE.
  S_PEDAGIO-CATEGORIA = P_CAT.
  S_PEDAGIO-FORMA_PAGTO = P_FOR.
  S_PEDAGIO-PLACA = P_PLA.

  SELECT SINGLE VALOR
          FROM ztarifaspedagio
          INTO S_PEDAGIO-VALOR
          WHERE CATEGORIA = P_CAT.


  INSERT ZTAB_PEDAGIO FROM S_PEDAGIO.

  IF SY-SUBRC EQ 0.
      MESSAGE 'REGISTRO INSERIDO' TYPE 'S'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_EXIBIR_COBRANCA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exibir_cobranca .
        WRITE:
     / 'DOC. FISCAL EQUIVALENTE IN1731/17 ART.2',
     / 'AUTOPISTA LITORAL SUL',
     / '09.313.969/0001-97',
     / 'SÃO PAULO', 'KM365',
     / S_PEDAGIO-DATA_CRIACAO, S_PEDAGIO-HORA_CRIACAO, 'RECIBO: ',
     / 'OPERADOR: ', S_PEDAGIO-OPERADOR, 'CATEGORIA: ', S_PEDAGIO-CATEGORIA,
     / 'VALOR PAGO: ', S_PEDAGIO-VALOR, 'F.PAGTO:', S_PEDAGIO-FORMA_PAGTO,
     / 'PLACA:', S_PEDAGIO-PLACA.

ENDFORM.
