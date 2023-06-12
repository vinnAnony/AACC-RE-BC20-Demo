tableextension 50009 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(50000; "Withholding Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingTax));
        }
        field(50001; "Withholding Tax Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Withholding Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Withholding VAT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingVAT));
        }
        field(50005; "Withholding VAT Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Withholding VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}