page 50027 "Payment Voucher Posted"
{
    Editable = false;
    PageType = Document;
    SourceTable = "Payment Voucher Header";
    SourceTableView = WHERE (Status = CONST (Posted));

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
                group(Control1000000006)
                {
                    ShowCaption = false;
                    Visible = true;
                    field("Cheque No."; "Cheque No.")
                    {
                        Editable = false;
                        Visible = true;
                    }
                    field("Cheque Date"; "Cheque Date")
                    {
                        Editable = false;
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
                field("PV Description"; "PV Description")
                {
                    Editable = false;
                }
                field("PV Payee"; "PV Payee")
                {
                    Editable = false;
                    Enabled = true;
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
        area(processing)
        {
            group(Print)
            {
                Caption = 'Print';
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
                action("PV Remittance Advice")
                {
                    Caption = 'PV Remittance Advice';

                    trigger OnAction()
                    begin

                        Reset;
                        SetFilter("PV No.", "PV No.");
                        REPORT.Run(50028, true, true, Rec);
                        Reset;
                    end;
                }
            }
        }
    }

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
        "Payment Line": Record "Tariff Codes";
        vend: Record Vendor;
        cust: Record Customer;
        "G/L": Record "G/L Account";
        PurchInvHeader2: Record "Purch. Inv. Header";
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

