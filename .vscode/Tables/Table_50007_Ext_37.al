tableextension 50007 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; "Resource Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(50001; "Guest Hse. Cat"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Room,Laundry,Conference,Restaurant;
        }
        field(50002; "Rent Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Vega-NCM -To Identify documents created from Rent Contracts';
        }
        field(50003; "Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
            DataClassification = ToBeClassified;
        }
        field(50034; "No. of Months"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Amount Per Period"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Resource Sub Type"; Option)
        {
            Caption = 'Resource Sub Type';
            OptionCaption = 'Rental Space,Parking,Service Charge';
            OptionMembers = "Rental Space",Parking,"Service Charge";
        }
        field(50037; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "No. of Units"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Unit Price lcy"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Exclusive Total"; Decimal)
        {
        }
        field(50041; "Floor No"; Option)
        {
            OptionCaption = ' ,Ground floor,1st Floor,2nd Floor,3rd Floor,4th Floor,5th Floor,6th Floor,7th Floor';
            OptionMembers = " ","Ground floor","1st Floor","2nd Floor","3rd Floor","4th Floor","5th Floor","6th Floor","7th Floor";
        }
        field(50042; "Property No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

}