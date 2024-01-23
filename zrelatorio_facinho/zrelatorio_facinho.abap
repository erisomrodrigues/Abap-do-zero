*&---------------------------------------------------------------------*
*& Report zrelatorio_facinho
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrelatorio_facinho.

DATA: GT_sflight TYPE TABLE OF sflight,
      GO_ALV    TYPE REF TO CL_SALV_TABLE.

      SELECT *
                FROM sflight
                INTO TABLE GT_sflight.


cl_salv_table=>factory(
*  EXPORTING
*    list_display   = if_salv_c_bool_sap=>false
*    r_container    =
*    container_name =
  IMPORTING
    r_salv_table   = GO_ALV
  CHANGING
    t_table        = GT_sflight
).
*CATCH cx_salv_msg.

GO_ALV->display( ).
