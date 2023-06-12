tableextension 50026 PurchasesPayablesSetupExt extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Payment No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Withholding Tax G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50002; "Withholding VAT G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

}