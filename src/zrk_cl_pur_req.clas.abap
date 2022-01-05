CLASS zrk_cl_pur_req DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  INHERITING FROM zrk_cl_proc_doc.

  PUBLIC SECTION.
    METHODS : constructor
      IMPORTING
        i_object_type TYPE zrk_obj_type
        i_object_id   TYPE zrk_object_id,
      zrk_if_proc_doc~get_doc_details REDEFINITION.


  PROTECTED SECTION.

    DATA : at_object_det TYPE zrk_obj_det.

  PRIVATE SECTION.
ENDCLASS.



CLASS zrk_cl_pur_req IMPLEMENTATION.


  METHOD constructor.

    super->constructor( i_object_type = i_object_type i_object_id = i_object_id ).

    SELECT SINGLE object_id , description , buyer , stat_code
    FROM zrk_t_pur_req_h
    WHERE object_id = @at_object_id
    INTO CORRESPONDING FIELDS OF @at_object_det.

  ENDMETHOD.

  METHOD zrk_if_proc_doc~get_doc_details.

    e_object_det = at_object_det.

  ENDMETHOD.

ENDCLASS.
