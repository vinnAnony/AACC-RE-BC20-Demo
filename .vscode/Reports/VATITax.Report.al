report 50015 "VAT ITax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VATITax.rdlc';
    Caption = 'VAT ITax Report';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            RequestFilterFields = "Posting Date", Type;
            column(PurchaseType; PurchaseType)
            {
            }
            column(PINNo; PINNo)
            {
            }
            column(VendorName; EntityName)
            {
            }
            column(DocumentDate; "VAT Entry"."Posting Date")
            {
            }
            column(DocumentNo; "VAT Entry"."Document No.")
            {
            }
            column(Description; Desc)
            {
            }
            column(ExternalDocumentNo; ExternalDocNo)
            {
            }
            column(BaseAmount; "VAT Entry".Base)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PINNo := '';
                EntityName := '';
                Desc := '';
                ExternalDocNo := '';
                PurchaseType := 'Local';

                with GLEntry do begin
                    Reset;
                    SetRange("Document Type", "VAT Entry"."Document Type");
                    SetRange("Document No.", "VAT Entry"."Document No.");
                    if Find('-') then begin
                        Desc := Description;
                        ExternalDocNo := GLEntry."External Document No.";

                        //Purchase
                        if "VAT Entry".Type = "VAT Entry".Type::Purchase then begin
                            Vend.Reset;
                            Vend.SetRange("No.", "Source No.");
                            if Vend.Find('-') then begin
                                EntityName := Vend.Name;
                                PINNo := Vend."VAT Registration No.";
                                if Vend.Foreign then
                                    PurchaseType := 'Foreign';
                            end;
                        end;

                        //Sale
                        if "VAT Entry".Type = "VAT Entry".Type::Sale then begin
                            Cust.Reset;
                            Cust.SetRange("No.", "Source No.");
                            if Cust.Find('-') then
                                EntityName := Cust.Name;
                        end;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Type, "VAT Entry".Type::Purchase);
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
        EntityName: Text[50];
        PINNo: Text[20];
        Vend: Record Vendor;
        Desc: Text[50];
        GLEntry: Record "G/L Entry";
        ExternalDocNo: Code[20];
        Cust: Record Customer;
        PurchaseType: Text[20];
}

