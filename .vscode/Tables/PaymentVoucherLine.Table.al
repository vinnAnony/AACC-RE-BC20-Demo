table 50003 "Payment Voucher Line"
{

    fields
    {
        field(10; "PV No."; Code[20])
        {
            TableRelation = "Payment Voucher Header"."PV No." WHERE ("PV No." = FIELD ("PV No."));
        }
        field(50; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Supplier,Bank Account,Employee';
            OptionMembers = "G/L Account",Customer,Supplier,"Bank Account",Employee;
        }
        field(60; "Account No."; Code[30])
        {
            TableRelation = IF ("Account Type" = CONST ("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST (Customer)) Customer
            ELSE
            IF ("Account Type" = CONST (Supplier)) Vendor
            ELSE
            IF ("Account Type" = CONST ("Bank Account")) "Bank Account";
        }
        field(70; Description; Text[150])
        {
        }
        field(75; "Vendor Ledger Entry No."; Integer)
        {
            TableRelation = IF ("Account Type" = CONST (Supplier)) "Vendor Ledger Entry"."Entry No." WHERE ("Vendor No." = FIELD ("Account No."),
                                                                                                         Open = CONST (true),
                                                                                                         "Remaining Amount" = FILTER (< 0));
        }
        field(80; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(90; Amount; Decimal)
        {
        }
        field(93; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(95; "Header Amount"; Decimal)
        {
        }
        field(140; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(150; "Global Dimension 1"; Code[20])
        {
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1),
                                                          Blocked = CONST (false));
        }
        field(160; "Global Dimension 2"; Code[20])
        {
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2),
                                                          Blocked = CONST (false));
        }
        field(170; "Invoice No."; Code[20])
        {
        }
        field(180; "Invoice Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(190; "Shortcut Dimension 3 Code"; Code[20])
        {
        }
        field(191; "Shortcut Dimension 4 Code"; Code[20])
        {
        }
        field(200; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = "G/L Account"."No." WHERE ("No." = FIELD ("Account No."));
        }
        field(201; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(202; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = ToBeClassified;
        }
        field(203; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
            DataClassification = ToBeClassified;
        }
        field(204; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "PV No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount (LCY)", "Header Amount";
        }
    }

    fieldgroups
    {
    }
}

