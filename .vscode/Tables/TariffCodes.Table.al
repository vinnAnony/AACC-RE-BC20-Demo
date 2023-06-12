table 50005 "Tariff Codes"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Tariff Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Tariff Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = WithholdingTax,WithholdingVAT;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

