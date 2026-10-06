@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FREIGHT_DATA
  as select from I_SuplrInvcItemPurOrdRefAPI01
{
  key SupplierInvoice,
  key FiscalYear,
      PurchaseOrder,
      PurchaseOrderItem,
      DocumentCurrency,
      substring(SuplrInvcDeliveryCostCndnType, 1 , 3) as ConditionType,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      sum(SupplierInvoiceItemAmount) as ItemAmount
}
where
      ReferenceDocument             =  ''
  and SuplrInvcDeliveryCostCndnType <> ''
group by
  SupplierInvoice,
  FiscalYear,
  PurchaseOrder,
  PurchaseOrderItem,
  DocumentCurrency,
  SuplrInvcDeliveryCostCndnType
