page 50029 "Payment Voucher Posting"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Payment Voucher Header";
    SourceTableView = WHERE (Status = CONST (Posting));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("PV No."; "PV No.")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                    Editable = false;
                }
                field("Bank Code"; "Bank Code")
                {
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = false;
                }
                field("Payment Mode"; "Payment Mode")
                {
                }
                group(Control1000000013)
                {
                    ShowCaption = false;
                    Visible = "Payment Method" = "Payment Method"::Cheque;
                    field("Cheque No."; "Cheque No.")
                    {
                        Visible = true;
                    }
                    field("Cheque Date"; "Cheque Date")
                    {
                    }
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    Editable = false;
                }
                field("Amount Calculated (LCY)"; "Amount Calculated (LCY)")
                {
                    Editable = false;
                }
                field("Global Dimension 1"; "Global Dimension 1")
                {
                    Editable = false;
                }
                field("Global Dimension 2"; "Global Dimension 2")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Prepared By"; "Prepared By")
                {
                    Editable = false;
                }
                field("Prepared Date"; "Prepared Date")
                {
                    Editable = false;
                }
                field("Interim Account"; "Interim Account")
                {
                    Caption = 'Interim Account';
                    Editable = true;
                    TableRelation = "G/L Account"."No.";
                }
                field("PV Description"; "PV Description")
                {
                    Editable = false;
                }
                field("PV Payee"; "PV Payee")
                {
                    Editable = false;
                }
            }
            group("Payment Details")
            {
                Caption = 'Payment Details';
                part(Control1000000000; "Payment Voucher Details")
                {
                    Editable = false;
                    SubPageLink = "PV No." = FIELD ("PV No.");
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Action")
            {
                Caption = 'Action';
                action("Not Approved")
                {
                    Caption = 'Not Approved';

                    trigger OnAction()
                    begin
                        Status := Status::Preparation;
                        Modify;
                        //CurrForm.SAVERECORD;
                        //CurrForm.UPDATE;
                    end;
                }
                separator(xx)
                {
                    Caption = 'xx';
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LineNo: Integer;
                        BankAccount: Record "Bank Account";
                        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
                    begin
                        if not Confirm(CONF_POST, false, "PV No.") then
                            exit;

                        "Reviewed By" := UserId;
                        "Reviewed Date" := Today;

                        if not BankAccount.Get("Bank Code") then
                            Error(ERR_BANKCODE, "Bank Code");

                        GenJnlLine.Reset;
                        GenJnlLine.SetRange("Journal Template Name", 'PAYMENT');
                        GenJnlLine.SetRange("Journal Batch Name", 'PVJOURNAL');
                        GenJnlLine.DeleteAll;

                        //Make credit(-) entry, i.e, to bank, from the payment voucher header
                        LineNo := 10000;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := 'PAYMENT';
                        GenJnlLine."Journal Batch Name" := 'PVJOURNAL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine.Validate("Posting Date", Date);
                        GenJnlLine."Document No." := "PV No.";
                        GenJnlLine."External Document No." := "Cheque No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                        GenJnlLine.Validate("Account No.", "Bank Code");
                        GenJnlLine.Description := CopyStr(StrSubstNo(TXT_DESCRIPTION, "Supplier Name"), 1, 50);
                        GenJnlLine.Validate("Currency Code", "Currency Code");
                        GenJnlLine."Currency Factor" := "Currency Factor";
                        GenJnlLine.Validate(Amount, -Amount);
                        //VEGA OVJ 16/05/13
                        /*
                        GenJnlLine.ValidateShortcutDimCode (1, "Global Dimension 1");
                        GenJnlLine.ValidateShortcutDimCode (2, "Global Dimension 2");
                        */
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", "Global Dimension 1");
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", "Global Dimension 2");
                        //VEGA OVJ 16/05/13
                        GenJnlLine.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
                        //Use of interim account for balancing
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := "Interim Account";
                        //end use of Interim

                        GenJnlLine.Insert;

                        //Make debit(+) entries, i.e, to bank, from the payment voucher line
                        "Payment Line".Reset;
                        "Payment Line".SetRange("PV No.", "PV No.");
                        if "Payment Line".Find('-') then
                            repeat
                                if ("Payment Line".Amount <> 0) then begin
                                    LineNo += 10000;
                                    GenJnlLine.Init;
                                    GenJnlLine."Journal Template Name" := 'PAYMENT';
                                    GenJnlLine."Journal Batch Name" := 'PVJOURNAL';
                                    GenJnlLine."Line No." := LineNo;
                                    GenJnlLine.Validate("Posting Date", Date);
                                    GenJnlLine."Document No." := "Payment Line"."PV No.";
                                    GenJnlLine."External Document No." := "Cheque No.";
                                    GenJnlLine."Account Type" := "Payment Line"."Account Type";
                                    GenJnlLine.Validate("Account No.", "Payment Line"."Account No.");
                                    GenJnlLine.Description := "Payment Line".Description;
                                    GenJnlLine.Validate("Currency Code", "Payment Line"."Currency Code");
                                    GenJnlLine."Currency Factor" := "Payment Line"."Currency Factor";
                                    GenJnlLine.Validate(Amount, "Payment Line".Amount);
                                    //VEGA OVJ 16/05/13
                                    /*
                                        GenJnlLine.ValidateShortcutDimCode (1, "Payment Line"."Global Dimension 1");
                                        GenJnlLine.ValidateShortcutDimCode (2, "Payment Line"."Global Dimension 2");
                                    */
                                    GenJnlLine.Validate("Shortcut Dimension 1 Code", "Payment Line"."Global Dimension 1");
                                    GenJnlLine.Validate("Shortcut Dimension 2 Code", "Payment Line"."Global Dimension 2");
                                    //VEGA OVJ 16/05/13
                                    GenJnlLine.ValidateShortcutDimCode(3, "Payment Line"."Shortcut Dimension 3 Code");
                                    GenJnlLine.ValidateShortcutDimCode(4, "Payment Line"."Shortcut Dimension 4 Code");
                                    //Use of interim account for balancing
                                    GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                    GenJnlLine."Bal. Account No." := "Interim Account";
                                    //end use of Interim

                                    if (("Payment Line"."Account Type" = "Payment Line"."Account Type"::Supplier)
                                        or ("Payment Line"."Account Type" = "Payment Line"."Account Type"::Customer))
                                       and
                                       ("Payment Line"."Invoice No." <> '') then
                                        GenJnlLine.Validate("Applies-to Doc. No.", "Payment Line"."Invoice No.");


                                    //RMM 22/09/2018
                                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                                    GenJnlLine."Applies-to ID" := "Payment Line"."Applies-to ID";
                                    GenJnlLine.Validate("Applies-to ID");

                                    GenJnlLine.Insert;
                                end;
                            until "Payment Line".Next = 0;

                        GenJnlPostBatch.Run(GenJnlLine);
                        Status := Status::Posted;
                        Modify;

                    end;
                }
                separator(Action1000000009)
                {
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    begin

                        Reset;
                        SetFilter("PV No.", "PV No.");
                        REPORT.Run(50024, true, true, Rec);
                        Reset;
                    end;
                }
            }
        }
    }

    var
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CustLedger: Record "Vendor Ledger Entry";
        CustLedger1: Record "Vendor Ledger Entry";
        Amt: Decimal;
        DiffTaxesRet: Decimal;
        Retention: Decimal;
        IsVATZero: Boolean;
        IsWTaxZero: Decimal;
        GenLedgerSetup: Record "General Ledger Setup";
        NonRetainedVAT: Decimal;
        ApplyInvoice: Codeunit "Purchase Header Apply";
        Notify: Codeunit Mail;
        VendorLedger: Record "Vendor Ledger Entry";
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        "Payment Line": Record "Payment Voucher Line";
        vend: Record Vendor;
        cust: Record Customer;
        "G/L": Record "G/L Account";
        PurchInvHeader2: Record "Purch. Inv. Header";
        CONF_POST: Label 'Do you want to post PV %1?';
        TXT_DESCRIPTION: Label 'Payment %1';
        ERR_BANKCODE: Label 'Bank/Cash Account %1 does not exist.';
        "Interim Account": Code[10];
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Cheque DateEditable": Boolean;
        CurrExchRate: Record "Currency Exchange Rate";

    [Scope('Internal')]
    procedure UpdateHeaderFCYAmount(pvno: Code[20])
    var
        PVHeader: Record "Reciept - Payment Lines";
    begin
        CalcFields("Amount Calculated (LCY)");
        if "Currency Code" = '' then
            "Amount Calculated" := "Amount Calculated (LCY)"
        else
            "Amount Calculated" := Round(CurrExchRate.ExchangeAmtLCYToFCY(
                      Date, "Currency Code",
                      "Amount Calculated (LCY)", "Currency Factor"));
    end;
}

