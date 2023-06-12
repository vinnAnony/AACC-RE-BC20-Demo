tableextension 50017 SalesCrMemoLineExt extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50002; "Rent Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Rent Contract Header"."Contract No.";
        }
        field(50021; "Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Main,Extra;
        }
        field(50022; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Contract,Parking';
            OptionMembers = " ",Contract,Parking;
        }
        field(50030; "Apply Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50031; "Catering Levy Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50032; "Entered Amount"; Decimal)
        {
            Caption = 'Unit Price 2';
            DataClassification = ToBeClassified;
        }
        field(50033; "Total Line Entered"; Decimal)
        {
            Caption = 'Amount Incl. VAT and Levy';
            DataClassification = ToBeClassified;
        }
        field(50036; "Resource Sub Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Rental Space,Parking,Service Charge';
            OptionMembers = "Rental Space",Parking,"Service Charge";
        }
    }

}