table 50006 "Tenant Invoicing Periods"
{

    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Name; Text[10])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';
            DataClassification = ToBeClassified;
        }
        field(4; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5804; "Average Cost Calc. Type"; Option)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Average Cost Calc. Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Item,Item & Location & Variant';
            OptionMembers = " ",Item,"Item & Location & Variant";
        }
        field(5805; "Average Cost Period"; Option)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Average Cost Period';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Day,Week,Month,Quarter,Year,Accounting Period';
            OptionMembers = " ",Day,Week,Month,Quarter,Year,"Accounting Period";
        }
        field(5806; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

