@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for sign update'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TDS_SIGN_UPDATE as select from ztds_sign_update
{
    key documentnumber as Documentnumber,
    companycode as Companycode,
    username as Username,
    base64 as Base64,
    status as Status
    
//    attachment,
//    mimetype,
//    filename
    
    

}
