report 50025 "Receipt T"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReceiptT.rdlc';

    dataset
    {
        dataitem("Reciept - Payment Lines"; "Reciept - Payment Lines")
        {
            column(ReceiptNo; "Reciept - Payment Lines"."Doc No.")
            {
            }
            column(ReceivedFrom; "Reciept - Payment Lines"."Receiced From")
            {
            }
            column(CurrencyCode; "Reciept - Payment Lines"."Currency Code")
            {
            }
            column(Description; "Reciept - Payment Lines".Description)
            {
            }
            column(PayMode; "Reciept - Payment Lines"."Payment Method Code")
            {
            }
            column(ChequeNo; "Reciept - Payment Lines"."Cheque No")
            {
            }
            column(Amount; "Reciept - Payment Lines".Amount)
            {
            }
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
        NumberText: array[2] of Text[80];
}

