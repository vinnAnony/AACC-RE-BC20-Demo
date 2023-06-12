tableextension 50005 VendorLedgerEntryExt extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "Withholding Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingTax));
        }
        field(50001; "Withholding VAT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingVAT));
        }
    }

}