tableextension 50028 VATProductPostingGroupExt extends "VAT Product Posting Group"
{
    fields
    {
        field(50000; "Default Withholding VAT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingVAT));
        }
    }

}