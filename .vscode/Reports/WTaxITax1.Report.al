report 50018 WTaxITax1
{
    DefaultLayout = RDLC;
    RDLCLayout = './WTaxITax1.rdlc';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
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
            column(Amount; "G/L Entry".Amount)
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
}

