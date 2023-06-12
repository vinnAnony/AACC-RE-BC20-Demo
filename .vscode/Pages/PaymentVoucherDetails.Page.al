page 50026 "Payment Voucher Details"
{
    // AACC12.01.06 AACC.D008.01
    // enabled currency code assist button

    PageType = ListPart;
    SourceTable = "Payment Voucher Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("PV No."; "PV No.")
                {
                    Visible = false;
                }
                field("Account Type"; "Account Type")
                {

                    trigger OnValidate()
                    begin
                        Description := '';
                    end;
                }
                field("Account No."; "Account No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Vendor Ledger Entry No."; "Vendor Ledger Entry No.")
                {
                    Visible = false;
                }
                field("G/L account No."; "Bal. Account No.")
                {
                    Caption = 'G/L account No.';
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        PaymentVoucherHeader.Get("PV No.");
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", PaymentVoucherHeader.Date);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field(Amount; Amount)
                {
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                    Editable = false;
                }
                field("Invoice Amount"; "Invoice Amount")
                {
                    Editable = false;
                }
                field("Global Dimension 1"; "Global Dimension 1")
                {
                }
                field("Global Dimension 2"; "Global Dimension 2")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
                {
                }
                field("Applies-to ID"; "Applies-to ID")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Action")
            {
                Caption = 'Action';
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
                        ApplyEntries.ApplyPaymentEntries(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Vend.Reset;
        Vend.SetRange("No.", "Account No.");
        if Vend.Find('-') then begin
            if "Account Type" = "Account Type"::Supplier then
                "Account No." := Vend."No.";
            "Vendor Name" := Vend.Name;
        end;
    end;

    var
        Cust: Record Customer;
        GLACC: Record "G/L Account";
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        PurchInvHeader: Record "Purch. Inv. Header";
        OldInvoiceNo: Code[20];
        InvAmt: Decimal;
        InvoiceNo: Text[50];
        INVB: Code[20];
        Text000: Label 'The record was found.';
        Text001: Label 'The record could not be found.';
        PaymentVoucherHeader: Record "Payment Voucher Header";
        CurrExchRate: Record "Currency Exchange Rate";
        ApplyEntries: Codeunit "Property Management";
        ChangeExchangeRate: Page "Change Exchange Rate";
}

