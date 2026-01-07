@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for sign update'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_TDS_SIGN_UPDATE as projection on ZI_TDS_SIGN_UPDATE
{
    key Documentnumber,
    Companycode,
    Username,
    Base64,
    Status
    
}

