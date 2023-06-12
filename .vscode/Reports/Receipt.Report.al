report 50005 Receipt
{
    DefaultLayout = RDLC;
    RDLCLayout = './Receipt.rdlc';

    dataset
    {
        dataitem("Reciept - Payment Header"; "Reciept - Payment Header")
        {
            DataItemTableView = SORTING("Doc No.") ORDER(Descending);
            RequestFilterFields = "Doc No.";
            column(Document_No; "Reciept - Payment Header"."Doc No.")
            {
            }
            column(Posting_Date; "Reciept - Payment Header"."Posting Date")
            {
            }
            column(Description; "Reciept - Payment Header".Description)
            {
            }
            column(Account_No; "Reciept - Payment Header"."Account No.")
            {
            }
            column(Amount; "Reciept - Payment Header".Amount)
            {
            }
            column(AmountWords; NumberText[1])
            {
            }
            column(Amount_Words; NumberText[2])
            {
            }
            column(Received_From; "Reciept - Payment Header"."Receiced From")
            {
            }
            column(Pay_Mode; "Reciept - Payment Header"."Payment Method Code")
            {
            }
            column(Cheque_No; "Reciept - Payment Header"."Cheque No")
            {
            }
            column(Time_Entered; "Reciept - Payment Header"."Time Entered")
            {
            }
            column(ReceivedFrom; "Reciept - Payment Header"."Receiced From")
            {
            }
            column(Bal_Name; "Reciept - Payment Header"."Bal. Account Name")
            {
            }
            column(Currency; CurrencyCode)
            {
            }
            column(ReceiptDateTime; ReceiptDateTime)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CurrencyCode := '';

                // CheckReport.InitTextVariable;
                CheckAmount := Amount;
                // CheckReport.FormatNoText(NumberText, CheckAmount, "Reciept - Payment Header"."Currency Code");

                if "Reciept - Payment Header"."Currency Code" = '' then begin
                    CurrencyCode := 'KSH';
                end else begin
                    CurrencyCode := "Reciept - Payment Header"."Currency Code";
                end;

                ReceiptLines.SetRange("Doc No.", "Reciept - Payment Header"."Doc No.");
                if ReceiptLines.Find('-') then
                    ReceivedFrm := ReceiptLines."Bal. Account Name";
            end;

            trigger OnPreDataItem()
            begin
                ReceiptDateTime := CreateDateTime(Today, Time);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        // CheckReport: Report "Check - Receipt Requirement";
        NumberText: array[2] of Text[80];
        CheckAmount: Decimal;
        CurrencyCode: Code[20];
        ReceiptDateTime: DateTime;
        ReceivedFrm: Text[250];
        ReceiptLines: Record "Reciept - Payment Lines";

    [Scope('Internal')]
    procedure InitParam(DocNo: Code[50])
    begin
        "Reciept - Payment Header".Reset;
        "Reciept - Payment Header".SetRange("Doc No.", DocNo);

        //REPORT.RUNMODAL(50005,TRUE,TRUE,"Reciept - Payment Header");
    end;
}

