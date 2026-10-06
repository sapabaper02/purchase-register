@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Data Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FREIGHT_DATA_SUM
  as select from ZI_FREIGHT_DATA
{
  key SupplierInvoice,
  key FiscalYear,
      PurchaseOrder,
      PurchaseOrderItem,
      DocumentCurrency,
      ConditionType,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      sum(ItemAmount) as Amount
}
group by
  SupplierInvoice,
  FiscalYear,
  PurchaseOrder,
  PurchaseOrderItem,
  DocumentCurrency,
  ConditionType
