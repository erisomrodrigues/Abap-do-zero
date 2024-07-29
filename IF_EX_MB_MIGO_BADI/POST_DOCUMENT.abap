METHOD if_ex_mb_migo_badi~post_document."
***************************
*Deivison Nelson Ferreira
*Data: 06/03/2020
*Solicitar confirmação de Notas Fiscais de Referencias e gerar lancamento finaceiro na contabilidade
*****************************

  DATA: gt_mseg TYPE STANDARD TABLE OF mseg.
  DATA: ge_mseg TYPE mseg.
  DATA: ge_preco_anterior TYPE zes_preco_anterior.
  DATA: v_amt_doccur TYPE bapidoccur,
        lv_init      TYPE j_1bexbase.

* APPC - SD.551564 Erisom Almeida - 17/07/2024 - Inicio
  DATA: lt_fields TYPE TABLE OF sval,
        ls_fields TYPE sval.

  DATA: lv_nftot      TYPE bapidoccur,      " Armazenar o valor total da NFe
        lv_returncode TYPE char1 VALUE 'A'. " Armazrnar o retorno do FM POPUP_GET_VALUES

  ls_fields-tabname    = 'J_1BNFDOC'. " Tabela do Dicionario de Dados
  ls_fields-fieldname  = 'WAERK'.     " Elemento de Dados
  ls_fields-value      = 'BRL'.       " Tipo de Moeda
  ls_fields-field_attr = '01'.        " Habilitar campo de edição
  ls_fields-fieldtext  = 'Moeda'.     " Texto
  ls_fields-field_obl  = abap_true.   " Torna campo obrigatório
  APPEND ls_fields TO lt_fields.

  CLEAR ls_fields.

  ls_fields-tabname     = 'J_1BNFDOC'.
  ls_fields-fieldname   = 'NFTOT'.
  ls_fields-field_attr  = '01'.
  ls_fields-fieldtext   = 'Valor'.
  ls_fields-field_obl   = abap_true.
  APPEND ls_fields TO lt_fields.

* APPC - SD.551564 Erisom Almeida - 17/07/2024 - Fim

  CLEAR v_amt_doccur.

  READ TABLE it_mseg INTO ge_mseg INDEX 1.
  IF ge_mseg-bwart = 'Z51' OR ge_mseg-bwart = 'Z53' OR ge_mseg-bwart = 'Z55' OR ge_mseg-bwart = 'Z52' OR ge_mseg-bwart = 'Z54' OR ge_mseg-bwart = 'Z56'.
    IF ge_mseg-bwart EQ 'Z51' OR ge_mseg-bwart EQ 'Z53' OR ge_mseg-bwart EQ 'Z55'.
      CALL FUNCTION 'ZMM_FC_ADIC_NFE_REF_DEV_GA'
        EXPORTING
          im_mblnr = is_mkpf-mblnr
          im_mjahr = is_mkpf-mjahr
          im_bwart = ge_mseg-bwart.

      LOOP AT it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).
        v_amt_doccur = v_amt_doccur + <fs_mseg>-dmbtr.
      ENDLOOP.
    ENDIF.

*   APPC - SD.551564 Erisom Almeida - 26/07/2024 - Inicio
    WHILE lv_returncode = 'A' OR ls_fields-value <= 0 .
      CALL FUNCTION 'POPUP_GET_VALUES'
        EXPORTING
          popup_title  = 'Valor Total da NFe'
          start_column = '5'
          start_row    = '5'
        IMPORTING
          returncode   = lv_returncode
        TABLES
          fields       = lt_fields.
      IF lv_returncode = 'A'.
        MESSAGE 'Não é possível câncelar o processamento. Por favor informar o valor da Nota' TYPE 'I'.
      ENDIF.

      READ TABLE lt_fields WITH KEY fieldname = 'NFTOT' INTO ls_fields.

    ENDWHILE.

    lv_nftot = ls_fields-value.

*   APPC - SD.551564 Erisom Almeida - 26/07/2024 - Fim
    CALL FUNCTION 'ZMM_FC_LANC_FINANCEIRO_GARANTI' IN UPDATE TASK
      EXPORTING
        im_mkpf  = is_mkpf
*       im_valor = v_amt_doccur
        im_valor = lv_nftot
      TABLES
        tb_mseg  = it_mseg.

  ENDIF.
  REFRESH gt_preco_anterior.
ENDMETHOD.
