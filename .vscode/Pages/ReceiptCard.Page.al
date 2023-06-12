page 50007 "Receipt Card"
{
    // For the Balancing Acount Type and No: Only Customer and Vendor are necessary. but cannot remove the others because Navision takes
    // into consideration index of options not values of the same options.
    // 
    // Release - Insert the Journal line and to allocate Status to Released
    // ReOpen - Deletes Journal line and Returns the status to Open
    // 
    // Amount to 0 when you change account type, its like a reset

    PageType = Card;
    SourceTable = "Reciept - Payment Lines";
    SourceTableView = SORTING("Doc No.") ORDER(Ascending) WHERE(Status = CONST(Open));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Doc No."; "Doc No.")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        // IF AssistEdit(xRec) THEN
                        //     CurrPage.UPDATE;
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
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
                }
                field("Receiced From"; "Receiced From")
                {
                }
                group(Control6)
                {
                    ShowCaption = false;
                    Visible = "Bal. Account Type" = "Bal. Account Type"::Vendor;
                    field("Vendor Balance (LCY)"; "Vendor Balance (LCY)")
                    {
                        Visible = true;
                    }
                }
                group(Control4)
                {
                    ShowCaption = false;
                    Visible = "Bal. Account Type" = "Bal. Account Type"::Customer;
                    field("Customer Balance (LCY)"; "Customer Balance (LCY)")
                    {
                        Visible = true;
                    }
                }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
                field("NumberText[1]"; NumberText[1])
                {
                    Caption = 'Amount in Words';
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field("Account No."; "Account No.")
                {
                    Caption = 'Bank Acc No.';
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    AssistEdit = true;
                    Editable = true;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);

                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    Editable = false;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Caption = 'Payment Method';

                    trigger OnValidate()
                    begin
                        "Cheque NoEditable" := TRUE;


                        "Payment Method".SETRANGE(Code, "Payment Method Code");
                        "Payment Method".SETRANGE("Payment Method", "Payment Method"."Payment Method"::Cheque);

                        IF "Payment Method".FINDFIRST THEN
                            "Cheque NoEditable" := TRUE
                        ELSE
                            "Cheque NoEditable" := FALSE;
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
                action("&Post & Print")
                {
                    Caption = '&Post & Print';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        //validation checks - 0606706  JMG
                        IF "Bal. Account No." = '' THEN
                            ERROR('Please Specify an Bal. Account No.');

                        IF "Account No." = '' THEN
                            ERROR('Please Specify an Account No.');

                        IF "Payment Method Code" = '' THEN
                            ERROR('Please Specify a Payment Method.')
                        ELSE
                            IF Status = Status::Released THEN
                                ERROR('The Receipt is already Released.');

                        //validation checks - 0606706  JMG

                        IF Status = Status::Open THEN BEGIN

                            RecSet.GET;
                            GenJnl.SETRANGE("Journal Template Name", RecSet."Journal Template");
                            GenJnl.SETRANGE("Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.DELETEALL;

                            LineNo := 10000;

                            //insert the Record into the Journal
                            GenJnl.INIT;
                            GenJnl."Journal Template Name" := RecSet."Journal Template";
                            GenJnl."Journal Batch Name" := RecSet."Journal Batch";
                            GenJnl."Line No." := LineNo;
                            GenJnl."Document No." := "Doc No.";
                            GenJnl."Posting Date" := "Posting Date";
                            GenJnl."Account Type" := "Account Type";
                            GenJnl.VALIDATE("Account No.", "Account No.");
                            GenJnl.Description := Description;
                            GenJnl."External Document No." := "Cheque No";
                            GenJnl.VALIDATE("Currency Code", "Currency Code");
                            GenJnl.VALIDATE(Amount, Amount);
                            //ktm 06/11/19
                            GenJnl.VALIDATE("Amount (LCY)", "Amount (LCY)");
                            //ktm end
                            GenJnl."Bal. Account Type" := "Bal. Account Type";
                            GenJnl.VALIDATE("Bal. Account No.", "Bal. Account No.");
                            GenJnl.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                            GenJnl.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                            GenJnl.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                            //GenJnl."Document Type"  :=GenJnl."Document Type"::Payment;
                            GenJnl."Applies-to ID" := "Applies-to ID";
                            GenJnl.VALIDATE("Applies-to ID");
                            GenJnl.INSERT;

                            //Post the Journal ----------------------------------
                            IF CONFIRM('Do you want to post the receipt?', FALSE) THEN BEGIN
                                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnl);
                                Status := Status::Released;
                                RecP.RESET;
                                RecP.SETFILTER(RecP."Doc No.", "Doc No.");
                                REPORT.RUN(50005, TRUE, TRUE, RecP);
                                MODIFY;
                            END;

                        END;
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Simply Removes the lines from the Journal and Reopens the Receipt
                        //Cannot Reopen if lines not there

                        IF Status <> Status::Open THEN BEGIN
                            RecSet.GET;
                            GenJnl.SETFILTER(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SETFILTER(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.SETFILTER(GenJnl."Document No.", "Doc No.");

                            IF NOT GenJnl.FIND('-') THEN
                                ERROR('The Receipt lines are not present in the Journal. Cannot be Reopened.');

                            IF GenJnl.FIND('-') THEN BEGIN
                                GenJnl.DELETEALL;
                                RylCod.ReopenDoc(Rec);
                            END;
                        END;
                    end;
                }
                action("&Print Receipt")
                {
                    Caption = '&Print Receipt';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF NOT (Status = Status::Open) THEN BEGIN
                            lines.COPY(Rec);
                            lines.SETRECFILTER;
                            REPORT.RUNMODAL(50005, TRUE, FALSE, lines);
                        END
                        ELSE
                            ERROR('Please Release Receipt %1 first.', "Doc No.");
                    end;
                }
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF NOT (Status = Status::Open) THEN BEGIN
                            //IF GenJnl.FIND('+') THEN BEGIN
                            RecSet.GET;
                            //LineNo := GenJnl.COUNT +1000000;
                            //MESSAGE('%1',LineNo);
                            LineNo := 1;
                            IF GenJnl.FINDLAST THEN
                                LineNo := GenJnl.COUNT + 1000000;


                            GenJnl.SETFILTER(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SETFILTER(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.SETFILTER(GenJnl."Document No.", "Doc No.");
                            IF GenJnl.FIND('-') THEN
                                GenJnl.DELETEALL;
                            GenJnl.RESET;
                            GenJnl.INIT;
                            GenJnl."Journal Template Name" := RecSet."Journal Template";
                            GenJnl."Journal Batch Name" := RecSet."Journal Batch";
                            GenJnl."Line No." := LineNo;
                            GenJnl."Document No." := "Doc No.";
                            GenJnl."Posting Date" := "Posting Date";
                            GenJnl."Account Type" := "Bal. Account Type";
                            GenJnl."Account No." := "Bal. Account No.";
                            GenJnl.Description := Description;
                            GenJnl."External Document No." := "Cheque No";
                            GenJnl."Currency Code" := "Currency Code";
                            GenJnl.Amount := Amount;
                            GenJnl."Bal. Account Type" := "Account Type";
                            GenJnl."Bal. Account No." := "Account No.";
                            GenJnl."Amount (LCY)" := Amount;
                            GenJnl.INSERT;
                            COMMIT;
                            //accounts below - For Test purposes VEGA NM
                            GenJnl.SETFILTER(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SETFILTER(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl2.SETFILTER(GenJnl2."Document No.", "Doc No.");
                            IF GenJnl2.FIND('-') THEN
                                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Apply", GenJnl2)
                            ELSE
                                MESSAGE('There is nothing to Apply.');
                        END
                        ELSE
                            ERROR('Please Release the Receipt %1 first.', "Doc No.");
                    end;
                }
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

                    trigger OnAction()
                    begin
                        // ApplyEntries.ApplyReceiptEntries(Rec);
                    end;
                }
                separator(Action1000000050)
                {
                }
                action("Posted Receipt")
                {
                    RunObject = Page "Posted Receipts List";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
        //RMM 28/09/2018
        CalcBalances;
    end;

    trigger OnInit()
    begin
        "Cheque NoEditable" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
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
        IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN
            CALCFIELDS("Customer Balance (LCY)");

        IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN
            CALCFIELDS("Vendor Balance (LCY)");
    end;
}

