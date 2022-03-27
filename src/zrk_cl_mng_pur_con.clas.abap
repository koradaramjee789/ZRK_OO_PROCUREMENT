CLASS zrk_cl_mng_pur_con DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: at_con_uuid TYPE sysuuid_x16 .

    METHODS :
      constructor IMPORTING iv_con_uuid TYPE sysuuid_x16 ,
      get RETURNING VALUE(rs_pur_con) TYPE zrk_t_pur_con,
      create IMPORTING is_pur_con TYPE zrk_t_pur_con,
      modify IMPORTING is_pur_con TYPE zrk_t_pur_con,
      delete,
      get_count RETURNING VALUE(rv_count) TYPE int4 .
   CLASS-METHODS:
      get_defaults_for_create RETURNING VALUE(rs_pur_con) TYPE zrk_t_pur_con.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: gs_pur_con TYPE zrk_t_pur_con.

ENDCLASS.



CLASS ZRK_CL_MNG_PUR_CON IMPLEMENTATION.


  METHOD delete.

    DELETE FROM zrk_t_pur_con WHERE con_uuid = @at_con_uuid.

  ENDMETHOD.


  METHOD get.

    SELECT SINGLE *
    FROM zrk_t_pur_con
    WHERE con_uuid  = @at_con_uuid
    INTO @gs_pur_con.

    rs_pur_con = gs_pur_con.

  ENDMETHOD.


  METHOD modify.

    MODIFY zrk_t_pur_con FROM @is_pur_con.

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

    DATA(ls_pur_con) = is_pur_con.

*    data lv_pcnum type zrk_pc_number.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*        ignore_buffer     =
            nr_range_nr       = '01'
            object            = 'ZRK_NR_PC'
            quantity          = 1 "CONV #( lines( lt_entities_to_gen ) )
*        subobject         =
*        toyear            =
          IMPORTING
                number            = DATA(number_range_key)
                returncode        = DATA(number_range_return_code)
                returned_quantity = DATA(number_range_returned_quantity)
        ).
      CATCH cx_number_ranges.
        "handle exception
    ENDTRY.

    data(lv_pcnum) = conv zrk_pc_number( number_range_key ).
    ls_pur_con-object_id = |PC{ lv_pcnum }|.
    INSERT zrk_t_pur_con FROM @ls_pur_con.

  ENDMETHOD.
ENDCLASS.
