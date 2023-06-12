page 50032 "Payment Voucher Posting List"
{
    CardPageID = "Payment Voucher Posting";
    Editable = false;
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Voucher Posting List';
    UsageCategory = Tasks;
    SourceTable = "Payment Voucher Header";
    SourceTableView = SORTING("PV No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Posting));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("PV No."; "PV No.")
                {
                }
                field(Date; Date)
                {
                }
                field(Type; Type)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Payment Mode"; "Payment Mode")
                {
                    Editable = false;
                }
                field("Cheque No."; "Cheque No.")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Bank Code"; "Bank Code")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Supplier No."; "Supplier No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Amount Calculated"; "Amount Calculated")
                {
                }
                field("Transaction Name"; "Transaction Name")
                {
                }
                field(Status; Status)
                {
                    Editable = true;
                }
                field("Prepared By"; "Prepared By")
                {
                }
                field("Prepared Date"; "Prepared Date")
                {
                }
                field("Programme Officer"; "Programme Officer")
                {
                }
                field("Programme Officer App Date"; "Programme Officer App Date")
                {
                }
                field("Finance Officer"; "Finance Officer")
                {
                }
                field("Finance Officer App Date"; "Finance Officer App Date")
                {
                }
                field("Supplier Name"; "Supplier Name")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Reviewed By"; "Reviewed By")
                {
                }
                field("Reviewed Date"; "Reviewed Date")
                {
                }
                field("First Signatory"; "First Signatory")
                {
                }
                field("First Signatory Date"; "First Signatory Date")
                {
                }
                field("Second Signatory"; "Second Signatory")
                {
                }
                field("Second Signatory Date"; "Second Signatory Date")
                {
                }
                field("Cheque/Cash Recieved By"; "Cheque/Cash Recieved By")
                {
                }
                field("Cheque/Cash Recieved Date"; "Cheque/Cash Recieved Date")
                {
                }
                field("ID No./Passport No."; "ID No./Passport No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

