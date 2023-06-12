tableextension 50027 ResourcesSetupExt extends "Resources Setup"
{
    fields
    {
        field(50000; "Rent Contract Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Prop. Mgmt';
            TableRelation = "No. Series";
        }
        field(50001; "Rent Contr Invoice Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Prop. Mgmt';
            TableRelation = "No. Series";
        }
        field(50002; "Rent Deposit Ac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Prop. Mgmt';
            TableRelation = "G/L Account";
        }
        field(50003; "Service Charge Ac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Prop. Mgmt';
            TableRelation = "G/L Account";
        }
        field(50004; "Deposit Bank Ac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Prop. Mgmt';
            TableRelation = "G/L Account";
        }
        field(50005; "Service Charge Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Reservation Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '//Added Field for Reservation Nos';
            TableRelation = "No. Series";
        }
        field(50011; "Other Guests Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '//Added Field for extra guets in any room';
            TableRelation = "No. Series";
        }
        field(50012; "Guest Bill"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50013; "Package Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50021; "Guest Hse Rcpt Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50022; "Conference Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50023; "Room Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50024; "Laundry Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50025; "Check Out Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Room Percentage Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}