*&---------------------------------------------------------------------*
*& Report Z_CLASSES_ERI001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_CLASSES_ERI001.

" DEFININDO VARIÁVEIS DO TIPO CLASSE
DATA: LO_PEDAGIO TYPE REF TO ZCL_PEDAGIO2_GUI.
" INICIANDO VARIÁVEL
CREATE OBJECT lo_pedagio.

"SEGUNDA FORMA DE INICIAR CLASSE
DATA: LO_PEDAGIO2 TYPE REF TO ZCL_PEDAGIO2_GUI.
lo_pedagio = NEW  zcl_pedagio2_guI( ).

"TERCEIRA FORMA
DATA: LO_PEDAGIO3 TYPE REF TO ZCL_PEDAGIO2_GUI.
lo_pedagio3 = NEW #( ).

"QUARTA FORMA - DECLARAÇÃO INLINE
DATA(LO_PEDAGIO4) = NEW zcl_pedagio2_gui( ).
