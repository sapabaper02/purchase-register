@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVOICE_DATA
  as select from    I_SuplrInvcItemPurOrdRefAPI01  as InvoiceItem
    inner join      I_SupplierInvoiceAPI01         as InvoiceHeader           on  InvoiceHeader.SupplierInvoice = InvoiceItem.SupplierInvoice
                                                                              and InvoiceHeader.FiscalYear      = InvoiceItem.FiscalYear
  //                                                                              and InvoiceHeader.ReverseDocument = '' //Commented On 02.12.2024
    left outer join I_Supplier                     as Supplier                on Supplier.Supplier = InvoiceHeader.InvoicingParty
    left outer join I_SuplrInvcItmAcctAssgmtAPI01  as ItemAcctAss             on  ItemAcctAss.SupplierInvoice     = InvoiceItem.SupplierInvoice
                                                                              and ItemAcctAss.SupplierInvoiceItem = InvoiceItem.SupplierInvoiceItem
    left outer join I_MaterialDocumentItem_2       as MatdocItem              on  MatdocItem.MaterialDocument     = InvoiceItem.ReferenceDocument
                                                                              and MatdocItem.MaterialDocumentItem = InvoiceItem.ReferenceDocumentItem
                                                                              and MatdocItem.MaterialDocumentYear = InvoiceItem.ReferenceDocumentFiscalYear
    left outer join I_Product                      as Product                 on Product.Product = InvoiceItem.PurchaseOrderItemMaterial
    left outer join I_ProductPlantIntlTrd          as ProductPlantIntlTrd     on  ProductPlantIntlTrd.Product = InvoiceItem.PurchaseOrderItemMaterial
                                                                              and ProductPlantIntlTrd.Plant   = InvoiceItem.Plant
    left outer join I_SupplierInvoiceTaxAPI01      as Tax                     on  Tax.SupplierInvoice = InvoiceItem.SupplierInvoice
                                                                              and Tax.FiscalYear      = InvoiceItem.FiscalYear
                                                                              and Tax.TaxCode         = InvoiceItem.TaxCode


  //          and Tax.TaxBaseAmountInTransCrcy = InvoiceItem.SupplierInvoiceItemAmount
    left outer join I_PurchaseOrderItemAPI01       as OrderItem               on  OrderItem.PurchaseOrder     = InvoiceItem.PurchaseOrder
                                                                              and OrderItem.PurchaseOrderItem = InvoiceItem.PurchaseOrderItem
    left outer join I_PurOrdAccountAssignmentAPI01 as POItemAcctAss           on  POItemAcctAss.PurchaseOrder     = InvoiceItem.PurchaseOrder
                                                                              and POItemAcctAss.PurchaseOrderItem = InvoiceItem.PurchaseOrderItem
    left outer join I_EnterpriseProjectElement_2   as Wbs                     on Wbs.WBSElementInternalID = POItemAcctAss.WBSElementInternalID_2
    left outer join I_EnterpriseProject            as Project                 on Project.ProjectInternalID = Wbs.ProjectInternalID
    left outer join I_PurchaseRequisitionItemAPI01 as PurchaseRequisitionItem on  PurchaseRequisitionItem.PurchaseRequisition     = OrderItem.PurchaseRequisition
                                                                              and PurchaseRequisitionItem.PurchaseRequisitionItem = OrderItem.PurchaseRequisitionItem
    left outer join I_JournalEntry                 as InvAccountingDoc        on  InvAccountingDoc.ReferenceDocumentType     = 'RMRP'
                                                                              and InvAccountingDoc.OriginalReferenceDocument = InvoiceHeader.SupplierInvoiceWthnFiscalYear
                                                                              and InvAccountingDoc.CompanyCode               = InvoiceHeader.CompanyCode
                                                                              and InvAccountingDoc.AccountingDocumentType    = 'RE'
  //    left outer join I_OperationalAcctgDocItem      as OperationalAccItem      on  OperationalAccItem.CompanyCode        = InvAccountingDoc.CompanyCode
  //                                                                              and OperationalAccItem.AccountingDocument = InvAccountingDoc.AccountingDocument
  //                                                                              and OperationalAccItem.FiscalYear         = InvAccountingDoc.FiscalYear //and OperationalAccItem.AccountingDocumentItem = InvAccountingDoc.Accountingd and PostingKey = '40'





    left outer join I_JournalEntryItem             as WithTax                 on  WithTax.AccountingDocument           = InvAccountingDoc.AccountingDocument
                                                                              and WithTax.FiscalYear                   = InvAccountingDoc.FiscalYear
                                                                              and WithTax.CompanyCode                  = InvAccountingDoc.CompanyCode
                                                                              and WithTax.Ledger                       = '0L'
                                                                              and WithTax.TransactionTypeDetermination = 'WIT'

  //Added On 07.01.2025
  //    left outer join ZI_TDS_DATA_SUM                as WithTax                 on  WithTax.AccountingDocument           = InvAccountingDoc.AccountingDocument
  //                                                                              and WithTax.FiscalYear                   = InvAccountingDoc.FiscalYear
  //                                                                              and WithTax.CompanyCode                  = InvAccountingDoc.CompanyCode
  //                                                                              and WithTax.Ledger                       = '0L'
  //                                                                              and WithTax.TransactionTypeDetermination = 'WIT'
    left outer join I_JournalEntry                 as GRNAccountingDoc        on  GRNAccountingDoc.ReferenceDocumentType     = 'MKPF'
                                                                              and GRNAccountingDoc.OriginalReferenceDocument = concat(
      MatdocItem.MaterialDocument, MatdocItem.MaterialDocumentYear
    )
                                                                              and GRNAccountingDoc.CompanyCode               = MatdocItem.CompanyCode
                                                                              and GRNAccountingDoc.AccountingDocumentType    = 'WE'
    left outer join I_JournalEntryItem             as GRNAccountingDocItem    on  GRNAccountingDocItem.AccountingDocument           = GRNAccountingDoc.AccountingDocument
                                                                              and GRNAccountingDocItem.FiscalYear                   = GRNAccountingDoc.FiscalYear
                                                                              and GRNAccountingDocItem.CompanyCode                  = GRNAccountingDoc.CompanyCode
                                                                              and GRNAccountingDocItem.Ledger                       = '0L'
                                                                              and GRNAccountingDocItem.TransactionTypeDetermination = 'BSX'
                                                                              and GRNAccountingDocItem.PurchasingDocument           = OrderItem.PurchaseOrder
                                                                              and GRNAccountingDocItem.PurchasingDocumentItem       = OrderItem.PurchaseOrderItem
    left outer join ZI_FREIGHT_DATA_SUM            as Freight                 on  Freight.SupplierInvoice   = InvoiceItem.SupplierInvoice
                                                                              and Freight.PurchaseOrder     = InvoiceItem.PurchaseOrder
                                                                              and Freight.PurchaseOrderItem = InvoiceItem.PurchaseOrderItem
                                                                              and Freight.ConditionType     = 'ZFR'
    left outer join ZI_FREIGHT_DATA_SUM            as Pack                    on  Freight.SupplierInvoice   = InvoiceItem.SupplierInvoice
                                                                              and Freight.PurchaseOrder     = InvoiceItem.PurchaseOrder
                                                                              and Freight.PurchaseOrderItem = InvoiceItem.PurchaseOrderItem
                                                                              and Pack.ConditionType        = 'ZPF'
  //Added On 03.12.2024
    left outer join I_MaterialDocumentItem_2       as MatdocItem_Reversal     on  MatdocItem_Reversal.ReversedMaterialDocument     = InvoiceItem.ReferenceDocument
                                                                              and MatdocItem_Reversal.ReversedMaterialDocumentItem = InvoiceItem.ReferenceDocumentItem
                                                                              and MatdocItem_Reversal.ReversedMaterialDocumentYear = InvoiceItem.ReferenceDocumentFiscalYear

{
  key InvoiceItem.SupplierInvoice                                                          as InvoiceNumber,
  key InvoiceItem.FiscalYear                                                               as FiscalYear,
  key InvoiceItem.SupplierInvoiceItem                                                      as InvoiceNumberItem,
      InvoiceHeader.CompanyCode                                                            as CompanyCode,
      InvoiceHeader.SupplierInvoiceWthnFiscalYear                                          as InvoiceFiscalYear,
      InvoiceHeader.DocumentDate                                                           as DocumentDate,
      InvoiceHeader.PostingDate                                                            as PurchaseInvoiceDate,
      InvoiceHeader.SupplierInvoiceIDByInvcgParty                                          as InvoiceID,
      InvoiceHeader.InvoicingParty                                                         as Supplier,
      InvoiceHeader.DocumentHeaderText                                                     as HeaderText,
      InvoiceHeader.SupplierPostingLineItemText                                            as ItemText,
      InvoiceHeader.PaymentTerms                                                           as PaymentTerms,
      InvoiceHeader.DocumentCurrency                                                       as InvoiceCurrency,
      InvoiceHeader.CreatedByUser                                                          as UserId,
      Supplier.SupplierName                                                                as SupplierName,
      Supplier.BPAddrStreetName                                                            as SupplierAddress,
      Supplier.TaxNumber3                                                                  as SupplierGSTNo,
      Supplier.BusinessPartnerPanNumber                                                    as SupplierPANNo,
      Supplier.DistrictName                                                                as SupplierDistrict,
      Supplier.Region                                                                      as SupplierRegion,
      //      Supplier._SupplierBankDetails.BankAccount                       as BankAccount,
      InvoiceItem.PurchaseOrder                                                            as PurchaseOrder,
      InvoiceItem.PurchaseOrderItem                                                        as PurchaseOrderItem,
      InvoiceItem.ReferenceDocument                                                        as GRNNumber,
      InvoiceItem.ReferenceDocumentItem                                                    as GRNItem,
      InvoiceItem.ReferenceDocumentFiscalYear                                              as GRNFiscalYear,
      InvoiceItem.Plant                                                                    as Plant,
      InvoiceItem.PurchaseOrderItemMaterial                                                as Material,
      @Semantics.quantity.unitOfMeasure: 'InvoiceUoM'
      InvoiceItem.QuantityInPurchaseOrderUnit                                              as InvoiceQuantity,
      InvoiceItem.PurchaseOrderQuantityUnit                                                as InvoiceUoM,
      cast(InvoiceItem.SupplierInvoiceItemAmount as abap.dec(17,2))                        as InvoiceItemAmount,

      ItemAcctAss.GLAccount                                                                as GLCode,

      Wbs.ProjectElement                                                                   as Wbs,
      Wbs.ProjectElementDescription                                                        as WbsDescription,

      Project.ProjectDescription                                                           as ProjectDescription,
      Project.Project                                                                      as ProjectWbs,

      MatdocItem.PostingDate                                                               as GRNPostingDate,
      @Semantics.quantity.unitOfMeasure: 'GRNUoM'
      MatdocItem.QuantityInEntryUnit                                                       as GRNQuantity,
      MatdocItem.EntryUnit                                                                 as GRNUoM,

      Product._Text[ Language = 'E' ].ProductName                                          as MaterialDescription,
      Product.ProductType                                                                  as MaterialType,
      Product._ProductTypeName[ Language = 'E' ].MaterialTypeName                          as MaterialTypeDescr,
      //      Product._ESHProductPlant.ConsumptionTaxCtrlCode            as HSNCode,
      /* Associations */
      @Semantics.amount.currencyCode: 'InvoiceCurrency'
      Tax.TaxAmount                                                                        as TaxAmount,
      Tax.TaxCode                                                                          as TaxCode,
      case Tax.TaxCode
            when 'IA'
                then '0%'
            when 'IB'
                then '3%'
            when 'IC'
                then '5%'
            when 'ID'
                then '12%'
            when 'IE'
                then '18%'
            when 'IF'
                then '28%'
            when 'IG'
                then '0%'
            when 'IH'
                then '3%'
            when 'II'
                then '5%'
            when 'IJ'
                then '12%'
            when 'IK'
                then '18%'
            when 'IL'
                then '28%'
            else ''
      end                                                                                  as TaxRate,

      @Semantics.amount.currencyCode: 'InvoiceCurrency'
      case Tax.TaxCode
            when 'IA'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)) , 2, 2)
            when 'IB'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'IC'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'ID'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'IE'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'IF'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
                else cast('0' as abap.dec(17,2))
            end                                                                            as SGST,

      @Semantics.amount.currencyCode: 'InvoiceCurrency'
      case Tax.TaxCode
            when 'IA'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)) , 2, 2)
            when 'IB'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'IC'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'ID'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'IE'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)
            when 'IF'
                then division(cast(Tax.TaxAmount as abap.dec(17,2)), 2, 2)

            end                                                                            as CGST,

      @Semantics.amount.currencyCode: 'InvoiceCurrency'
      case Tax.TaxCode
            when 'IG'
                then cast(Tax.TaxAmount as abap.dec(17,2))
            when 'IH'
                then cast(Tax.TaxAmount as abap.dec(17,2))
            when 'II'
                then cast(Tax.TaxAmount as abap.dec(17,2))
            when 'IJ'
                then cast(Tax.TaxAmount as abap.dec(17,2))
            when 'IK'
                then cast(Tax.TaxAmount as abap.dec(17,2))
            when 'IL'
                then cast(Tax.TaxAmount as abap.dec(17,2))

            end                                                                            as IGST,

      OrderItem.PurchaseRequisition                                                        as PurchaseRequisition,
      OrderItem._PurchaseOrder.PurchaseOrderDate                                           as PurchaseOrderDate,
      OrderItem._PurchaseOrder.IncotermsLocation1                                          as Incoterms,
      OrderItem._PurchaseOrder.PurchaseOrderType                                           as PurchaseOrderType,
      cast(OrderItem.NetAmount as abap.dec(17,2))                                          as UnitPrice,
      cast(OrderItem.NetPriceAmount as abap.dec(17,2))                                     as UnitRate,
      PurchaseRequisitionItem.CreationDate                                                 as RequisitionDate,
      InvAccountingDoc.AccountingDocument                                                  as JournalEntryNumber,
      InvAccountingDoc.FiscalYear                                                          as JournalEntryNumbeFiscalYear,
      InvAccountingDoc.FiscalPeriod                                                        as PostingPeriod,
      cast(WithTax.AmountInTransactionCurrency as abap.dec(17,2))                          as TDS,
      GRNAccountingDocItem.AccountingDocument                                              as GRFIDocNumber,
      GRNAccountingDocItem.GLAccount                                                       as GRGLAccount,
      GRNAccountingDocItem._GLAccountTxt[ Language = 'E' ].GLAccountName                   as GRGLAccountName,
      'KZ'                                                                                 as JeType,
      cast(Freight.Amount as abap.dec(17,2))                                               as Freight,
      cast(Pack.Amount as abap.dec(17,2))                                                  as Pack,
      //      Product._ESHProductPlant.ConsumptionTaxCtrlCode
      ProductPlantIntlTrd.ConsumptionTaxCtrlCode                                           as HSNSac,
      ''                                                                                   as BankAccount,


      //Added On 02.12.2024
      InvoiceHeader.ReverseDocument                                                        as MIROReversalNumber,
      InvoiceHeader.PostingDate                                                            as MIROReversalDate,
      MatdocItem_Reversal.MaterialDocument                                                 as MIGOReversalNumber,
      MatdocItem_Reversal.PostingDate                                                      as MIGOReversalDate,
      InvoiceHeader.SupplierInvoiceIDByInvcgParty                                          as SupplierINVRefNumber,
      InvoiceHeader.PostingDate                                                            as SupplierINVRefDate,
      Supplier._AddressDefaultRepresentation.AddressSearchTerm1                            as SearchTerm,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      Product.NetWeight * cast( InvoiceItem.QuantityInPurchaseOrderUnit as abap.dec(13,3)) as OilConventionQty,
      Product.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'InvoiceUoM'
      InvoiceItem.QuantityInPurchaseOrderUnit                                              as NetQty

}
where
  InvoiceItem.ReferenceDocument <> ''
