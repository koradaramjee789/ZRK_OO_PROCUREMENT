INTERFACE zrk_if_proc_doc
  PUBLIC .

  METHODS :
    get_doc_details
      EXPORTING e_object_det TYPE zrk_obj_det,
    get_instance
      RETURNING VALUE(ro_proc_doc) TYPE REF TO zrk_cl_proc_doc,
    send_for_approval,
    approve_doc,
    reject_doc,
    send_to_supplier.

ENDINTERFACE.
