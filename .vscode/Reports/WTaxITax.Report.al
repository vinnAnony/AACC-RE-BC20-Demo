report 50017 "WTax ITax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './WTaxITax.rdlc';
    Caption = 'Withholding Tax ITax';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "Posting Date";
            column(NatureOfTrans; NatureOfTrans)
            {
            }
            column(Country; Country)
            {
            }
            column(ResidentialStatus; ResidentialStatus)
            {
            }
            column(DocumentDate; "G/L Entry"."Document Date")
            {
            }
            column(PINNo; PINNo)
            {
            }
            column(WithholdeeName; WithholdeeName)
            {
            }
            column(WithholdeeAddress; WithholdeeAddress)
            {
            }
            column(WithholdeeEmail; WithholdeeEmail)
            {
            }
            column(Amount; BaseAmount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                NatureOfTrans := '';
                Country := 'Other';
                ResidentialStatus := 'Resident';
                WithholdeeName := '';
                WithholdeeAddress := '';
                WithholdeeEmail := '';
                PINNo := '';
                BaseAmount := 0;

                with Vend do begin
                    Reset;
                    SetRange("No.", "Source No.");
                    if Find('-') then begin
                        PINNo := "VAT Registration No.";
                        if Foreign then
                            ResidentialStatus := 'Non-Resident';
                        WithholdeeName := Name;
                        WithholdeeAddress := Address;
                        WithholdeeEmail := "E-Mail";
                    end;
                end;

                if "G/L Entry"."Withholding Tax Code" <> '' then begin
                    TariffCodes.Reset;
                    TariffCodes.SetRange(Code, "G/L Entry"."Withholding Tax Code");
                    if TariffCodes.Find('-') then
                        BaseAmount := (((TariffCodes."Tariff Rate" + 100) / 100) * "G/L Entry".Amount) * -1;
                end;
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
        NatureOfTrans: Text[50];
        Country: Text[20];
        ResidentialStatus: Text[20];
        WithholdeeName: Text[50];
        WithholdeeAddress: Text[50];
        WithholdeeEmail: Text[50];
        BaseAmount: Decimal;
        TariffCodes: Record "Tariff Codes";
}

