FUNCTION zmm_fc_lanc_financeiro_garanti.
*"----------------------------------------------------------------------
*"*"Módulo função atualização:
*"
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_MKPF) TYPE  MKPF
*"     VALUE(IM_VALOR) TYPE  BAPIDOCCUR
*"  TABLES
*"      TB_MSEG STRUCTURE  MSEG
*"----------------------------------------------------------------------

  "Tabelas
  DATA: gt_return TYPE STANDARD TABLE OF  bapiret2 WITH HEADER LINE.

  "Variáveis
  DATA: v_obj_key TYPE bapiache09-obj_key,
        v_xblnr   TYPE rbkp-xblnr.


  "Estruturas
  DATA: ge_reversal LIKE bapiacrev,
        ge_mseg     TYPE mseg.

  "Variaveis Locais
  DATA: lv_nrnot  TYPE j_1bnfnum9, "APPC - SD.551564 Erisom Almeida - 18/07/2024
        lv_serie  TYPE j_1bseries, "APPC - SD.551564 Erisom Almeida - 18/07/2024
        lv_refkey TYPE j_1brefkey. "APPC - SD.551564 Erisom Almeida - 18/07/2024

  READ TABLE tb_mseg INTO ge_mseg INDEX 1.

  IF ge_mseg-bwart = 'Z52' OR ge_mseg-bwart = 'Z54' OR ge_mseg-bwart = 'Z56'.
    CONCATENATE ge_mseg-smbln ge_mseg-sjahr INTO v_xblnr.
    CONDENSE v_xblnr.
    SELECT bukrs,belnr,gjahr FROM bkpf INTO TABLE @DATA(gt_bkpf)
      WHERE bukrs       = @ge_mseg-bukrs AND
            bstat       = '' AND
            xblnr       = @v_xblnr AND
            blart  = 'KG'.
    IF sy-subrc EQ 0.
      ge_reversal-obj_type = 'BKPFF'.
      READ TABLE gt_bkpf INTO DATA(ge_bkpf) INDEX 1.
      CONCATENATE ge_bkpf-belnr ge_bkpf-bukrs ge_bkpf-gjahr INTO ge_reversal-obj_key.
      CONDENSE ge_reversal-obj_key.
      ge_reversal-obj_key_r = ge_reversal-obj_key.
      ge_reversal-pstng_date = sy-datum.
      ge_reversal-reason_rev = '04'.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_REV_POST'
        EXPORTING
          reversal = ge_reversal
          bus_act  = 'RFBU'
        TABLES
          return   = gt_return.

      SORT gt_return BY type.
      READ TABLE gt_return WITH KEY type = 'E' BINARY SEARCH.
      IF sy-subrc NE 0.
        UPDATE zmmt020 SET
           bukrs = ge_mseg-bukrs
           belnr = v_obj_key(10)
           gjahr = v_obj_key+14(4)
        WHERE
            mblnr = ge_mseg-mblnr AND
            mjahr = ge_mseg-mjahr.
      ENDIF.
    ENDIF.
  ELSE.
*   APPC - MM.551564 - Ericky Fernandes - 22/05/2024 - Início
    TRY.
        DATA(lo_mm) = NEW zmmcl_process( ).

        "Busca as exceções para lançamento financeiro
        DATA(lt_exception) = lo_mm->set_migo_financial( ).

        "Percorre as exceções dos materiais que não devem gerar financeiro
        LOOP AT lt_exception ASSIGNING FIELD-SYMBOL(<lfs_exception>).
          IF line_exists( tb_mseg[ matnr = <lfs_exception>-matnr
                                   lifnr = <lfs_exception>-lifnr ] ).
            DATA(lv_nao_gera) = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        "Verifica se deve continuar
        CHECK lv_nao_gera = abap_false.

        "Gera o documento financeiro
        lo_mm->accounting_financial_migo( EXPORTING it_mseg        = tb_mseg[]
                                                    is_mkpf        = im_mkpf
                                                    iv_preco_bruto = im_valor ).

      CATCH cx_root INTO DATA(lo_root).

    ENDTRY.
*   APPC - MM.551564 - Ericky Fernandes - 22/05/2024 - Fim
  ENDIF.

ENDFUNCTION.
