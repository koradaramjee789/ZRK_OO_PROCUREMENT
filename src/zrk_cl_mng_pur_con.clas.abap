CLASS zrk_cl_mng_pur_con DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: at_con_uuid TYPE sysuuid_x16 .

    METHODS :
      constructor IMPORTING iv_con_uuid TYPE sysuuid_x16 ,
      get RETURNING VALUE(rs_pur_con) TYPE zrk_t_pur_con,
      create IMPORTING is_pur_con TYPE zrk_t_pur_con RETURNING VALUE(rv_object_id) TYPE zrk_object_id,
      modify IMPORTING is_pur_con TYPE zrk_t_pur_con,
      delete,
      get_count RETURNING VALUE(rv_count) TYPE int4,
      add_item IMPORTING it_item TYPE zrk_tt_pur_con_i,
      upd_item IMPORTING it_item TYPE zrk_tt_pur_con_i,
      get_mode RETURNING VALUE(rv_mode) TYPE char10,

      save_document.
    CLASS-METHODS:
      get_defaults_for_create RETURNING VALUE(rs_pur_con) TYPE zrk_t_pur_con,
      get_instance IMPORTING iv_con_uuid        TYPE sysuuid_x16 OPTIONAL
                   RETURNING VALUE(rv_instance) TYPE REF TO zrk_cl_mng_pur_con,
      validate_supp_le
        IMPORTING iv_supplier        TYPE zrk_sup_no
                  iv_comp_code       TYPE zrk_company_code
        RETURNING VALUE(rv_allowedd) TYPE abap_boolean
        .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: gs_pur_con       TYPE zrk_t_pur_con,
          gs_pur_con_upd   TYPE zrk_t_pur_con,
          gt_pur_con_i     TYPE zrk_tt_pur_con_i,
          gt_pur_con_i_upd TYPE zrk_tt_pur_con_i,
          gv_mode TYPE char10.
    CLASS-DATA :          go_instance TYPE REF TO zrk_cl_mng_pur_con.

ENDCLASS.



CLASS ZRK_CL_MNG_PUR_CON IMPLEMENTATION.


  METHOD delete.

    DELETE FROM zrk_t_pur_con WHERE con_uuid = @at_con_uuid.

  ENDMETHOD.


  METHOD get.

    IF gs_pur_con_upd IS INITIAL .
        SELECT SINGLE *
        FROM zrk_t_pur_con
        WHERE con_uuid  = @at_con_uuid
        INTO @gs_pur_con.
        IF sy-subrc EQ 0.
            rs_pur_con = gs_pur_con.
        ENDIF.
    ELSE.
        rs_pur_con = gs_pur_con_upd .
    ENDIF.

  ENDMETHOD.


  METHOD modify.

* Set mode
    gv_mode = 'MODIFY'.
*    MODIFY zrk_t_pur_con FROM @is_pur_con.

    gs_pur_con_upd = is_pur_con.

  ENDMETHOD.


  METHOD get_count.

    SELECT COUNT( * )
        FROM zrk_t_pur_con
        INTO @rv_count.

  ENDMETHOD.


  METHOD get_defaults_for_create.

    rs_pur_con-comp_code = 'CC28'.

  ENDMETHOD.


  METHOD constructor.
    at_con_uuid = iv_con_uuid.
  ENDMETHOD.


  METHOD create.


* Set mode
    gv_mode = 'CREATE'.

    DATA(ls_pur_con) = is_pur_con.

*    data lv_pcnum type zrk_pc_number.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*           ignore_buffer     =
            nr_range_nr       = '01'
            object            = 'ZRK_NR_PC'
            quantity          = 1 "CONV #( lines( lt_entities_to_gen ) )
*           subobject         =
*           toyear            =
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_return_code)
            returned_quantity = DATA(number_range_returned_quantity)
        ).
      CATCH cx_number_ranges.
        "handle exception
    ENDTRY.

    DATA(lv_pcnum) = CONV zrk_pc_number( number_range_key ).
    ls_pur_con-object_id = |PC{ lv_pcnum }|.
    gs_pur_con_upd = ls_pur_con.
    rv_object_id = gs_pur_con_upd-object_id.
*    modify zrk_t_pur_con FROM @ls_pur_con.
*    save_document( ).

  ENDMETHOD.


  METHOD validate_supp_le.

    IF iv_supplier EQ 'S000000003'
        AND iv_comp_code EQ 'CC28'.
      rv_allowedd = abap_false.
    ELSE.
      rv_allowedd = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD upd_item.

    IF gv_mode IS INITIAL.
        gv_mode = 'MODIFY'.
    ENDIF.

    gt_pur_con_i_upd = it_item.

  ENDMETHOD.


  METHOD save_document.

    IF gs_pur_con_upd IS NOT INITIAL.
      MODIFY zrk_t_pur_con FROM @gs_pur_con_upd .
    ENDIF.

    IF gt_pur_con_i_upd IS NOT INITIAL.
      MODIFY zrk_t_pur_con_i FROM TABLE @gt_pur_con_i_upd.
    ENDIF.


  ENDMETHOD.


  METHOD get_instance.

    IF go_instance IS NOT BOUND
        AND iv_con_uuid IS NOT INITIAL.
      CREATE OBJECT go_instance
        EXPORTING
          iv_con_uuid = iv_con_uuid.
    ENDIF.
    rv_instance = go_instance.
  ENDMETHOD.


  METHOD add_item.

    IF gv_mode IS INITIAL.
        gv_mode = 'MODIFY'.
    ENDIF.

    gt_pur_con_i_upd = it_item.

  ENDMETHOD.


  METHOD GET_MODE.

    rv_mode = gv_mode .

  ENDMETHOD.
ENDCLASS.
