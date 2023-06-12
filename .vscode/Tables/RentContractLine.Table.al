table 50001 "Rent Contract Line"
{
    // MJ
    // Added new field Property No.
    // Added new field Status
    // Added new field Name

    Caption = 'Rent Contract Line';
    Description = 'Rent Contract Line';

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Rent Contract Header"."Contract No.";
        }
        field(2; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Editable = false;
            OptionCaption = ' ,Contract,Parking';
            OptionMembers = " ",Contract,Parking;
        }
        field(3; "Resource Code"; Code[20])
        {
            Caption = 'Property Code';
            TableRelation = Resource."No." WHERE ("Rental Space" = FILTER (> 0));
        }
        field(4; "Contract Status"; Option)
        {
            Caption = 'Contract Status';
            OptionCaption = ' ,Signed,Canceled';
            OptionMembers = " ",Signed,Cancelled;
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(6; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(8; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(9; "Invoice Period"; Option)
        {
            Caption = 'Invoice Period';
            OptionCaption = 'Month,Two Months,Quarter,Half Year,Year,None';
            OptionMembers = Month,"Two Months",Quarter,"Half Year",Year,"None";
        }
        field(10; "Last Invoice Date"; Date)
        {
            Caption = 'Last Invoice Date';
            Editable = false;
        }
        field(11; "Next Invoice Date"; Date)
        {
            Caption = 'Next Invoice Date';
            Editable = false;
        }
        field(12; "Contract Deposit Amount"; Decimal)
        {
        }
        field(13; "Amount per Period"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount per Period';
            Editable = false;
        }
        field(14; "No of Units"; Decimal)
        {
            Editable = false;
        }
        field(15; "Resource Price"; Decimal)
        {
            Editable = false;
        }
        field(16; "Service Charge"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(18; "Parking Code"; Code[10])
        {
            TableRelation = "Work Type";
        }
        field(19; "Line No"; Integer)
        {
        }
        field(20; "Next Invoice Period Start"; Date)
        {
            Caption = 'Next Invoice Period Start';
            Editable = false;
        }
        field(21; "Next Invoice Period End"; Date)
        {
            Caption = 'Next Invoice Period End';
            Editable = false;
        }
        field(22; "Next Invoice Period"; Text[30])
        {
            Caption = 'Next Invoice Period';
            Editable = false;
        }
        field(23; "Annual Amount"; Decimal)
        {
        }
        field(24; Prepaid; Boolean)
        {
            Caption = 'Prepaid';
        }
        field(25; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(26; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(27; "Resource Sub Type"; Option)
        {
            Caption = 'Resource Sub Type';
            OptionCaption = 'Rental Space,Parking,Service Charge';
            OptionMembers = "Rental Space",Parking,"Service Charge";
        }
        field(28; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(29; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(30; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(31; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(32; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(33; "Floor No."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Ground Floor,1st Floor,2nd Floor,3rd Floor,4th Floor,5th Floor,6th Floor,7th Floor';
            OptionMembers = ,"Ground Floor","1st Floor","2nd Floor","3rd Floor","4th Floor","5th Floor","6th Floor","7th Floor";
        }
        field(34; "No. of Months"; Integer)
        {
            FieldClass = Normal;
        }
        field(35; "Amount per Month"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Amount Incl.VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Property No."; Code[50])
        {
            CalcFormula = Lookup ("Rent Contract Header"."Property No" WHERE ("Contract No." = FIELD ("Contract No.")));
            FieldClass = FlowField;
        }
        field(38; Status; Option)
        {
            CalcFormula = Lookup ("Rent Contract Header".Status WHERE ("Contract No." = FIELD ("Contract No.")));
            FieldClass = FlowField;
            OptionMembers = "BLANK ",Signed,Amended,Terminated;
        }
        field(39; Name; Text[50])
        {
            CalcFormula = Lookup ("Resource Group".Name WHERE ("No." = FIELD ("Property No.")));
            FieldClass = FlowField;
            NotBlank = true;
            TableRelation = "Resource Group".Name WHERE ("No." = FIELD ("Property No."));
        }
    }

    keys
    {
        key(Key1; "Contract No.", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Resource Code")
        {
            SumIndexFields = "No of Units";
        }
        key(Key3; "Customer No.")
        {
        }
        key(Key4; "Contract No.", "Contract Type")
        {
            SumIndexFields = "Service Charge", "No of Units";
        }
    }

    fieldgroups
    {
    }
}

