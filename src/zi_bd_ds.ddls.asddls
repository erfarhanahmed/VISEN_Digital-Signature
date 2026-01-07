@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Billing Document DS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_BD_DS as select from I_BillingDocument as billhead
association of one to one  I_BillingDocumentItem as billitem on billitem.BillingDocument = billhead.BillingDocument
association to ZI_TDS_SIGN_UPDATE as signupdate on signupdate.Documentnumber = billhead.BillingDocument
//association to ZI_SIGNED_PDF as signedpdf on billhead.BillingDocument = signedpdf.billingdocument
 {
    key billhead.BillingDocument,
    billhead.BillingDocumentType,
    billhead.BillingDocumentDate,
    billhead.CreatedByUser,
    billhead.CreationDate,
    billhead.CompanyCode,
    billhead.SalesOrganization,
    billhead.DistributionChannel,
    billhead.Division,
//    billitem.Plant,
    
    case when signupdate.Status = 'X' then 'Signed'
    else 'Not-Signed' end as statussign,
    
    case when signupdate.Status = 'X' then ''
    else 'Sign-Now' end as NameSign,
    
    case when signupdate.Status = 'X' then ''
    else 'http://localhost:8100' end as URLSign
    
   
}
where 
//      ( billhead.BillingDocumentType = 'G2'
//     or billhead.BillingDocumentType = 'L2'
//     or billhead.BillingDocumentType = 'F2' )
//and 
billhead.AccountingDocument is not initial
//and billhead.CreatedByUser = $session.user //'CB9980000017'
//and billitem.BillingDocumentItem = '000010'
//group by billhead.BillingDocument,
//         billhead.BillingDocumentType,
//         billhead.BillingDocumentDate,
//         billhead.CreatedByUser,
//         billhead.CreationDate,
//         billhead.CompanyCode,
//         billhead.SalesOrganization,
//         billhead.SalesOrganization,
//         billhead.DistributionChannel,
//         billhead.Division,
//         billitem.Plant,
//         
//        
//    signedpdf.MimeType,
//    signedpdf.Filename 
