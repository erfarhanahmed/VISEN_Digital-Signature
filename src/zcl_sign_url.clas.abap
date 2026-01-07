CLASS zcl_sign_url DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SIGN_URL IMPLEMENTATION.


METHOD if_sadl_exit_calc_element_read~calculate.
data : it_url_status TYPE STANDARD TABLE OF zc_bd_ds WITH DEFAULT KEY.
              it_url_status = CORRESPONDING #( it_original_data ).

*              select *
*              from ZTDS_SIGNED_PDF
*              for alL ENTRIES IN @it_url_status
*              where billingdocument = @it_url_status-BillingDocument
*              into taBLE @DATA(it_hidesignurl).
*
*
*              LOOP AT it_url_status ASSIGNING FIELD-SYMBOL(<ls_url_status>).
*              read tabLE it_hidesignurl into data(wa_hidesignurl) with key billingdocument = <ls_url_status>-BillingDocument.
*              if wa_hidesignurl-attachment is not initial.
*              <ls_url_status>-name = ''.
*              <ls_url_status>-url = ''.
*              else .
*              <ls_url_status>-name = 'http://localhost:8100'.
*              <ls_url_status>-url = 'Sign Now'.
*              endif.
*              ENDLOOP.

               LOOP AT it_url_status ASSIGNING FIELD-SYMBOL(<ls_url_status>).

*               if <ls_url_status>-sign_status = 'Signed'.
*               <ls_url_status>-name = ''.
*               <ls_url_status>-url = ''.
*               else.
*               <ls_url_status>-name = 'http://localhost:8100'.
*               <ls_url_status>-url = 'Sign Now'.
*               ENDIF.

               ENDLOOP.


              ct_calculated_data = CORRESPONDING #( it_url_status ).
ENDMETHOD.


METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
