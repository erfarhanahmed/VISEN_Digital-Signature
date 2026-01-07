@AbapCatalog.sqlViewName: 'ZI_BD_VH'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for BDType'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
@ObjectModel.resultSet.sizeCategory: #XS

define view ZI_BD_DS_VH_BDT as select from I_BillingDocumentBasic as Billingheader
{
    key Billingheader.BillingDocumentType as BillingDocumentType

    
}

//where ( Billingheader.BillingDocumentType = 'G2' and Billingheader.BillingDocumentType = 'L2' and Billingheader.BillingDocumentType = 'F2' )
group by Billingheader.BillingDocumentType

