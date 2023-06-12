table 50002 "Payment Voucher Header"
{

    fields
    {
        field(10; "PV No."; Code[20])
        {
        }
        field(20; Date; Date)
        {
        }
        field(30; Type; Option)
        {
            OptionCaption = 'Vendor,Customer,Direct';
            OptionMembers = Vendor,Customer,Direct;
        }
        field(40; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque;
        }
        field(50; "Cheque No."; Code[20])
        {
        }
        field(60; "Cheque Date"; Date)
        {
        }
        field(70; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(80; "Account Type"; Option)
        {
            InitValue = Vendor;
            OptionCaption = 'G/L Account,Customer,Vendor';
            OptionMembers = "G/L Account",Customer,Vendor;
        }
        field(90; "Supplier No."; Code[20])
        {
            TableRelation = Vendor;
        }
        field(100; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(110; "Amount Calculated"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(115; "Amount Calculated (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("Payment Voucher Line"."Amount (LCY)" WHERE ("PV No." = FIELD ("PV No.")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(117; Amount; Decimal)
        {
        }
        field(118; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Editable = false;
        }
        field(120; "Transaction Name"; Text[100])
        {
        }
        field(130; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Preparation,Cancelled,Posted,Posting';
            OptionMembers = Preparation,Cancelled,Posted,Posting;
        }
        field(140; "Prepared By"; Code[30])
        {
            Editable = false;
        }
        field(150; "Prepared Date"; Date)
        {
            Editable = false;
        }
        field(160; "Programme Officer"; Code[30])
        {
        }
        field(170; "Programme Officer App Date"; Date)
        {
        }
        field(180; "Finance Officer"; Code[30])
        {
        }
        field(190; "Finance Officer App Date"; Date)
        {
        }
        field(200; "Supplier Name"; Text[50])
        {
            Editable = false;
        }
        field(210; "Bank Name"; Text[50])
        {
        }
        field(220; "Reviewed By"; Code[30])
        {
        }
        field(230; "Reviewed Date"; Date)
        {
        }
        field(240; "First Signatory"; Code[30])
        {
        }
        field(250; "First Signatory Date"; Date)
        {
        }
        field(260; "Second Signatory"; Code[30])
        {
        }
        field(270; "Second Signatory Date"; Date)
        {
        }
        field(280; "Cheque/Cash Recieved By"; Text[50])
        {
        }
        field(290; "Cheque/Cash Recieved Date"; Date)
        {
        }
        field(300; "ID No./Passport No."; Code[30])
        {
        }
        field(310; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(315; "Currency Factor"; Decimal)
        {
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(320; "Global Dimension 1"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1),
                                                          Blocked = CONST (false));
        }
        field(330; "Global Dimension 2"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2),
                                                          Blocked = CONST (false));
        }
        field(331; "Shortcut Dimension 3 Code"; Code[20])
        {
        }
        field(332; "Shortcut Dimension 4 Code"; Code[20])
        {
        }
        field(333; "PV Description"; Text[30])
        {
            Caption = 'PV Description';
        }
        field(334; "PV Payee"; Text[30])
        {
            Caption = 'PV Payee';
        }
        field(335; "Payment Mode"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".Code;
        }
        field(336; "Payment Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Cash,Cheque,"Direct Banking";
        }
    }

    keys
    {
        key(Key1; "PV No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

