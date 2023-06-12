page 50003 "Tenants Card"
{
    Caption = 'Tenants Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Customer;
    SourceTableView = SORTING("No.")
                      WHERE("Customer Types" = CONST(Tenants));

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
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    Caption = 'Post Code/City';
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Primary Contact No."; "Primary Contact No.")
                {
                }
                field(Contact; Contact)
                {
                    Editable = ContactEditable;

                    trigger OnValidate()
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.", "No.");
                        CopyFilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        CopyFilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        CopyFilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                }
                field("Deposit Amount"; "Deposit Amount")
                {
                }
                field("Refunded Deposit"; "Refunded Deposit")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Customer Types"; "Customer Types")
                {
                    Caption = 'Customer Type';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Fax No."; "Fax No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Home Page"; "Home Page")
                {
                }
                field("IC Partner Code"; "IC Partner Code")
                {

                    trigger OnValidate()
                    begin
                        ICPartnerCodeOnAfterValidate;
                    end;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Invoice Copies"; "Invoice Copies")
                {
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                }
                field("Copy Sell-to Addr. to Qte From"; "Copy Sell-to Addr. to Qte From")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Application Method"; "Application Method")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                }
                field("Reminder Terms Code"; "Reminder Terms Code")
                {
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                }
                field("Print Statements"; "Print Statements")
                {
                }
                field("Last Statement No."; "Last Statement No.")
                {
                }
                field("Block Payment Tolerance"; "Block Payment Tolerance")
                {

                    trigger OnValidate()
                    begin
                        if "Block Payment Tolerance" then begin
                            if Confirm(Text002, false) then
                                PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
                        end else begin
                            if Confirm(Text001, false) then
                                PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Tenant")
            {
                Caption = '&Tenant';
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Visible = false;
                    action("Issued &Reminders")
                    {
                        Caption = 'Issued &Reminders';
                        RunObject = Page "Issued Reminder";
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                        Visible = false;
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        Caption = 'Issued &Finance Charge Memos';
                        RunObject = Page "Issued Finance Charge Memo";
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                        Visible = false;
                    }
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(18),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Bank Accounts")
                {
                    Caption = 'Bank Accounts';
                    RunObject = Page "Customer Bank Account Card";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("Ship-&to Addresses")
                {
                    Caption = 'Ship-&to Addresses';
                    RunObject = Page "Ship-to Address";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("C&ontact")
                {
                    Caption = 'C&ontact';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                separator(Action100)
                {
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Statistics by C&urrencies")
                {
                    Caption = 'Statistics by C&urrencies';
                    RunObject = Page "Dimension Set ID Filter";
                    RunPageLink = Code = FIELD("No.");
                    //   Field56 = FIELD ("Global Dimension 1 Filter"),
                    //   Field57 = FIELD ("Global Dimension 2 Filter"),
                    //   Field55 = FIELD ("Date Filter");
                    Visible = false;
                }
                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("S&ales")
                {
                    Caption = 'S&ales';
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                separator(Action115)
                {
                    Caption = '';
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    // RunObject = Page "Cross References";
                    // RunPageLink = "Cross-Reference Type" = CONST (Customer),
                    //               "Cross-Reference Type No." = FIELD ("No.");
                    // RunPageView = SORTING ("Cross-Reference Type", "Cross-Reference Type No.");
                    Visible = false;
                }
                separator(Action125)
                {
                    Caption = '';
                }
                action("Ser&vice Contracts")
                {
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Customer Service Contracts";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.", "Ship-to Code");
                    Visible = false;
                }
                action("Service &Items")
                {
                    Caption = 'Service &Items';
                    RunObject = Page "Service Items";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
                    Visible = false;
                }
                separator(Action138)
                {
                }
                action("&Jobs")
                {
                    Caption = '&Jobs';
                    RunObject = Page "Job Card";
                    RunPageLink = "Bill-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Bill-to Customer No.");
                    Visible = false;
                }
                separator(Action149)
                {
                }
            }
            group(Action82)
            {
                Caption = 'S&ales';
                action("Invoice &Discounts")
                {
                    Caption = 'Invoice &Discounts';
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("S&td. Cust. Sales Codes")
                {
                    Caption = 'S&td. Cust. Sales Codes';
                    RunObject = Page "Standard Customer Sales Codes";
                    RunPageLink = "Customer No." = FIELD("No.");
                    Visible = false;
                }
                separator(Action137)
                {
                }
                action(Quotes)
                {
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quote";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.", "No.");
                    Visible = false;
                }
                action("Blanket Orders")
                {
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Sales Order";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                    Visible = false;
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Order";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.", "No.");
                    Visible = false;
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Order";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.", "No.");
                    Visible = false;
                }
                action("Service Orders")
                {
                    Caption = 'Service Orders';
                    Image = Document;
                    RunObject = Page "Service Order";
                    RunPageLink = "Bill-to Address 2" = FIELD("No.");
                    RunPageView = SORTING("No.", "Bill-to Address 2");
                    Visible = false;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    Visible = false;

                    trigger OnAction()
                    var
                        ItemTrackingMgt: Codeunit "Item Tracking Management";
                    begin
                        //ItemTrackingMgt.CopyHandledItemTrkgToPurchLineWithLineQty(1,"No.",'','','','','');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActivateFields;

        OnAfterGetCurrRecord;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordFound: Boolean;
    begin
        RecordFound := Find(Which);
        CurrPage.Editable := RecordFound or (GetFilter("No.") = '');
        exit(RecordFound);
    end;

    trigger OnInit()
    begin
        ContactEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Customer Types" := "Customer Types"::Tenants;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        ActivateFields;
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        Text001: Label 'Do you want to allow payment tolerance for entries that are currently open?';
        CustomizedCalendar: Record "Customized Calendar Change";
        Text002: Label 'Do you want to remove payment tolerance from entries that are currently open?';
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        [InDataSet]
        ContactEditable: Boolean;

    [Scope('Internal')]
    procedure ActivateFields()
    begin
        ContactEditable := "Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure ICPartnerCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ActivateFields;
    end;
}

