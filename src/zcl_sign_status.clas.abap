CLASS zcl_sign_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SIGN_STATUS IMPLEMENTATION.


METHOD if_sadl_exit_calc_element_read~calculate.

DATA : it_sign_status TYPE STANDARD TABLE OF zc_bd_ds WITH DEFAULT KEY.
       it_sign_status = CORRESPONDING #( it_original_data ).

       SELECT * FROM ztds_sign_update WHERE status = 'X' INTO TABLE @data(it_status).
      " ENDSELECT.

       LOOP AT it_sign_status ASSIGNING FIELD-SYMBOL(<fs_sign_staus>).
*       if wa_status-documentnumber eq '0090000120'.
*        <fs_sign_staus>-sign_status = 'Signed'.
*        ELSE.
*     READ TABLE it_status INTO DATA(wa_status) WITH KEY documentnumber = <fs_sign_staus>-BillingDocument.
*     if sy-subrc = 0.
*     <fs_sign_staus>-sign_status = 'Signed'.
*     else.
*       <fs_sign_staus>-sign_status = 'Not-Signed'.
*       ENDIF.
       ENDLOOP.
       ct_calculated_data = CORRESPONDING #( it_sign_status ).
       ENDMETHOD.


METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
