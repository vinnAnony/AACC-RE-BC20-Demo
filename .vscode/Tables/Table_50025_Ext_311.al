tableextension 50025 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Posted Charge to Works"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Charge to Works"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50004; Donations; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50005; Promotion; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50006; Defective; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50007; Specimen; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50008; Publication; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50009; WriteOFF; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Receipt Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50012; "Journal Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template"));
        }
        field(50013; "Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(50014; "Membership Subscription Ac"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50015; "Members Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50016; "Apply Catering Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Catering Levy %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Catering Levy A/C"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50020; "Reverse VAT and Levy %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Acceptable adjust"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}