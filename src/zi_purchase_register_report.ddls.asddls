@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Root CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PURCHASE_REGISTER_REPORT
  as select from ZI_INVOICE_DATA_FINAL
{
  key FiscalYear,
  key PostingPeriod,
  key InvoiceNumber,
  key InvoiceNumberItem,
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
      InvoiceCurrency,
      InvoiceItemAmount,
      IGST,
      SGST,
      CGST,
      TotalGST,
      TDS,
      TotalTax,
      InvoiceTotal,
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
