page 50008 "Sales Invoice (Rent)"
{
    Caption = 'Rent Invoice ';
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice),
                            "Rent Invoice" = CONST(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    LookupPageID = "Tenants List";

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code/City';
                }
                field("Sell-to City"; "Sell-to City")
                {
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Contract No"; "Contract No")
                {
                }
                field("Property No"; "Property No")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field(Status; Status)
                {
                }
                field("Invoice Period"; "Invoice Period")
                {

                    trigger OnValidate()
                    var
                        InvPeriod: Record "Tenant Invoicing Periods";
                    begin
                        //PeriodName:='';
                        //IF InvPeriod.GET("Invoice Period") THEN
                        //  PeriodName:=InvPeriod.Name;
                        //Created a function in cd50000 function CreateRentinvoice to assign Period name
                    end;
                }
                field("Period Name"; "Period Name")
                {
                }
                field("General Description"; "General Description")
                {
                }
            }
            part(SalesLines; "Sales Invoice Subform(Rent)")
            {
                Editable = DynamicEditable;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group(Control9)
            {
                ShowCaption = false;
                Visible = false;
                field("Total Exclusive VAT"; "Total Exclusive VAT")
                {
                }
                field("Total Inclusive VAT"; "Total Inclusive VAT")
                {
                }
            }
            group(CustInfoPanel)
            {
                Caption = 'Customer Information';
                Visible = false;
                label(Control167)
                {
                    CaptionClass = Text19070588;
                    ShowCaption = false;
                }
                label(Control158)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                label(Control160)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                label(Control168)
                {
                    CaptionClass = Text19069283;
                    ShowCaption = false;
                }
                label(Control164)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                label(SalesHistoryCount)
                {
                    Editable = false;
                    Visible = SalesHistoryCountVisible;
                }
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code/City';
                }
                field("Bill-to City"; "Bill-to City")
                {
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; "Ship-to Code")
                {
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code/City';
                }
                field("Ship-to City"; "Ship-to City")
                {
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Package Tracking No."; "Package Tracking No.")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        SalesSetup.Get;
                        if SalesSetup."Calc. Inv. Discount" then begin
                            //  CurrPage.SalesLines.PAGE.CalcInvDisc;
                            Commit;
                        end;
                        PAGE.RunModal(PAGE::"Sales Statistics", Rec);
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                separator(Action142)
                {
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    Caption = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                separator(Action138)
                {
                }
                action("Get &Job Usage")
                {
                    Caption = 'Get &Job Usage';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        TestField("No.");
                        //CurrPage.SalesLines.PAGE.GetJobLedger;
                    end;
                }
                separator(Action139)
                {
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                separator(Action141)
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    RunObject = Codeunit "Release Sales Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.Reopen(Rec);
                    end;
                }
                separator(Action151)
                {
                }
                action("Send IC Document")
                {
                    Caption = 'Send IC Document';
                    ShortCutKey = 'Alt+F11';
                    Visible = false;

                    trigger OnAction()
                    var
                        ICInOutboxMgt: Codeunit ICInboxOutboxMgt;
                    begin
                        ICInOutboxMgt.SendSalesDoc(Rec, false);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        //ReportPrint.PrintSalesHeader(Rec);
                        Reset;
                        SetFilter("No.", xRec."No.");
                        REPORT.Run(50027, true, true, Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        //Codeunit Sales-Post (Yes/No)
                        CODEUNIT.Run(CODEUNIT::"Sales-Post (Yes/No)", Rec);
                        //CurrPage.CLOSE;
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //ktm
                        CODEUNIT.Run(CODEUNIT::"Sales-Post + Print", Rec);
                        LastNoSalesInvHeader := '';
                        if SalesInvoiceHeader.FindLast then begin
                            LastNoSalesInvHeader := SalesInvoiceHeader."No.";
                            SalesInvHeader.Reset;
                            SalesInvHeader.SetRange("No.", LastNoSalesInvHeader);
                            if SalesInvHeader.Find('-') then
                                REPORT.Run(50026, true, true, SalesInvHeader);
                        end;
                        //CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)",Rec);
                        //ktm
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Invoices", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
            action("Avail&. Credit")
            {
                Caption = 'Avail&. Credit';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupAvailCredit("Bill-to Customer No.");
                end;
            }
            action("&Contacts")
            {
                Caption = '&Contacts';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupContacts(Rec);
                end;
            }
            action("Ship&-to Addresses")
            {
                Caption = 'Ship&-to Addresses';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupShipToAddr(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //ktm
        DynamicEditable := CurrPage.Editable;
        //ktm
    end;

    trigger OnAfterGetRecord()
    var
        InvPeriod: Record "Tenant Invoicing Periods";
    begin
        PeriodName := '';
        if InvPeriod.Get("Invoice Period") then
            PeriodName := InvPeriod.Name;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        BillToCommentBtnVisible := true;
        BillToCommentPictVisible := true;
        SalesHistoryCountVisible := true;
        SalesHistoryBtnVisible := true;

        if "General Description" = '' then
            "General Description" := "Period Name";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        xRec.Init;
        "Responsibility Center" := UserMgt.GetSalesFilter();
        "Rent Invoice" := true;
        //CurrPage.SAVERECORD;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter() <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserMgt.GetSalesFilter());
            FilterGroup(0);
        end;

        CurrPage.Update;
        //PropertyMGMT.UpdateSalesLineVATIncl;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        [InDataSet]
        SalesHistoryBtnVisible: Boolean;
        [InDataSet]
        SalesHistoryCountVisible: Boolean;
        [InDataSet]
        BillToCommentPictVisible: Boolean;
        [InDataSet]
        BillToCommentBtnVisible: Boolean;
        Text19070588: Label 'Sell-to Customer';
        Text19069283: Label 'Bill-to Customer';
        PeriodName: Text[30];
        SalesHeader: Record "Sales Header";
        PropertyMGMT: Codeunit "Property Management";
        SalesPost: Codeunit "Sales-Post (Yes/No)";
        SalesInvHeader: Record "Sales Invoice Header";
        SaleInvHeaderRec: Record "Sales Invoice Header";
        // PostedSaleInv: Report "Posted Sales - Invoice";
        DynamicEditable: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        LastNoSalesInvHeader: Code[50];

    local procedure UpdateInfoPanel()
    var
        DifferSellToBillTo: Boolean;
    begin
        DifferSellToBillTo := "Sell-to Customer No." <> "Bill-to Customer No.";
        SalesHistoryBtnVisible := DifferSellToBillTo;
        SalesHistoryCountVisible := DifferSellToBillTo;
        BillToCommentPictVisible := DifferSellToBillTo;
        BillToCommentBtnVisible := DifferSellToBillTo;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        //CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        //CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;
}

