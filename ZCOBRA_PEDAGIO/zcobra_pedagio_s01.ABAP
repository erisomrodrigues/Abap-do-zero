*&---------------------------------------------------------------------*
*& Include          ZCOBRA_PEDAGIO_S01
*&---------------------------------------------------------------------*

TABLES: ZTAB_PEDAGIO, sscrfields.

DATA: S_PEDAGIO TYPE ztab_pedagio.

SELECTION-SCREEN BEGIN OF BLOCK B1.
  PARAMETERS: P_OPE TYPE ZTAB_PEDAGIO-operador,
              P_PLA TYPE ZTAB_PEDAGIO-placa,
              P_FOR TYPE ZTAB_PEDAGIO-forma_pagto,
              P_CAT TYPE zcategoria_veiculo.

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN FUNCTION KEY 1.
