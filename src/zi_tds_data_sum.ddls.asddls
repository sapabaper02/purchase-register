@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TDS Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TDS_DATA_SUM
  as select from I_JournalEntryItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  Ledger,
  TransactionTypeDetermination,
  @Semantics.amount.currencyCode:'TransactionCurrency'
  sum(AmountInTransactionCurrency) as AmountInTransactionCurrency,
  TransactionCurrency
}
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  Ledger,
  TransactionTypeDetermination,
  TransactionCurrency
