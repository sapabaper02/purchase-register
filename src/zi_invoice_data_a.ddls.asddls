@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVOICE_DATA_A
  as select from ZI_INVOICE_DATA
{
  ProjectWbs,
  Wbs,
  FiscalYear,
  PostingPeriod,
  InvoiceNumber,
  InvoiceNumberItem,
  PurchaseInvoiceDate,
  JeType,
  JournalEntryNumber,
  GRNNumber,
  GRNPostingDate,
  Supplier,
  SupplierName,
  SupplierAddress,
  Material,
  MaterialDescription,
  MaterialType,
  MaterialTypeDescr,
  GRNItem,
  @Semantics.quantity.unitOfMeasure: 'GRNUoM'
  GRNQuantity,
  GRNUoM,
  @Semantics.quantity.unitOfMeasure: 'GRNUoM'
  InvoiceQuantity,
  UnitPrice,
  Freight,
  Pack,
  UnitRate,
  InvoiceItemAmount                                                                 as InvoiceItemAmount,
  InvoiceCurrency,
  IGST,
  SGST,
  CGST,
  cast(coalesce(IGST, 0) + coalesce(SGST, 0) + coalesce(CGST, 0) as abap.dec(17,2)) as TotalGST,
  TDS                                                                               as TDS,
  //    coalesce(IGST, 0) + coalesce(SGST, 0) + coalesce(CGST, 0) + coalesce(TDS, 0)  as TotalTax,
  //    coalesce(IGST, 0) + coalesce(SGST, 0) + coalesce(CGST, 0) + coalesce(InvoiceItemAmount, 0) as InvoiceTotal
  SupplierGSTNo,
  SupplierPANNo,
  SupplierRegion,
  SupplierDistrict,
  GRGLAccount,
  GRGLAccountName,
  TaxRate,
  TaxCode,
  CompanyCode,
  Plant,
  PurchaseOrderType,
  PurchaseOrder,
  Incoterms,
  PurchaseOrderDate,
  PurchaseRequisition,
  RequisitionDate,
  PaymentTerms,
  UserId,
  HSNSac,
  BankAccount,

  //Added On 03.12.2024
  MIROReversalNumber,
  MIROReversalDate,
  MIGOReversalNumber,
  MIGOReversalDate,
  SupplierINVRefNumber,
  SupplierINVRefDate,
  SearchTerm,
  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  OilConventionQty,
  WeightUnit,
  @Semantics.quantity.unitOfMeasure: 'GRNUoM'
  NetQty
}
