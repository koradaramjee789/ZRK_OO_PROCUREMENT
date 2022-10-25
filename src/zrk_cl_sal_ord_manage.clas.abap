CLASS zrk_cl_sal_ord_manage DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS :
      constructor IMPORTING iv_sal_ord_id TYPE zrk_object_id OPTIONAL,
      create IMPORTING is_sal_ord TYPE zrk_t_sal_ord_h RETURNING VALUE(rv_object_id) TYPE zrk_object_id,
      modify IMPORTING is_sal_ord TYPE zrk_t_sal_ord_h,
      get EXPORTING es_sal_ord TYPE zrk_t_sal_ord_h,
      get_mode RETURNING VALUE(rv_mode) TYPE char10,
      get_sal_ord_id RETURNING VALUE(rv_sal_ord_id) TYPE zrk_sal_ord_id,
      generate_sal_ord_id RETURNING VALUE(rv_sal_ord_id) TYPE zrk_sal_ord_id,
      add_item IMPORTING is_sal_ord_i TYPE zrk_t_sal_ord_i,
      modify_item IMPORTING is_sal_ord_i TYPE zrk_t_sal_ord_i,
      save .
    CLASS-METHODS :       get_instance IMPORTING iv_sal_ord_id      TYPE zrk_object_id OPTIONAL
                                       RETURNING VALUE(rv_instance) TYPE REF TO zrk_cl_sal_ord_manage.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA : at_ord_uuid   TYPE sysuuid_x16,
           gt_sal_ord    TYPE TABLE OF zrk_t_sal_ord_h,
           gt_sal_ord_i  TYPE TABLE OF zrk_t_sal_ord_i,
           gv_mode       TYPE char10,
           at_sal_ord_id TYPE zrk_sal_ord_id.

    CLASS-DATA : go_instance TYPE REF TO zrk_cl_sal_ord_manage.


ENDCLASS.



CLASS zrk_cl_sal_ord_manage IMPLEMENTATION.
  METHOD constructor.
    at_sal_ord_id = iv_sal_ord_id.

    get(
*      IMPORTING
*        es_sal_ord =
    ).

  ENDMETHOD.

  METHOD get_instance.
    IF go_instance IS NOT BOUND .
*        AND iv_con_uuid IS NOT INITIAL.
      CREATE OBJECT go_instance
        EXPORTING
          iv_sal_ord_id = iv_sal_ord_id.
    ENDIF.
    rv_instance = go_instance.
  ENDMETHOD.

  METHOD create.

    gv_mode = 'CREATE' .
    APPEND is_sal_ord TO gt_sal_ord.

    gt_sal_ord[ 1 ]-object_id = 'S0'.
    rv_object_id = 'S0'.

*    generate_sal_ord_id(
*      RECEIVING
*        rv_sal_ord_id = rv_object_id
*    ).

  ENDMETHOD.

  METHOD modify.

    gv_mode = 'MODIFY' .

    APPEND is_sal_ord TO gt_sal_ord.
    at_sal_ord_id = gt_sal_ord[ 1 ]-object_id.
  ENDMETHOD.

  METHOD save.

*        generate_sal_ord_id( ).
    IF gt_sal_ord IS NOT INITIAL.
      MODIFY zrk_t_sal_ord_h FROM TABLE @gt_sal_ord.
    ENDIF.

    IF gt_sal_ord_i IS NOT INITIAL.
      MODIFY zrk_t_sal_ord_i FROM TABLE @gt_sal_ord_i.
    ENDIF.

  ENDMETHOD.

  METHOD generate_sal_ord_id.

    IF gv_mode = 'CREATE'.
      SELECT COUNT( object_id  )
          FROM zrk_t_sal_ord_h
          INTO @DATA(lv_count).

      IF sy-subrc EQ 0.
        at_sal_ord_id = |SO{ lv_count + 1 }| .
      ELSE.
        at_sal_ord_id = 'SO1'.
      ENDIF.

      gt_sal_ord[ 1 ]-object_id = at_sal_ord_id .

      rv_sal_ord_id = at_sal_ord_id.


    ENDIF.
  ENDMETHOD.

  METHOD get.

    IF gt_sal_ord IS INITIAL.

      SELECT *
          FROM zrk_t_sal_ord_h
          WHERE object_id = @at_sal_ord_id
          INTO TABLE @gt_sal_ord .

    ENDIF.

    es_sal_ord = VALUE #( gt_sal_ord[ 1 ] OPTIONAL ) .

  ENDMETHOD.

  METHOD get_sal_ord_id.
    rv_sal_ord_id = at_sal_ord_id .
  ENDMETHOD.

  METHOD get_mode.
    rv_mode = gv_mode.
  ENDMETHOD.

  METHOD add_item.

    IF gv_mode IS INITIAL .
      gv_mode = 'MODIFY' .
    ENDIF.

    APPEND is_sal_ord_i TO gt_sal_ord_i.

  ENDMETHOD.

  METHOD modify_item.

    IF gv_mode IS INITIAL .
      gv_mode = 'MODIFY' .
    ENDIF.

    APPEND is_sal_ord_i TO gt_sal_ord_i.

  ENDMETHOD.

ENDCLASS.
