CLASS zrk_cl_proc_doc DEFINITION
  PUBLIC
  CREATE PUBLIC .



  PUBLIC SECTION.

    INTERFACES : zrk_if_proc_doc.
    METHODS : constructor
      IMPORTING
        i_object_type TYPE zrk_obj_type
        i_object_id   TYPE zrk_object_id
      .
  PROTECTED SECTION.
    DATA: at_object_type TYPE zrk_obj_type,
          at_object_id   TYPE zrk_object_id.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZRK_CL_PROC_DOC IMPLEMENTATION.


  METHOD constructor.
    at_object_type = i_object_type.
    at_object_id = i_object_id.

  ENDMETHOD.


  METHOD zrk_if_proc_doc~approve_doc.

  ENDMETHOD.


  METHOD zrk_if_proc_doc~get_doc_details.



  ENDMETHOD.


  METHOD zrk_if_proc_doc~get_instance.


    DATA lv_CLASS_NAME TYPE string.

    lv_class_name = |ZRK_CL{ at_object_type }|.

    CREATE OBJECT ro_proc_doc TYPE zrk_cl_pur_req
      EXPORTING
        i_object_type = at_object_type
        i_object_id   = at_object_id.

  ENDMETHOD.


  METHOD zrk_if_proc_doc~reject_doc.

  ENDMETHOD.
ENDCLASS.
