page 50042 "Receipt Line 2"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Reciept - Payment Lines";
    SourceTableView = SORTING("Doc No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Open));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Doc No."; "Doc No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    Caption = 'Account Type';

                    trigger OnValidate()
                    begin
                        Amount := 0;
                    end;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    Caption = 'Account No.';
                }
                field("Bal. Account Name"; "Bal. Account Name")
                {
                    Caption = 'Account Name';
                    Visible = false;
                }
                field("Receiced From"; "Receiced From")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                // group(Control6)
                // {
                //     ShowCaption = false;
                //     Visible = "Bal. Account Type" = "Bal. Account Type"::Vendor;
                //     field("Vendor Balance (LCY)"; "Vendor Balance (LCY)")
                //     {
                //         Visible = true;
                //     }
                // }
                // group(Control4)
                // {
                //     ShowCaption = false;
                //     Visible = "Bal. Account Type" = "Bal. Account Type"::Customer;
                //     field("Customer Balance (LCY)"; "Customer Balance (LCY)")
                //     {
                //         Visible = true;
                //     }
                // }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    Editable = false;
                }
                field("Account No."; "Account No.")
                {
                    Caption = 'Bank Acc No.';
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    AssistEdit = true;
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        if ChangeExchangeRate.RunModal = ACTION::OK then
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Caption = 'Payment Method';

                    trigger OnValidate()
                    begin
                        "Cheque NoEditable" := true;


                        "Payment Method".SetRange(Code, "Payment Method Code");
                        "Payment Method".SetRange("Payment Method", "Payment Method"."Payment Method"::Cheque);

                        if "Payment Method".FindFirst then
                            "Cheque NoEditable" := true
                        else
                            "Cheque NoEditable" := false;
                    end;
                }
                field("Cheque No"; "Cheque No")
                {
                    Editable = "Cheque NoEditable";
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Caption = 'Payment Method Date';
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Applies-to ID"; "Applies-to ID")
                {
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(ApplyEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Enabled = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ApplyEntries.ApplyReceiptEntries(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
        CalcBalances;
    end;

    trigger OnInit()
    begin
        "Cheque NoEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        "Bal. Account Type" := "Bal. Account Type"::Customer;
        "Account Type" := "Account Type"::"Bank Account";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InsertValue;

        "Bal. Account Type" := "Bal. Account Type"::Customer;
        "Account Type" := "Account Type"::"Bank Account";
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        // CheckReport.InitTextVariable;
        CheckAmount := Amount;

        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
        OnActivateForm;
    end;

    var
        GenJnl: Record "Gen. Journal Line";
        Text001: Label 'Are you sure you want to Release the document?';
        RecSet: Record "Sales & Receivables Setup";
        LineNo: Integer;
        Text002: Label 'This receipt has already been released';
        text003: Label 'Please release the receipt before printing';
        RylCod: Codeunit "Property Management";
        ReceiptLine: Record "Reciept - Payment Lines";
        NoSeries: Codeunit NoSeriesManagement;
        Change_due: Decimal;
        Receivedby: Text[30];
        AccNo: Code[20];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Text000: Label 'You must specify %1 or %2.';
        Text101: Label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text102: Label 'Do you wish to continue?';
        Text103: Label 'The update has been interrupted to respect the warning.';
        Text105: Label 'The %1 or %2 must be Customer or Vendor.';
        Text106: Label 'All entries in one application must be in the same currency.';
        Text107: Label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
        OK: Boolean;
        CurrencyCode2: Code[10];
        Currency: Record Currency;
        RoyaltyCodeUnit: Codeunit "Property Management";
        GenSetup: Record "General Ledger Setup";
        window: Dialog;
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesline: Record "No. Series Line";
        NoSeriesMgt: array[8] of Codeunit NoSeriesManagement;
        CompanyAddr: Text[80];
        CheckStatusText: Text[30];
        CheckAmount: Decimal;
        NumberText: array[2] of Text[80];
        lines: Record "Reciept - Payment Lines";
        GenJnl2: Record "Gen. Journal Line";
        "Payment Method": Record "Payment Method";
        IsMethod: Boolean;
        PayMethodCode: Code[10];
        GenJnl3: Record "Gen. Journal Line";
        "Gen. Jnl.-Post Line": Codeunit "Gen. Jnl.-Post Line";
        ShortcutDimCode: array[8] of Code[20];
        Dimens: Record "Dimension Value";
        "Shortcut Dimension 2 Code": Code[20];
        [InDataSet]
        "Cheque NoEditable": Boolean;
        // CheckReport: Report "Check - Receipt Requirement";
        ApplyEntries: Codeunit "Property Management";
        RecP: Record "Reciept - Payment Lines";
        ChangeExchangeRate: Page "Change Exchange Rate";
        ReceiptHeader: Record "Reciept - Payment Header";

    local procedure AmountOnAfterValidate()
    begin
        // CheckReport.InitTextVariable;
        CheckAmount := Amount;
        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        // CheckReport.InitTextVariable;
        CheckAmount := Amount;

        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
        //"Bal. Account Type" :="Bal. Account Type"::Customer;
        "Account Type" := "Account Type"::"Bank Account";
    end;

    local procedure OnActivateForm()
    begin
        // CheckReport.InitTextVariable;
        CheckAmount := Amount;
        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
    end;

    local procedure CalcBalances()
    begin
        if "Bal. Account Type" = "Bal. Account Type"::Customer then
            CalcFields("Customer Balance (LCY)");

        if "Bal. Account Type" = "Bal. Account Type"::Vendor then
            CalcFields("Vendor Balance (LCY)");
    end;

    [Scope('Internal')]
    procedure InsertValue()
    begin
        ReceiptHeader.SetRange("Doc No.", "Doc No.");
        if ReceiptHeader.Find('-') then begin
            "Posting Date" := ReceiptHeader."Posting Date";
            "Receiced From" := ReceiptHeader."Receiced From";
            Description := ReceiptHeader.Description;
            "Account No." := ReceiptHeader."Account No.";
            "Currency Code" := ReceiptHeader."Currency Code";
            "Currency Factor" := ReceiptHeader."Currency Factor";
            "Currency Filter" := ReceiptHeader."Currency Filter";
            "Payment Method Code" := ReceiptHeader."Payment Method Code";
            "Shortcut Dimension 1 Code" := ReceiptHeader."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ReceiptHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ReceiptHeader."Shortcut Dimension 3 Code";
            "Applies-to ID" := ReceiptHeader."Applies-to ID";
            Modify;
        end;
    end;
}

