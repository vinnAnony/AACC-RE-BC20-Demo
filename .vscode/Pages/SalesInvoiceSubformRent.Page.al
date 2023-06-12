page 50010 "Sales Invoice Subform(Rent)"
{
    AutoSplitKey = true;
    Caption = 'Sales Invoice Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Resource Sub Type"; "Resource Sub Type")
                {
                }
                field("No."; "No.")
                {
                    Editable = true;
                    LookupPageID = "Property List";

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                        UpdateEditableOnRow;
                        ShowShortcutDimCode(ShortcutDimCode);
                        if xRec."No." <> '' then
                            RedistributeTotalsOnAfterValidate;
                        UpdateTypeText;

                        CurrPage.Update;
                    end;
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // CrossReferenceNoLookUp;
                        InsertExtendedText(false);
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                    end;
                }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type")
                {
                    Visible = false;
                }
                field("IC Partner Reference"; "IC Partner Reference")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field("Unit Price lcy"; "Unit Price lcy")
                {
                    Caption = 'Amount Including VAT';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Nonstock; Nonstock)
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {

                    trigger OnValidate()
                    begin
                        UpdateVAT;
                    end;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        //ktm

                        "Total Amount" := "No. of Months" * Quantity * "Unit Price";
                        "Amount Per Period" := "Total Amount";
                        "Unit Price lcy" := "No. of Months" * Quantity * "Unit Price" * 1.16;
                        //ktm
                        "Qty. to Invoice" := "No. of Months" * Quantity;
                        Amount := "No. of Months" * Quantity * "Unit Price";
                        "Amount Including VAT" := "No. of Months" * Quantity * "Unit Price" * 1.16;
                        "Line Amount" := "No. of Months" * "Unit Price" * Quantity;
                        UpdateVAT;
                        CurrPage.Update;
                        //ktm
                    end;
                }
                field("No. of Months"; "No. of Months")
                {

                    trigger OnValidate()
                    begin

                        "Total Amount" := "No. of Months" * Quantity * "Unit Price";
                        "Unit Price lcy" := "No. of Months" * Quantity * "Unit Price" * 1.16;
                        //ktm
                        "Qty. to Invoice" := "No. of Months" * Quantity;
                        Amount := "No. of Months" * Quantity * "Unit Price";
                        "Amount Including VAT" := "No. of Months" * Quantity * "Unit Price" * 1.16;
                        "Amount Per Period" := "Total Amount";
                        "Line Amount" := "No. of Months" * "Unit Price" * Quantity;


                        CurrPage.Update;
                        UpdateVAT;
                        //ktm
                    end;
                }
                field("No. of Units"; "No. of Units")
                {
                    Visible = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        LineAmount := "No. of Months" * "Unit Price" * Quantity;
                        "Line Amount" := LineAmount;
                        "Unit Price lcy" := "Total Amount" * 1.16;
                        "Line Amount" := "No. of Months" * "Unit Price" * Quantity;
                        //ktm

                        "Amount Including VAT" := "Total Amount" * 1.16;

                        CurrPage.Update;
                        UpdateVAT;
                        //ktm
                    end;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        "Total Amount" := "Unit Price" * "No. of Months" * Quantity;
                        "Unit Price lcy" := "Unit Price" * "No. of Months" * Quantity * 1.16;
                        //ktm
                        Amount := "Unit Price" * "No. of Months" * Quantity;
                        "Amount Including VAT" := "Unit Price" * "No. of Months" * Quantity * 1.16;
                        "Amount Per Period" := "Total Amount";
                        "Line Amount" := "No. of Months" * "Unit Price" * Quantity;


                        CurrPage.Update;
                        UpdateVAT;
                        //ktm
                    end;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Total Amount"; "Total Amount")
                {
                    Caption = 'Amount Excl VAT';
                    Editable = false;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field(PriceExists; PriceExists)
                {
                    Caption = 'Sales Price Exists';
                    Editable = false;
                    Visible = false;
                }
                field(LineDiscExists; LineDiscExists)
                {
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        if "Line Discount %" > 0 then begin

                            "Total Amount" := "Total Amount" - "Line Discount Amount";
                            "Unit Price lcy" := "Unit Price lcy" - "Line Discount Amount"
                        end else begin
                            "Total Amount" := "Unit Price" * "No. of Months" * Quantity;
                            "Unit Price lcy" := "Unit Price" * "No. of Months" * Quantity * 1.16;
                        end;
                        //ktm
                        if "Line Discount %" > 0 then begin
                            Amount := Amount - "Line Discount Amount";
                            "Amount Including VAT" := "Amount Including VAT" - "Line Discount Amount"
                        end else begin
                            Amount := "Unit Price" * "No. of Months" * Quantity;
                            "Amount Including VAT" := "Unit Price" * "No. of Months" * Quantity * 1.16;
                        end;
                        "Amount Per Period" := "Total Amount";

                        CurrPage.Update;
                    end;
                }
                field("Amount Per Period"; "Amount Per Period")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Floor No"; "Floor No")
                {
                }
                field("Property No"; "Property No")
                {
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        UpdateForm(false);
                        CurrPage.Update;
                    end;
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        UpdateForm(false);
                        CurrPage.Update;
                    end;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    Visible = false;
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    Visible = false;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    Visible = false;
                }
                field("FA Posting Date"; "FA Posting Date")
                {
                    Visible = false;
                }
                field("Depr. until FA Posting Date"; "Depr. until FA Posting Date")
                {
                    Visible = false;
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                    Visible = false;
                }
                field("Use Duplication List"; "Use Duplication List")
                {
                    Visible = false;
                }
                field("Duplicate in Depreciation Book"; "Duplicate in Depreciation Book")
                {
                    Visible = false;
                }
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
            group(Control13)
            {
                ShowCaption = false;
                group(Control32)
                {
                    ShowCaption = false;
                    field("TotalSalesLine.""Total Amount"""; TotalSalesLine."Total Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
                    }
                    field("Invoice Discount Amount"; InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FieldCaption("Inv. Discount Amount"), Currency.Code);
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            ValidateInvoiceDiscountAmount;
                            TotalSalesLine."Total Amount" := TotalSalesLine."Total Amount" - InvoiceDiscountAmount;
                            //ktm
                            TotalSalesLine.Amount := TotalSalesLine.Amount - InvoiceDiscountAmount;
                        end;
                    }
                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 2;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';

                        trigger OnValidate()
                        begin
                            //InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                            //ValidateInvoiceDiscountAmount;
                            TotalSalesLine."Total Amount" := TotalSalesLine."Total Amount" - InvoiceDiscountAmount;
                            //ktm
                            TotalSalesLine.Amount := TotalSalesLine.Amount - InvoiceDiscountAmount;

                            CurrPage.Update;
                        end;
                    }
                }
                group(Control25)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalSalesLine."Total Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        // CaptionClass = DocumentTotals.GetTotalExclCaption(Currency.Code);
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; TotalSalesLine."Amount Including VAT" - TotalSalesLine."Total Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Calculate &Invoice Discount")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        ApproveCalcInvDisc;

                    end;
                }
                action("Get &Price")
                {
                    Caption = 'Get &Price';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        ShowPrices

                    end;
                }
                action("Get Li&ne Discount")
                {
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        ShowLineDisc

                    end;
                }
                action("E&xplode BOM")
                {
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        ExplodeBOM;

                    end;
                }
                action("Insert &Ext. Texts")
                {
                    Caption = 'Insert &Ext. Texts';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        _InsertExtendedText(true);

                    end;
                }
                action("Get &Shipment Lines")
                {
                    Caption = 'Get &Shipment Lines';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        GetShipment;

                    end;
                }
                action("Get &Phase/Task/Step")
                {
                    Caption = 'Get &Phase/Task/Step';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50009. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.FORM.*/
                        GetPhaseTaskStep;

                    end;
                }
            }
            action("Sales Line &Discounts")
            {
                Caption = 'Sales Line &Discounts';
                Image = SalesLineDisc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowLineDisc;
                    CurrPage.Update;
                end;
            }
            action("&Sales Prices")
            {
                Caption = '&Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowPrices;
                    CurrPage.Update;
                end;
            }
            action("Substitutio&ns")
            {
                Caption = 'Substitutio&ns';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowItemSub;
                    CurrPage.Update;
                end;
            }
            action("Availa&bility")
            {
                Caption = 'Availa&bility';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //OutstandingInvoiceAmountFromShipment(0);
                end;
            }
            action("Ite&m Card")
            {
                Caption = 'Ite&m Card';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SalesInfoPaneMgt.LookupItem(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals;
        UpdateEditableOnRow;
        SetItemChargeFieldsStyle;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInit()
    begin
        SalesSetup.Get;
        Currency.InitRoundingPrecision;
        TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Sales);
        IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //Type := xRec.Type;
        Clear(ShortcutDimCode);
        "Rent Invoice" := true;
        Type := Type::Resource;
    end;

    var
        SalesHeader: Record "Sales Header";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ShortcutDimCode: array[8] of Code[20];
        Total: Record "Sales Header";
        Currency: Record Currency;
        DocumentTotals: Codeunit "Document Totals";
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ApplicationAreaSetup: Record "Application Area Setup";
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        AmountWithDiscountAllowed: Decimal;
        UpdateAllowedVar: Boolean;
        LocationCodeVisible: Boolean;
        InvDiscAmountEditable: Boolean;
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        IsFoundation: Boolean;
        ItemChargeStyleExpression: Text;
        TypeAsText: Text[30];
        Text000: Label 'Unable to run this function while in View mode.';
        LineAmount: Decimal;
        TotalVAT: Decimal;
        TotalAmountInclVAT: Decimal;

    [Scope('Internal')]
    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    [Scope('Internal')]
    procedure CalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;

    [Scope('Internal')]
    procedure ExplodeBOM()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    [Scope('Internal')]
    procedure GetShipment()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Get Shipment", Rec);
    end;

    [Scope('Internal')]
    procedure GetPhaseTaskStep()
    begin
        // CODEUNIT.Run(CODEUNIT::Codeunit65, Rec);
    end;

    [Scope('Internal')]
    procedure GetJobLedger()
    begin
        //GetJobUsage.SetCurrentSalesLine(Rec);
        //GetJobUsage.RUNMODAL;
        //CLEAR(GetJobUsage);
    end;

    [Scope('Internal')]
    procedure _InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;

    [Scope('Internal')]
    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;

    [Scope('Internal')]
    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        //Rec.OutstandingInvoiceAmountFromShipment(AvailabilityType);
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;

    [Scope('Internal')]
    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt;
    end;

    [Scope('Internal')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    [Scope('Internal')]
    procedure ShowPrices()
    begin
        SalesHeader.Get("Document Type", "Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;

    [Scope('Internal')]
    procedure ShowLineDisc()
    begin
        SalesHeader.Get("Document Type", "Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure QuantityOnAfterValidate()
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord;
            AutoReserve;
        end;
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord;
            AutoReserve;
        end;
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get("Document Type", "Document No.");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        CurrPage.Update(false);
    end;

    procedure UpdatePage(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure SetUpdateAllowed(UpdateAllowed: Boolean)
    begin
        UpdateAllowedVar := UpdateAllowed;
    end;

    procedure UpdateAllowed(): Boolean
    begin
        if UpdateAllowedVar = false then begin
            Message(Text000);
            exit(false);
        end;
        exit(true);
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);

        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and (xRec."No." <> '') then
            CurrPage.SaveRecord;
    end;

    local procedure UpdateEditableOnRow()
    var
        SalesLine: Record "Sales Line";
    begin
        IsCommentLine := not HasTypeToFillMandatoryFields;
        if not IsCommentLine then
            UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        else
            UnitofMeasureCodeIsChangeable := false;

        if TotalSalesHeader."No." <> '' then begin
            SalesLine.SetRange("Document No.", TotalSalesHeader."No.");
            SalesLine.SetRange("Document Type", TotalSalesHeader."Document Type");
            if not SalesLine.IsEmpty then
                InvDiscAmountEditable :=
                  SalesCalcDiscByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") and CurrPage.Editable;
        end;
    end;

    local procedure ValidateAutoReserve()
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord;
            AutoReserve;
        end;
    end;

    local procedure GetTotalSalesHeader()
    begin
        if not TotalSalesHeader.Get("Document Type", "Document No.") then
            Clear(TotalSalesHeader);
        if Currency.Code <> TotalSalesHeader."Currency Code" then
            if not Currency.Get(TotalSalesHeader."Currency Code") then begin
                Clear(Currency);
                Currency.InitRoundingPrecision;
            end
    end;

    local procedure CalculateTotals()
    begin
        GetTotalSalesHeader;
        TotalSalesHeader.CalcFields("Recalculate Invoice Disc.");

        if SalesSetup."Calc. Inv. Discount" and ("Document No." <> '') and (TotalSalesHeader."Customer Posting Group" <> '') and
           TotalSalesHeader."Recalculate Invoice Disc."
        then
            if Find then
                CalcInvDisc;

        DocumentTotals.CalculateSalesTotals(TotalSalesLine, VATAmount, Rec);
        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
        InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
        InvoiceDiscountPct := SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        TotalSalesHeader.Get("Document Type", "Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.Update;
    end;

    local procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(FieldNo(Type)));
    end;

    local procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        if AssignedItemCharge then
            ItemChargeStyleExpression := 'Unfavorable';
    end;

    [Scope('Internal')]
    procedure UpdateVAT()
    begin
        //ktm
        if ("VAT Prod. Posting Group" = '') or ("VAT Prod. Posting Group" = 'NO VAT') or ("VAT Prod. Posting Group" = 'ZERO') then begin
            "Unit Price lcy" := "Unit Price" * "No. of Months" * Quantity;
            "Amount Including VAT" := "Unit Price" * "No. of Months" * Quantity;
            "Total Amount" := "Unit Price" * "No. of Months" * Quantity;
            Amount := "Unit Price" * "No. of Months" * Quantity;
        end else
            if ("VAT Prod. Posting Group" = 'VAT16') then begin
                "Total Amount" := "Unit Price" * "No. of Months" * Quantity;
                "Unit Price lcy" := "Unit Price" * "No. of Months" * Quantity * 1.16;
                "Amount Including VAT" := "Unit Price" * "No. of Months" * Quantity * 1.16;
                Amount := "Unit Price" * "No. of Months" * Quantity;
            end;
        TotalAmountInclVAT := "Amount Including VAT";
        CurrPage.Update;
        //ktm
    end;
}

