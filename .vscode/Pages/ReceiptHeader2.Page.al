page 50041 "Receipt Header 2"
{
    // 
    // KTM 20/11/2019
    // Modified whole receipt to have lines

    PageType = Document;
    SourceTable = "Reciept - Payment Header";

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
                        // if AssistEdit(xRec) then
                        //     CurrPage.Update;
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Receiced From"; "Receiced From")
                {
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
                field("Amount (LCY)"; "Amount (LCY)")
                {
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
                field(Control100000001; "Posted Receipt")
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
            part(Control100000000; "Receipt Line 2")
            {
                SubPageLink = "Doc No." = FIELD("Doc No.");
                UpdatePropagation = Both;
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

                        if "Posted Receipt" then
                            Error(Text200);
                        if "Receiced From" = '' then
                            FieldError("Receiced From", Text205);

                        ReceiptLines.SetRange("Doc No.", "Doc No.");
                        if ReceiptLines.Find('-') then begin
                            repeat
                                if ReceiptLines."Bal. Account No." = '' then
                                    Error(Text201);

                                if ReceiptLines."Account No." = '' then
                                    Error(Text202);

                                if ReceiptLines."Payment Method Code" = '' then
                                    Error(Text203)
                                else
                                    if ReceiptLines.Status = ReceiptLines.Status::Released then
                                        Error(Text204);

                            until ReceiptLines.Next = 0;
                        end;

                        // ReceiptLines.CheckLineAmtBeforePost("Doc No.");

                        DocNo := "Doc No.";

                        if not "Posted Receipt" then begin
                            ReceiptLines.SetRange("Doc No.", "Doc No.");
                            ReceiptLines.SetFilter(Status, '%1', ReceiptLines.Status::Open);
                            if ReceiptLines.Find('-') then begin
                                if Confirm('Do you want to post the receipt?', false) then begin
                                    repeat

                                        RecSet.Get;
                                        GenJnl.SetRange("Journal Template Name", RecSet."Journal Template");
                                        GenJnl.SetRange("Journal Batch Name", RecSet."Journal Batch");
                                        GenJnl.DeleteAll;

                                        //MESSAGE('count');

                                        LineNo := 10000;


                                        //insert the Record into the Journal
                                        GenJnl.Init;
                                        GenJnl."Journal Template Name" := RecSet."Journal Template";
                                        GenJnl."Journal Batch Name" := RecSet."Journal Batch";
                                        GenJnl."Line No." := LineNo;
                                        GenJnl."Document No." := ReceiptLines."Doc No.";
                                        GenJnl."Posting Date" := ReceiptLines."Posting Date";
                                        GenJnl."Account Type" := ReceiptLines."Account Type";
                                        GenJnl.Validate("Account No.", ReceiptLines."Account No.");
                                        GenJnl.Description := Description;
                                        GenJnl."External Document No." := ReceiptLines."Cheque No";
                                        GenJnl.Validate("Currency Code", ReceiptLines."Currency Code");
                                        GenJnl.Validate(Amount, ReceiptLines.Amount);
                                        GenJnl.Validate("Amount (LCY)", ReceiptLines."Amount (LCY)");
                                        GenJnl."Bal. Account Type" := ReceiptLines."Bal. Account Type";
                                        GenJnl.Validate("Bal. Account No.", ReceiptLines."Bal. Account No.");
                                        GenJnl.Validate("Shortcut Dimension 1 Code", ReceiptLines."Shortcut Dimension 1 Code");
                                        GenJnl.Validate("Shortcut Dimension 2 Code", ReceiptLines."Shortcut Dimension 2 Code");
                                        GenJnl.Validate("Shortcut Dimension 3 Code", ReceiptLines."Shortcut Dimension 3 Code");
                                        //GenJnl."Document Type"  := GenJnl."Document Type"::Payment;
                                        //GenJnl."Applies-to ID"  := ReceiptLines."Applies-to ID";
                                        //if applies to id has value then apply the releveant entries
                                        GenJnl."Applies-to ID" := ReceiptLines."Applies-to ID";
                                        if GenJnl."Applies-to ID" <> '' then begin
                                            GenJnl."Applies-to Doc. No." := ReceiptLines."Applies-to Doc. No.";
                                            GenJnl.IsApplied;
                                            GenJnl."Applies-to ID" := '';
                                        end;

                                        GenJnl.Validate("Applies-to ID");
                                        GenJnl.Insert;



                                        //Post the Journal ----------------------------------

                                        //IF CONFIRM ('Do you want to post the receipt?', FALSE) THEN BEGIN

                                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnl);


                                        ReceiptLines.Status := Status::Released;
                                        ReceiptLines.Modify(true);



                                    until ReceiptLines.Next = 0;

                                    Status := Status::Released;
                                    "Posted Receipt" := true;

                                    Modify;

                                    Commit;
                                    RecHeader.Reset;
                                    RecHeader.SetRange("Doc No.", DocNo);
                                    if RecHeader.Find('-') then
                                        REPORT.Run(50005, true, true, RecHeader)
                                end;

                            end;


                        end;





                        ;
                    end;
                }
                action(ApplyEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Apply the payment amount on a journal line to a sales or purchase document that was already posted for a customer or vendor. This updates the amount on the posted document, and the document can either be partially paid, or closed as paid or refunded.';

                    trigger OnAction()
                    begin
                        ReceiptLines.SetRange("Doc No.", "Doc No.");
                        if ReceiptLines.FindFirst then begin
                            "Bal. Account Type" := ReceiptLines."Bal. Account Type";
                            "Bal. Account No." := ReceiptLines."Bal. Account No.";
                        end else
                            Error('Receipt line must have lines to apply');
                        Modify(true);
                        Commit;

                        ApplyEntries.ApplyReceiptEntries(Rec);
                    end;
                }
                separator(Action1000000050)
                {
                }
                action("Posted Receipt")
                {
                    RunObject = Page "Posted Receipts List 2";
                }
            }
        }
    }

    trigger OnInit()
    begin
        "Cheque NoEditable" := true;
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
        [InDataSet]
        StatusEditable: Boolean;
        ReceiptLines: Record "Reciept - Payment Lines";
        TotalAmount: Decimal;
        ReceiptH: Record "Reciept - Payment Header";
        DocNo: Code[50];
        Text200: Label 'The receipt is already posted';
        Text201: Label 'Please Specify an Bal. Account No.';
        Text202: Label 'Please Specify an Account No.';
        Text203: Label 'Please Specify a Payment Method.';
        Text204: Label 'The Receipt is already Released.';
        // ReceiptReport: Report Receipt;
        RecHeader: Record "Reciept - Payment Header";
        Text205: Label 'must not be blank';

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
        // IF  "Bal. Account Type" ="Bal. Account Type"::Customer THEN
        //  CALCFIELDS("Customer Balance (LCY)");
        //
        // IF  "Bal. Account Type" ="Bal. Account Type"::Vendor THEN
        //  CALCFIELDS("Vendor Balance (LCY)");
    end;

    [Scope('Internal')]
    procedure UpdateControls()
    begin
        if Posted = false then
            StatusEditable := true
        else
            StatusEditable := false;
    end;
}

