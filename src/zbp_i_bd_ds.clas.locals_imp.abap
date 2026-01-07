CLASS lhc_zi_bd_ds DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

    METHODS
      create_client_sign
        IMPORTING url_sign      TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

*  METHODS
*      create_client_localhost
*        IMPORTING lv_url_local_host      TYPE string
*        RETURNING VALUE(result) TYPE REF TO if_web_http_client
*        RAISING   cx_static_check.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bd_ds RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_bd_ds RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_bd_ds RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_bd_ds.

    METHODS bddigitalsignature FOR MODIFY
      IMPORTING keys FOR ACTION zi_bd_ds~bddigitalsignature RESULT result.
    METHODS externalmail FOR MODIFY
      IMPORTING keys FOR ACTION zi_bd_ds~externalmail RESULT result.

    METHODS internalmail FOR MODIFY
      IMPORTING keys FOR ACTION zi_bd_ds~internalmail RESULT result.

ENDCLASS.

CLASS lhc_zi_bd_ds IMPLEMENTATION.

  METHOD get_instance_features.



  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.

    READ TABLE keys INTO DATA(wa_key) INDEX 1.
    SELECT * FROM zi_bd_ds WHERE billingdocument = @wa_key-billingdocument
    INTO TABLE  @DATA(wa_billdoc).

    result = CORRESPONDING #( wa_billdoc ).

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD bddigitalsignature.

    TYPES : BEGIN OF ty_failmsg,
              code(20),
              lang(2),
              value    TYPE string,
            END OF ty_failmsg.

    TYPES : BEGIN OF ty_failresult,
              code(20),
              message      TYPE ty_failmsg,
              innererror   TYPE string,
              errordetails TYPE string,
            END OF ty_failresult.

    TYPES : BEGIN OF ty_dsfail,
              error TYPE ty_failresult,
            END OF ty_dsfail.

    DATA wa_dsfail TYPE ty_dsfail.

    DATA ls_record LIKE LINE OF reported-zi_bd_ds.

    DATA  : lv_bill           TYPE string,
            lv_bill_no        TYPE string,
            lv_item_id        TYPE i,
            lv_url            TYPE string,
            lv_url_sign       TYPE string,
            lv_url_local_host TYPE string.

    DATA : lv_split1 TYPE string,
           lv_split2 TYPE string,
           lv_base64 TYPE string,
           lv_split4 TYPE string,
           lv_split5 TYPE string,
           lv_split6 TYPE string.

    DATA : lv_doc TYPE string.


    DATA : lv_xstring TYPE xstring.

    DATA : lv_xdecode TYPE string.

    DATA : p_file(255) TYPE c.

    TYPES : BEGIN OF downlod,
              lv_down TYPE string,
            END OF downlod.
    DATA : wa_ztds_status TYPE ztds_status.
    DATA : wa_ztds_sign_status TYPE ztds_sign_update.


    DATA : it_down TYPE STANDARD TABLE OF downlod.

    READ ENTITIES OF zi_bd_ds IN LOCAL MODE
    ENTITY zi_bd_ds
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(repoerted_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.
    CHECK sy-subrc = 0.
*    SELECT SINGLE billingdocument, billingdocumenttype FROM zi_bd_ds WHERE billingdocument = @wa_key-billingdocument
*    INTO @DATA(wa_billdoc).
    SELECT SINGLE * FROM zi_bd_ds WHERE billingdocument = @wa_key-billingdocument
      INTO @DATA(wa_billdoc).

    IF wa_billdoc-createdbyuser = sy-uname.

      CHECK wa_billdoc IS NOT INITIAL.
      lv_bill = 'BILLING_DOCUMENT'.

      lv_doc = wa_billdoc-billingdocument.
      lv_bill_no = |{ lv_doc ALPHA = IN }|.

      lv_item_id = 1.
      IF sy-sysid = 'CBR'.
        lv_url = 'https://my409820.s4hana.cloud.sap:443/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/GetPDF?BillingDocument='.
      ELSEIF sy-sysid = 'CM4'.
        lv_url = 'https://my410646.s4hana.cloud.sap:443/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/GetPDF?BillingDocument='.
      ELSEIF sy-sysid = 'CU4'.
        lv_url = 'https://my411244.s4hana.cloud.sap:443/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/GetPDF?BillingDocument='.
      ENDIF.
*    lv_url_local_host = 'http://localhost:8100'.
      " lv_url_sign = 'http://localhost:8000/convert'.
      " lv_url_sign = 'http://127.0.0.1:8000/convert'.
      DATA : lv_con1 TYPE string,
             lv_con2 TYPE string.
      lv_con1 = `'`.
      lv_con2 = `'`.
      DATA : lv_con3 TYPE string VALUE  `;`.
      DATA : lv_con4 TYPE string VALUE `.pdf`.

      CONCATENATE lv_url lv_con1 lv_bill_no lv_con2 INTO lv_url.
      CONDENSE lv_url NO-GAPS.

      "************************GET METHOD***************************************************
      TRY.
          DATA(client) = create_client( lv_url ).
        CATCH cx_static_check.
      ENDTRY.
      DATA(req) = client->get_http_request(  ).

      req->set_authorization_basic(
        EXPORTING
          i_username = 'DS_BILL_DOC'
          i_password = 'ADRrKjkFmNFb#JwlZzcBvySFgE2abwFYWgZWSGLb'
*  RECEIVING
*    r_value    =
      ).
*CATCH cx_web_message_error.

      req->set_header_fields(  VALUE #(
  (  name = 'config_authType' value = 'Basic' )
  (  name = 'Accept' value = 'application/json' )
  ) ).

      TRY.

          DATA(lv_response) = client->execute( i_method = if_web_http_client=>get ).  "i_method  =
          DATA(json_response) = lv_response->get_text( ).
          DATA(lv_binary) = lv_response->get_binary( ).
          DATA(lv_text) = lv_response->get_text(  ).
          DATA(stat) = lv_response->get_status(  ).
        CATCH: cx_web_http_client_error.
      ENDTRY.

      IF stat-code <> 200.
        /ui2/cl_json=>deserialize( EXPORTING json = json_response
                                   pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = wa_dsfail ).


        DATA(lv_msg) = me->new_message(
        id       = 'Z_MESSAGE_DIGISIGN'
        number   = 004
        severity = ms-error
        v1       = wa_dsfail-error-message-value
        ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.

      ENDIF.

      CHECK stat-code = 200.

      SPLIT json_response AT '"BillingDocumentBinary":"' INTO lv_split1 lv_split2.
      SPLIT lv_split2 AT '"' INTO lv_base64 lv_split4.
      CONDENSE lv_base64 NO-GAPS.

      "************************POST METHOD***************************************************
*    CHECK lv_base64 IS NOT INITIAL.

      REPLACE ALL OCCURRENCES OF '\n' IN lv_base64 WITH ''.
      REPLACE ALL OCCURRENCES OF '\' IN lv_base64 WITH ''.
      CLEAR : wa_ztds_status.

      wa_ztds_status-documentnumber = lv_bill_no.
      wa_ztds_status-companycode = wa_billdoc-companycode.
      wa_ztds_status-username = sy-uname.
      wa_ztds_status-base64 = lv_base64.
      MODIFY ztds_status FROM @wa_ztds_status.

      SELECT * FROM ztds_sign_update WHERE status = 'X' AND username = @sy-uname
      INTO TABLE @DATA(it_sign_status).

      IF it_sign_status IS NOT INITIAL.

        SELECT * FROM ztds_status FOR ALL ENTRIES IN @it_sign_status
        WHERE documentnumber = @it_sign_status-documentnumber
        INTO TABLE @DATA(it_status).

        LOOP AT it_status INTO DATA(wa_status).
          DELETE ztds_status FROM @wa_status.
        ENDLOOP.

      ENDIF.

    ELSE.

      DATA(lv_msg1) = me->new_message(
          id       = 'Z_MESSAGE_DIGISIGN'
          number   = 005
          severity = ms-error
*        v1       = wa_dsfail-error-message-value
          ).

      ls_record-%msg = lv_msg1.
      APPEND ls_record TO reported-zi_bd_ds.

    ENDIF.

    READ ENTITIES OF zi_bd_ds IN LOCAL MODE
      ENTITY zi_bd_ds
       ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(resultdata).

    result = VALUE #( FOR wa_resultdata IN resultdata
                      ( %tky = wa_resultdata-%tky %param = wa_resultdata ) ).


  ENDMETHOD.


  METHOD create_client.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD.

  METHOD create_client_sign.
    DATA(dest_sign) = cl_http_destination_provider=>create_by_url( url_sign ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest_sign ).
  ENDMETHOD.

*  METHOD create_client_localhost.
*    DATA(dest_localhost) = cl_http_destination_provider=>create_by_url( lv_url_local_host ).
*    result = cl_web_http_client_manager=>create_by_http_destination( dest_localhost ).
*  ENDMETHOD.

  METHOD externalmail.

**********************************************************************
** Data Definition
**********************************************************************
    DATA: errormsg  TYPE string,
          ls_record LIKE LINE OF reported-zi_bd_ds.
**********************************************************************
    READ ENTITIES OF zi_bd_ds IN LOCAL MODE
      ENTITY zi_bd_ds
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_data)
      FAILED DATA(failed_data)
      REPORTED DATA(reported_data).

    READ TABLE keys INTO DATA(wa_key) INDEX 1.

    SELECT *
    FROM i_addressemailaddress_2 WITH PRIVILEGED ACCESS
    INTO TABLE @DATA(it_test).

    SELECT SINGLE in_electronicdocinvcrefnmbr,in_edoceinvcewbillnmbr
    FROM i_in_electronicdocinvoice
    WHERE electronicdocsourcekey = @wa_key-billingdocument
    INTO @DATA(elecdoc).

    IF elecdoc-in_edoceinvcewbillnmbr IS NOT INITIAL OR elecdoc-in_electronicdocinvcrefnmbr IS NOT INITIAL.

      SELECT SINGLE senderid,recipientid,cc,documentreferenceid,soldtopartydetails~customername,_emailaddress~emailaddress
      FROM i_billingdocumentbasic                                     AS header



      LEFT OUTER JOIN zi_sd_address                                   AS soldtopartydetails       ON soldtopartydetails~customer = header~soldtoparty
      LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS  AS _emailaddress            ON _emailaddress~addressid       = soldtopartydetails~addressid
                                                                                                  AND _emailaddress~addresspersonid = soldtopartydetails~addresspersonid
      LEFT OUTER JOIN zi_emailtable                                   AS _emailtab                ON header~salesorganization    = _emailtab~salesorganization
                                                                                                  AND header~distributionchannel  = _emailtab~distributionchannel
                                                                                                  AND header~division             = _emailtab~division
      WHERE header~billingdocument = @wa_key-billingdocument
      AND ( _emailtab~distributionchannel IS NOT INITIAL
      AND   _emailtab~division IS NOT INITIAL
      AND   _emailtab~salesorganization IS NOT INITIAL )
      INTO @DATA(wa_email).



      zcl_email_trigger=>emailtrigger(
        EXPORTING
          billingdocument = wa_key-billingdocument
          email_to        = wa_email-emailaddress
          senderid        = wa_email-senderid
*    email_cc        =
          lv_content      = | <p>Dear Customer,<br>Greetings from Visen Industries Limited.<br>Attached is the GST invoice for your perusal.</p><br><p>Best Regards,<br>Visen Industries Limited</p>|
          lv_subject      = | GST invoice for { wa_email-customername } : { wa_email-documentreferenceid } |
    RECEIVING
      r_val           = errormsg
      ).

      IF errormsg IS NOT INITIAL.
        DATA(lv_msg) = me->new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text     = errormsg
                       ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.
      ELSE.

        lv_msg = me->new_message_with_text(
                         severity = if_abap_behv_message=>severity-success
                         text     = 'Email Sent Successfully'
                       ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.

      ENDIF.

    ELSE.

      lv_msg = me->new_message_with_text(
                       severity = if_abap_behv_message=>severity-error
                       text     = | IRN or Eway Bill Not Generated |
                     ).

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zi_bd_ds.

    ENDIF.

  ENDMETHOD.

  METHOD internalmail.
**********************************************************************
** Data Definition
**********************************************************************
    DATA: errormsg  TYPE string,
          ls_record LIKE LINE OF reported-zi_bd_ds.
**********************************************************************
    READ ENTITIES OF zi_bd_ds IN LOCAL MODE
      ENTITY zi_bd_ds
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_data)
      FAILED DATA(failed_data)
      REPORTED DATA(reported_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.

    SELECT SINGLE in_electronicdocinvcrefnmbr,in_edoceinvcewbillnmbr
    FROM i_in_electronicdocinvoice
    WHERE electronicdocsourcekey = @wa_key-billingdocument
    INTO @DATA(elecdoc).

*    IF elecdoc-in_edoceinvcewbillnmbr IS NOT INITIAL OR elecdoc-in_electronicdocinvcrefnmbr IS NOT INITIAL.
      SELECT SINGLE senderid,recipientid,cc,documentreferenceid,soldtopartydetails~customername,
      separtnerdetails~defaultemailaddress AS seemail, zspartnerdetails~defaultemailaddress AS zsemail,
      zcpartnerdetails~defaultemailaddress AS zcemail,vepartnerdetails~defaultemailaddress AS veemail
      FROM i_billingdocumentbasic    AS header

      LEFT JOIN i_billingdocumentpartnerbasic                         AS separtner                ON separtner~billingdocument   = header~billingdocument
                                                                                                  AND separtner~partnerfunction   = 'SE'

      LEFT JOIN i_billingdocumentpartnerbasic                         AS zspartner                ON zspartner~billingdocument   = header~billingdocument
                                                                                                  AND zspartner~partnerfunction   = 'ZS'

      LEFT JOIN i_billingdocumentpartnerbasic                         AS zcpartner                ON zcpartner~billingdocument   = header~billingdocument
                                                                                                  AND zcpartner~partnerfunction   = 'ZC'

      LEFT JOIN i_billingdocumentpartnerbasic                         AS vepartner                ON vepartner~billingdocument   = header~billingdocument
                                                                                                  AND vepartner~partnerfunction   = 'VE'

      LEFT JOIN i_businesspartner                                     AS separtneruuid            ON separtneruuid~businesspartner    = separtner~referencebusinesspartner
      LEFT JOIN i_businesspartner                                     AS zspartneruuid            ON zspartneruuid~businesspartner    = zspartner~referencebusinesspartner
      LEFT JOIN i_businesspartner                                     AS zcpartneruuid            ON zcpartneruuid~businesspartner    = zcpartner~referencebusinesspartner
      LEFT JOIN i_businesspartner                                     AS vepartneruuid            ON vepartneruuid~businesspartner    = vepartner~referencebusinesspartner

      LEFT JOIN i_workplaceaddress                                    AS separtnerdetails         ON separtnerdetails~businesspartneruuid  = separtneruuid~businesspartneruuid
      LEFT JOIN i_workplaceaddress                                    AS zspartnerdetails         ON zspartnerdetails~businesspartneruuid  = zspartneruuid~businesspartneruuid
      LEFT JOIN i_workplaceaddress                                    AS zcpartnerdetails         ON zcpartnerdetails~businesspartneruuid  = zcpartneruuid~businesspartneruuid
      LEFT JOIN i_workplaceaddress                                    AS vepartnerdetails         ON vepartnerdetails~businesspartneruuid  = vepartneruuid~businesspartneruuid

      LEFT JOIN zi_sd_address                                         AS soldtopartydetails       ON soldtopartydetails~customer  = header~soldtoparty
      LEFT OUTER JOIN zi_emailtable                                   AS _emailtab                ON header~salesorganization     = _emailtab~salesorganization
                                                                                                  AND header~distributionchannel  = _emailtab~distributionchannel
                                                                                                  AND header~division             = _emailtab~division
      WHERE header~billingdocument = @wa_key-billingdocument
      AND ( _emailtab~distributionchannel IS NOT INITIAL
      AND   _emailtab~division IS NOT INITIAL
      AND   _emailtab~salesorganization IS NOT INITIAL )
      INTO @DATA(wa_email).



      zcl_email_trigger=>emailtrigger(
        EXPORTING
          billingdocument = wa_key-billingdocument
          email_to        = wa_email-recipientid
          senderid        = wa_email-senderid
          email_cc1       = wa_email-seemail
          email_cc2       = wa_email-zcemail
          email_cc3       = wa_email-zsemail
          email_cc4       = wa_email-veemail
          email_cc5       = wa_email-cc
          lv_content      = | <p>Dear Customer,<br>Greetings from Visen Industries Limited.<br>Attached is the GST invoice for your perusal.</p><br><p>Best Regards,<br>Visen Industries Limited</p>|
          lv_subject      = | GST invoice for { wa_email-customername } : { wa_email-documentreferenceid } |
    RECEIVING
      r_val           = errormsg
      ).

      IF errormsg IS NOT INITIAL.
        DATA(lv_msg) = me->new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                         text     = errormsg
                       ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.

      ELSE.

        lv_msg = me->new_message_with_text(
                         severity = if_abap_behv_message=>severity-success
                         text     = 'Email Sent Successfully'
                       ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.

      ENDIF.

*    ELSE.
*
*
*
*      lv_msg = me->new_message_with_text(
*                       severity = if_abap_behv_message=>severity-error
*                       text     = | IRN or Eway Bill Not Generated |
*                     ).
*
*      ls_record-%msg = lv_msg.
*      APPEND ls_record TO reported-zi_bd_ds.
*
*    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_bd_ds DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_bd_ds IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
