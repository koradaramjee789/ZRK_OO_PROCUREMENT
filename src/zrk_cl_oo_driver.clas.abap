CLASS zrk_cl_oo_driver DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZRK_CL_OO_DRIVER IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  out->write( 'Procurement Approval Application.' ).

  DATA(lo_proc_doc_base) = NEW zrk_cl_proc_doc(
    i_object_type = 'PUR_REQ'
    i_object_id   = 'PR10000002'
  ).


  lo_proc_doc_base = lo_proc_doc_base->zrk_if_proc_doc~get_instance( ).
  DATA(lo_proc_doc) = lo_proc_doc_base->zrk_if_proc_doc~get_instance( ).
  lo_proc_doc_base->zrk_if_proc_doc~get_doc_details(
    IMPORTING
      e_object_det = DATA(ls_doc_det)
  ).

  out->write( ls_doc_det ).

  ENDMETHOD.
ENDCLASS.
