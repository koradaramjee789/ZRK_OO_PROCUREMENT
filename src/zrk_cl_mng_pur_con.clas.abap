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



CLASS zrk_cl_mng_pur_con IMPLEMENTATION.

  METHOD constructor.
    at_con_uuid = iv_con_uuid.
  ENDMETHOD.

  METHOD create.

    DATA(ls_pur_con) = is_pur_con.
    ls_pur_con-object_id = |PC{ get_count( ) + 1 }|.
    INSERT zrk_t_pur_con FROM @ls_pur_con.

  ENDMETHOD.

  METHOD delete.

    DELETE FROM zrk_t_pur_con WHERE con_uuid = @at_con_uuid.

  ENDMETHOD.

  METHOD get.

    SELECT SINGLE *
    FROM zrk_t_pur_con
    WHERE con_uuid  = @at_con_uuid
    INTO @gs_pur_con.

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

ENDCLASS.
