tableextension 50010 InvoicePostBufferExt extends "Invoice Post. Buffer"
{
    fields
    {
        field(50001; "Withholding Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingTax));
        }
        field(50002; "Withholding Tax Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Withholding Tax Amount"; Decimal)
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
        field(50007; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Description 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key2; Description)
        {

        }
    }

}