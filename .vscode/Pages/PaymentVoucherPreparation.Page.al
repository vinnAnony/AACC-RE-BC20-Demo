page 50025 "Payment Voucher Preparation"
{
    // AACC12.01.06 AACC.D008.01
    // enabled currency code assist button

    PageType = Document;
    SourceTable = "Payment Voucher Header";
    SourceTableView = WHERE(Status = CONST(Preparation));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("PV No."; "PV No.")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        // if AssistEdit(xRec) then
                        //     CurrPage.Update;
                    end;
                }
                field(Date; Date)
                {
                }
                field("Bank Code"; "Bank Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    AssistEdit = true;
                    Editable = true;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", Date);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Payment Mode"; "Payment Mode")
                {

                    trigger OnValidate()
                    begin
                        //RMM 19/09/2018
                        PayMode.Reset;
                        PayMode.SetRange(PayMode.Code, "Payment Mode");
                        PayMode.SetRange(PayMode."Payment Method", PayMode."Payment Method"::Cheque);
                        if PayMode.Find('-') then begin

                        end else begin

                        end;
                    end;
                }
                group(Control1000000011)
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
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                }
                field("Amount Calculated (LCY)"; "Amount Calculated (LCY)")
                {
                }
                field("Global Dimension 1"; "Global Dimension 1")
                {
                }
                field("Global Dimension 2"; "Global Dimension 2")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                    Lookup = true;
                }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
                {
                    Lookup = true;
                }
                field(Status; Status)
                {
                }
                field("Prepared By"; "Prepared By")
                {
                }
                field("Prepared Date"; "Prepared Date")
                {
                    Editable = true;
                }
                field("PV Description"; "PV Description")
                {
                }
                label(Suggest_Vendor_Caption)
                {
                    CaptionClass = Text19079026;
                    Visible = false;
                }
                field("PV Payee"; "PV Payee")
                {
                }
                field("Supplier No."; "Supplier No.")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if "Account Type" = "Account Type"::Vendor then begin
                            vend.SetRange(vend."No.", "Supplier No.");
                            if vend.Find('-') then
                                "Supplier Name" := vend.Name;
                        end;

                        if "Account Type" = "Account Type"::Customer then begin
                            cust.SetRange(cust."No.", "Supplier No.");
                            if cust.Find('-') then
                                "Supplier Name" := cust.Name;
                        end;

                        if "Account Type" = "Account Type"::"G/L Account" then begin
                            "G/L".SetRange("G/L"."No.", "Supplier No.");
                            if "G/L".Find('-') then
                                "Supplier Name" := "G/L".Name;
                        end;
                    end;
                }
                field("Supplier Name"; "Supplier Name")
                {
                    Visible = false;
                }
            }
            group("Payment Details")
            {
                Caption = 'Payment Details';
                part(Control1000000000; "Payment Voucher Details")
                {
                    SubPageLink = "PV No." = FIELD("PV No.");
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
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';

                    trigger OnAction()
                    begin
                        if (Amount = 0) then
                            Error(ERR_AMOUNT);

                        TestField("PV No.");
                        TestField(Date);
                        TestField("Payment Mode");
                        TestField("Bank Code");
                        if "Pay Mode" = "Pay Mode"::Cheque then begin
                            TestField("Cheque No.");
                            TestField("Cheque Date");
                        end;

                        CalcFields("Amount Calculated (LCY)");

                        if ("Amount (LCY)" <> "Amount Calculated (LCY)") then
                            Error(ERR_AMOUNT_TALLY, "Amount (LCY)", "Amount Calculated (LCY)");

                        // UpdateHeaderFCYAmount("PV No.");

                        if Confirm('Would you like to send PV %1 for approval?', false, "PV No.") then begin
                            "Prepared By" := UserId;
                            "Prepared Date" := Today;
                            Status := Status::Posting;
                            Modify;
                            CurrPage.Close;
                        end;
                    end;
                }
                separator(Action1000000008)
                {
                }
                action("Suggest Vendor Payments")
                {
                    Caption = 'Suggest Vendor Payments';
                    Image = SuggestVendorPayments;
                    Visible = false;

                    trigger OnAction()
                    var
                        PaymentVoucherLine: Record "Payment Voucher Line";
                    begin
                        if ("Account Type" <> "Account Type"::Vendor) then
                            Error(ERR_SUGGEST);

                        PaymentVoucherLine.SetRange(PaymentVoucherLine."PV No.", "PV No.");
                        if PaymentVoucherLine.FindFirst then
                            Error(ERR_LINES_EXIST);

                        TestField("Supplier No.");

                        VendLedgEntry.Reset;
                        VendLedgEntry.SetRange("Vendor No.", "Supplier No.");
                        VendLedgEntry.SetRange(Open, true);
                        VendLedgEntry.SetRange("Document Type", VendLedgEntry."Document Type"::Invoice);
                        if VendLedgEntry.Find('-') then
                            repeat
                                "Payment Line"."PV No." := "PV No.";
                                "Payment Line"."Line No." := VendLedgEntry."Entry No.";
                                "Payment Line"."Account Type" := "Account Type";
                                "Payment Line"."Account No." := "Supplier No.";
                                "Payment Line".Description := StrSubstNo(TXT_DESCRIPTION_INV, VendLedgEntry."Document No.");
                                "Payment Line"."Vendor Ledger Entry No." := VendLedgEntry."Entry No.";
                                "Payment Line"."Currency Code" := VendLedgEntry."Currency Code";
                                VendLedgEntry.CalcFields("Remaining Amount", "Original Amount");
                                "Payment Line".Amount := -VendLedgEntry."Remaining Amount";
                                "Payment Line"."Invoice No." := VendLedgEntry."Document No.";
                                "Payment Line"."Invoice Amount" := VendLedgEntry."Original Amount";
                                "Payment Line".Insert;
                            until VendLedgEntry.Next = 0;
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

    trigger OnAfterGetRecord()
    begin
        "Cheque No.Visible" := "Pay Mode" = "Pay Mode"::Cheque;
        "Cheque DateVisible" := "Pay Mode" = "Pay Mode"::Cheque;
    end;

    trigger OnInit()
    begin
        "Cheque DateVisible" := true;
        "Cheque No.Visible" := true;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
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
        ERR_SUGGEST: Label 'You can only use Suggest Vendor Payments for Vendors.';
        ERR_LINES_EXIST: Label 'You cannot use Suggest Vendor Payments when lines already exist.';
        TXT_DESCRIPTION_INV: Label 'Payment of invoice no. %1';
        CountPVLines: Integer;
        ERR_AMOUNT: Label 'Payment Voucher Amount must be specified.';
        ERR_AMOUNT_TALLY: Label 'Header amount %1 does not tally with lines total amount %2.';
        CurrExchRate: Record "Currency Exchange Rate";
        [InDataSet]
        "Cheque No.Visible": Boolean;
        [InDataSet]
        "Cheque DateVisible": Boolean;
        Text19079026: Label 'Suggest payments for:';
        PayMode: Record "Payment Method";
        PVHeader: Record "Payment Voucher Header";
        ChangeExchangeRate: Page "Change Exchange Rate";

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

    local procedure OnActivateForm()
    begin
        UpdateHeaderFCYAmount("PV No.");
    end;
}

