@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for bd ds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_BD_DS
  as projection on ZI_BD_DS
{

      @UI.facet: [{ id: 'DS',
                    purpose: #STANDARD,
                    type: #IDENTIFICATION_REFERENCE,
                    label: 'Sign Digitally',
                    position: 01 }]

      @UI: { lineItem:      [{ position: 10, label: 'Document Number' },
                             { type: #FOR_ACTION, dataAction: 'BDDigitalSignature', label: 'Sign Digitally',  position: 10 },
                             { type: #FOR_ACTION, dataAction: 'InternalMail', label: 'Internal Mail',  position: 20 },
                             { type: #FOR_ACTION, dataAction: 'ExternalMail', label: 'External Mail',  position: 30 }],
            identification: [{ position: 10, label: 'Document Number'  },
                             { type: #FOR_ACTION, dataAction: 'BDDigitalSignature', label: 'Sign Digitally',  position: 10 },
                             { type: #FOR_ACTION, dataAction: 'InternalMail', label: 'Internal Mail',  position: 20 },
                             { type: #FOR_ACTION, dataAction: 'ExternalMail', label: 'External Mail',  position: 30 }],
            selectionField: [{ position: 10 }]
                    }
      @EndUserText.label: 'Document Number'
  key BillingDocument,
      @EndUserText.label: 'Document Type'
      @Consumption.valueHelpDefinition: [{entity: {element: 'BillingDocumentType' , name: 'ZI_BD_DS_VH_BDT' }}]
      BillingDocumentType,

      @UI: { lineItem: [{ position: 45, label: 'Document Date' }],
                identification: [{ position: 45, label: 'Document Date'  }],
                selectionField: [{ position: 45 }]}
      @Consumption.filter.mandatory: true
      BillingDocumentDate,
      @Consumption.filter.mandatory: true
      @Consumption.valueHelpDefinition: [{entity: {element: 'createdby' , name: 'ZI_SH_CREATEDBY' }}]
      @UI: { lineItem: [{ position: 50, label: 'Created User' }],
                    identification: [{ position: 50, label: 'Created User'  }]
                    ,selectionField: [{ position: 45 }]
                    }
      CreatedByUser,
      CreationDate,
      CompanyCode,
      SalesOrganization,
      DistributionChannel,
      Division,
      //    @EndUserText.label: 'Plant'
      //    Plant,
      @EndUserText.label: 'Sign Status'
      statussign,
      @EndUserText.label: 'Sign URL'
      @UI.lineItem: [ { label: 'Sign Now', position: 30, type: #WITH_URL, url: 'URLSign'   //, url: 'name'   -- Reference to element
      } ]
      @UI.identification: [{ label: 'Sign Now', position: 30, type: #WITH_URL, url: 'URLSign'  //, url: 'name'
      }]
      NameSign,

      URLSign

      //    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_SIGN_STATUS'
      ////    @ObjectModel.filter.enabled: true
      //    @EndUserText.label: 'Sign Status'
      //    virtual sign_status : abap.char( 10 ),



      //    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_SIGN_URL'
      //    virtual name : abap.char(25),
      //    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_SIGN_URL'
      //    @UI.lineItem: [ { label: 'Sign Now', position: 03, type: #WITH_URL, url: 'name'   -- Reference to element
      //    } ]
      //    @UI.identification: [{ label: 'Sign Now', position: 03, type: #WITH_URL, url: 'name' }]
      //    virtual url : abap.char(10),
      //
      //    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_SIGN_STATUS'
      //    @UI: { lineItem: [{ position: 16, label: 'Sign_Status' }],
      //              identification: [{ position: 16, label: 'Sign_Status'  }]}
      //    virtual sign_status : abap.char(10)
}
