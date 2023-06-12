tableextension 50016 SalesCrMemoHeaderExt extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50000; "Rent Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Vega-NCM -To Identify documents created from Rent Contracts';
        }
        field(50001; "Member Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Guest Hse. Cat"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Room,Laundry,Conference,Restaurant;
        }
        field(50021; "Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Main,Extra;
        }
        field(50022; "Order Receiver"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; Package; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        field(50024; "Served BY"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Meal Served"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Catering Levy Amount"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50035; "Adjust Levy amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(64000; "ETR Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(64001; "ETR DateTime"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(64002; "ETR InvoiceExtension"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(64003; "ETR Msn"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(64004; "ETR Mtn"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(64005; "ETR VerificationUrl"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(64006; "ETR TotalAmount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(64007; "ETR RelevantNumber"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

}