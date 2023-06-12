page 50035 "Posted Rent Invoices List"
{
    Caption = 'Posted Rent Invoices';
    CardPageID = "Posted Sales Invoice (Rent)";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Invoice,Navigate,Correct';
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    SourceTableView = SORTING ("Posting Date")
                      ORDER(Descending)
                      WHERE ("Rent Invoice" = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the currency code of the invoice.';
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the invoice is due for payment.';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines. The amount does not include VAT.';

                    trigger OnDrillDown()
                    begin
                        SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';

                    trigger OnDrillDown()
                    begin
                        SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the postal code of the customer''s main address.';
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the country/region code of the customer''s main address.';
                    Visible = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the name of the contact person at the customer''s main address.';
                    Visible = false;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                    Visible = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';
                    Visible = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the postal code of the customer''s billing address.';
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the country/region code of the customer''s billing address.';
                    Visible = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the name of the contact person at the customer''s billing address.';
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
                    Visible = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';
                    Visible = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the postal code of the address that the items are shipped to.';
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the country/region code of the address that the items are shipped to.';
                    Visible = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the date when the invoice was posted.';
                    Visible = false;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies which salesperson is associated with the invoice.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the location from which the items were shipped.';
                }
                field("No. Printed"; "No. Printed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many times the document has been printed.';
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                    Visible = false;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                    Visible = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                    Visible = false;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
                    Visible = false;
                }
                field(Closed; Closed)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the posted sales invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
                }
                field(Reversed; Reversed)
                {
                    Editable = false;
                }
                field(Cancelled; Cancelled)
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = NOT Cancelled;
                    Style = Unfavorable;
                    StyleExpr = Cancelled;
                    ToolTip = 'Specifies if the posted sales invoice has been either corrected or canceled.';
                    Visible = IsFoundationEnabled;

                    trigger OnDrillDown()
                    begin
                        ShowCorrectiveCreditMemo;
                    end;
                }
                field(Corrective; Corrective)
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = NOT Corrective;
                    Style = Unfavorable;
                    StyleExpr = Corrective;
                    ToolTip = 'Specifies if the posted sales invoice is a corrective document.';

                    trigger OnDrillDown()
                    begin
                        ShowCancelledCreditMemo;
                    end;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                    Visible = false;
                }
                field("Document Exchange Status"; "Document Exchange Status")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = DocExchStatusStyle;
                    ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
                    Visible = DocExchStatusVisible;

                    trigger OnDrillDown()
                    var
                        DocExchServDocStatus: Codeunit "Doc. Exch. Serv.- Doc. Status";
                    begin
                        DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                    end;
                }
                field("<Document Exchange Status>"; "Coupled to CRM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the posted sales order is coupled to a sales order in Dynamics 365 for Sales.';
                    Visible = CRMIntegrationEnabled;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Advanced;
                ShowFilter = false;
                Visible = NOT IsOfficeAddin;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
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
                Image = Invoice;
                action(Statistics)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Invoice Statistics";
                    RunPageLink = "No." = FIELD ("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST ("Posted Invoice"),
                                  "No." = FIELD ("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Advanced;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard("No.", "Posting Date");
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics 365 for Sales';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoInvoice)
                {
                    ApplicationArea = Suite;
                    Caption = 'Invoice';
                    Enabled = CRMIsCoupledToRecord;
                    Image = CoupledSalesInvoice;
                    ToolTip = 'Open the coupled Dynamics 365 for Sales invoice.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(RecordId);
                    end;
                }
                action(CreateInCRM)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Invoice in Dynamics 365 for Sales';
                    Enabled = NOT CRMIsCoupledToRecord;
                    Image = NewSalesInvoice;
                    ToolTip = 'Generate the document in the coupled Dynamics 365 for Sales account.';

                    trigger OnAction()
                    var
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                        CRMIntegrationManagement.CreateNewRecordsInCRM(SalesInvoiceHeader);
                    end;
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the posted sales invoice table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(RecordId);
                    end;
                }
            }
        }
        area(processing)
        {
            action(SendCustom)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Enabled = NOT IsPostedSalesInvoicesEmpty;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.SendRecords;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    REPORT.Run(50026, true, true, SalesInvHeader);
                    //SalesInvHeader.PrintRecords(TRUE);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send by &Email';
                Image = Email;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.EmailRecords(true);
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category5;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.';

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(RecordId);
                end;
            }
            group(Correct)
            {
                Caption = 'Correct';
                action(CorrectInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Correct';
                    Enabled = NOT IsPostedSalesInvoicesEmpty;
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                    Visible = IsFoundationEnabled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Correct PstdSalesInv (Yes/No)", Rec);
                    end;
                }
                action(CancelInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Enabled = NOT IsPostedSalesInvoicesEmpty;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.';
                    Visible = IsFoundationEnabled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Cancel PstdSalesInv (Yes/No)", Rec);
                    end;
                }
                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Corrective Credit Memo';
                    Enabled = NOT IsPostedSalesInvoicesEmpty;
                    Image = CreateCreditMemo;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category6;
                    Scope = Repeater;
                    ToolTip = 'Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
                    begin
                        //ktm 10/15/19
                        if not Confirm(Confirm001, false, "No.") then
                            exit;

                        PropertyManagement.ReversePeriod(Rec."Contract No");
                        if "Remaining Amount" = 0 then
                            Error(Text001);
                        if "Amount Including VAT" <> "Remaining Amount" then
                            Error(Text002);
                        if Reversed then
                            Error(Text003);
                        Reversed := true;
                        //MODIFY;
                        //ktm end
                        CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec, SalesHeader);
                        PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                    end;
                }
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                Image = Invoice;
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD ("Sell-to Customer No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
                action(ShowCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Canceled/Corrective Credit Memo';
                    Enabled = Cancelled OR Corrective;
                    Image = CreditMemo;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Scope = Repeater;
                    ToolTip = 'Open the posted sales credit memo that was created when you canceled the posted sales invoice. If the posted sales invoice is the result of a canceled sales credit memo, then canceled sales credit memo will open.';

                    trigger OnAction()
                    begin
                        ShowCanceledOrCorrCrMemo;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
    end;

    trigger OnAfterGetRecord()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;

        SalesInvoiceHeader.CopyFilters(Rec);
        IsPostedSalesInvoicesEmpty := SalesInvoiceHeader.IsEmpty;
        SalesInvoiceHeader.SetFilter("Document Exchange Status", '<>%1', "Document Exchange Status"::"Not Sent");
        DocExchStatusVisible := not SalesInvoiceHeader.IsEmpty;
    end;

    trigger OnInit()
    begin
        DocExchStatusVisible := false;
    end;

    trigger OnOpenPage()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeMgt: Codeunit "Office Management";
        HasFilters: Boolean;
    begin
        HasFilters := GetFilters <> '';
        SetSecurityFilterOnRespCenter;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        if HasFilters then
            if FindFirst then;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        IsPostedSalesInvoicesEmpty := SalesInvoiceHeader.IsEmpty;
        IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
    end;

    var
        ApplicationAreaSetup: Record "Application Area Setup";
        DocExchStatusStyle: Text;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        DocExchStatusVisible: Boolean;
        IsOfficeAddin: Boolean;
        IsPostedSalesInvoicesEmpty: Boolean;
        IsFoundationEnabled: Boolean;
        PropertyManagement: Codeunit "Property Management";
        Text001: Label 'The Invoice is already fully applied';
        Text002: Label 'The Invoice has applied entries, this must be unapplied to proceed';
        Text003: Label 'The credit memo is already created, you need to post it.';
        Confirm001: Label 'Are you sure you want to reverse Invoice %1?';
}

