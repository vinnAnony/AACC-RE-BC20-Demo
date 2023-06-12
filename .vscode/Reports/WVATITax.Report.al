report 50016 "WVAT ITax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './WVATITax.rdlc';
    Caption = 'Withholding VAT ITax Report';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Posting Date", "G/L Account No.";
            column(PINNo; PINNo)
            {
            }
            column(DocumentNo; "G/L Entry"."Document No.")
            {
            }
            column(DocumentDate; "G/L Entry"."Document Date")
            {
            }
            column(Amount; BaseAmount)
            {
            }
            column(PaymentDate; PaymentDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PINNo := '';
                BaseAmount := 0;

                Vend.Reset;
                Vend.SetRange("No.", "Source No.");
                if Vend.Find('-') then begin
                    PINNo := Vend."VAT Registration No.";
                end;

                if "G/L Entry"."Withholding VAT Code" <> '' then begin
                    TariffCodes.Reset;
                    TariffCodes.SetRange(Code, "G/L Entry"."Withholding VAT Code");
                    if TariffCodes.Find('-') then
                        BaseAmount := (((TariffCodes."Tariff Rate" + 100) / 100) * "G/L Entry".Amount) * -1;
                end;
                PaymentDate := "G/L Entry"."Posting Date";
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
        PINNo: Text[20];
        PaymentDate: Date;
        Vend: Record Vendor;
        BaseAmount: Decimal;
        TariffCodes: Record "Tariff Codes";
}

