*&---------------------------------------------------------------------*
*& Include          ZALV_FUNCAO_ERI_S01
*&---------------------------------------------------------------------*

TABLES: VBAP.

TYPES: BEGIN OF TY_ITENS,
        VBELN   TYPE VBAP-VBELN,
        POSNR   TYPE VBAP-POSNR,
        MATNR   TYPE VBAP-MATNR,
        ARKTX   TYPE VBAP-ARKTX,
        KWMENG  TYPE VBAP-KWMENG,
        VRKME   TYPE VBAP-VRKME,
        ABGRU   TYPE VBAP-ABGRU,
        SEL     TYPE CHAR1,
       END OF TY_ITENS.


DATA: GT_ITENS TYPE STANDARD TABLE OF TY_ITENS.

TYPE-POOLS: SLIS.
DATA: GT_FIELDCAT TYPE slis_t_fieldcat_alv.
DATA: GS_LAYOUT TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK B1.
            SELECT-OPTIONS: S_DOC FOR VBAP-vbeln.
SELECTION-SCREEN END OF BLOCK B1.
