table 50004 "Reciept - Payment Lines"
{
    // KTM 27/11/19
    //  Disabled function in OnInsert and Doc No Onvalidate
    //  Changed Primary keys


    fields
    {
        field(1; "Doc No."; Code[20])
        {
            TableRelation = "Reciept - Payment Header"."Doc No.";
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Doc Type"; Option)
        {
            OptionMembers = Receipt,Deposit;
        }
        field(4; Description; Text[50])
        {
        }
        field(5; "Account No."; Code[20])
        {
        }
        field(7; "Currency Code"; Code[20])
        {
            Editable = true;
            TableRelation = Currency;
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; "Payment Method Code"; Code[20])
        {
            TableRelation = "Payment Method";
        }
        field(10; "No. Series"; Code[20])
        {
            TableRelation = "Payment Method";
        }
        field(11; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,Released;
        }
        field(12; Name; Text[50])
        {
            Editable = true;
        }
        field(13; "Amount In Words"; Text[200])
        {
        }
        field(14; "Cheque No"; Code[20])
        {
        }
        field(15; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Supplier,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
        }
        field(17; "Bal. Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor';
            OptionMembers = "G/L Account",Customer,Vendor;
        }
        field(18; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST (Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST (Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST ("G/L Account")) "G/L Account";
        }
        field(19; "Bal. Account Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(21; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(22; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
        }
        field(23; "Receiced From"; Text[100])
        {
        }
        field(24; "Cheque Date"; Date)
        {
        }
        field(25; Change; Decimal)
        {
        }
        field(26; Amount_Paid; Decimal)
        {
        }
        field(27; "Payment For"; Option)
        {
            OptionMembers = " ",Room,Laundry,Conference;
        }
        field(28; "Customer Code"; Code[20])
        {
        }
        field(29; "Contract Code"; Code[20])
        {
            TableRelation = "Rent Contract Header"."Contract No." WHERE (Header = CONST (true));
        }
        field(30; "Property Code"; Code[20])
        {
            TableRelation = "Rent Contract Header"."Property No." WHERE (Header = CONST (false),
                                                                         "Contract No." = FIELD ("Contract Code"));
        }
        field(31; "Deposit Entry No."; Integer)
        {
            TableRelation = "G/L Entry"."Entry No." WHERE ("Deposit Type" = CONST (Deposit),
                                                           "Customer Code" = FIELD ("Customer Code"),
                                                           Reversed = CONST (false),
                                                           Amount = FILTER (> 0));
        }
        field(70; "Sell To Cust."; Code[20])
        {
            TableRelation = Customer;
        }
        field(71; Posted; Boolean)
        {
        }
        field(72; "No. Printed"; Integer)
        {
        }
        field(73; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1),
                                                          Blocked = CONST (false));
        }
        field(74; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2),
                                                          Blocked = CONST (false));
        }
        field(75; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value";
        }
        field(76; "Entered By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Date Entered"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(78; "Time Entered"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(79; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(80; "Customer Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE ("Customer No." = FIELD ("Bal. Account No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD ("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD ("Global Dimension 2 Filter"),
                                                                                 "Currency Code" = FIELD ("Currency Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81; "Global Dimension 1 Filter"; Code[20])
        {
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(82; "Global Dimension 2 Filter"; Code[20])
        {
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(83; "Vendor Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE ("Vendor No." = FIELD ("Bal. Account No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD ("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD ("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = FIELD ("Currency Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(84; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(85; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Doc No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Bal. Account No.")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

