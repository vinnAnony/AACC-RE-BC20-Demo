table 50000 "Rent Contract Header"
{
    // mj
    // added new field Property Desc

    Caption = 'Rent Contract Header';
    DataCaptionFields = "Contract No.", Name;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(2; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            OptionCaption = 'Contract,Parking';
            OptionMembers = Contract,Parking;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = ' ,Signed,Amended,Terminated';
            OptionMembers = " ",Signed,Amended,Terminated;
        }
        field(6; "Change Status"; Option)
        {
            Caption = 'Change Status';
            Editable = true;
            OptionCaption = 'Open,Locked';
            OptionMembers = Open,Locked;
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer WHERE ("Customer Types" = CONST (Tenants));
        }
        field(8; Name; Text[80])
        {
            CalcFormula = Lookup (Customer.Name WHERE ("No." = FIELD ("Customer No.")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Address; Text[30])
        {
            CalcFormula = Lookup (Customer.Address WHERE ("No." = FIELD ("Customer No.")));
            Caption = 'Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Address 2"; Text[30])
        {
            CalcFormula = Lookup (Customer."Address 2" WHERE ("No." = FIELD ("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Post Code"; Code[20])
        {
            CalcFormula = Lookup (Customer."Post Code" WHERE ("No." = FIELD ("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; City; Text[30])
        {
            CalcFormula = Lookup (Customer.City WHERE ("No." = FIELD ("Customer No.")));
            Caption = 'City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Contact Name"; Text[30])
        {
            Caption = 'Contact Name';
        }
        field(16; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer WHERE ("Customer Types" = CONST (Tenants));
        }
        field(17; "Bill-to Name"; Text[80])
        {
            CalcFormula = Lookup (Customer.Name WHERE ("No." = FIELD ("Bill-to Customer No.")));
            Caption = 'Bill-to Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Bill-to Address"; Text[30])
        {
            CalcFormula = Lookup (Customer.Address WHERE ("No." = FIELD ("Bill-to Customer No.")));
            Caption = 'Bill-to Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; Header; Boolean)
        {
            Editable = false;
        }
        field(20; "Property No."; Code[10])
        {
        }
        field(21; "Bill-to City"; Text[30])
        {
            CalcFormula = Lookup (Customer.City WHERE ("No." = FIELD ("Bill-to Customer No.")));
            Caption = 'Bill-to City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Combine Invoices"; Boolean)
        {
            Caption = 'Combine Invoices';
        }
        field(23; Prepaid; Boolean)
        {
            Caption = 'Prepaid';
        }
        field(24; "Next Invoice Period"; Text[30])
        {
            Caption = 'Next Invoice Period';
            Editable = false;
        }
        field(25; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(26; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(28; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(29; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(30; Comment; Boolean)
        {
            CalcFormula = Exist ("Service Comment Line" WHERE ("Table Name" = CONST ("Service Contract"),
                                                              "Table Subtype" = FIELD ("Contract Type"),
                                                              "No." = FIELD ("Contract No."),
                                                              "Table Line No." = FILTER (0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(32; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(33; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(34; "Name 2"; Text[30])
        {
            CalcFormula = Lookup (Customer."Name 2" WHERE ("No." = FIELD ("Customer No.")));
            Caption = 'Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Bill-to Name 2"; Text[30])
        {
            CalcFormula = Lookup (Customer."Name 2" WHERE ("No." = FIELD ("Bill-to Customer No.")));
            Caption = 'Bill-to Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(37; "Contract Deposit Amount"; Decimal)
        {
        }
        field(38; "No. of Unposted Invoices"; Integer)
        {
            CalcFormula = Count ("Sales Header" WHERE ("Document Type" = CONST (Invoice),
                                                      "Bill-to Customer No." = FIELD ("Bill-to Customer No."),
                                                      "Rent Invoice" = CONST (true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Sign Date"; Date)
        {
            Editable = false;
        }
        field(40; "Ammend Date"; Date)
        {
            Editable = false;
        }
        field(41; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(42; "Bill-to Address 2"; Text[30])
        {
            CalcFormula = Lookup (Customer."Address 2" WHERE ("No." = FIELD ("Bill-to Customer No.")));
            Caption = 'Bill-to Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Bill-to Post Code"; Code[20])
        {
            CalcFormula = Lookup (Customer."Post Code" WHERE ("No." = FIELD ("Bill-to Customer No.")));
            Caption = 'Bill-to Post Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(44; "Parking Slots"; Integer)
        {
            CalcFormula = Count ("Rent Contract Line" WHERE ("Contract No." = FIELD ("Contract No."),
                                                            "Contract Type" = CONST (Parking)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "Service Charge"; Decimal)
        {
            CalcFormula = Sum ("Rent Contract Line"."Service Charge" WHERE ("Contract No." = FIELD ("Contract No."),
                                                                           "Contract Type" = CONST (Contract)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; "Property No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Resource Group"."No.";
        }
        field(47; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(48; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = ToBeClassified;
        }
        field(49; "Last Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Contract Amount"; Decimal)
        {
            CalcFormula = Sum ("Rent Contract Line"."Amount per Month" WHERE ("Contract No." = FIELD ("Contract No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Next Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Property Desc"; Text[30])
        {
            CalcFormula = Lookup ("Resource Group".Name WHERE ("No." = FIELD ("Property No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Contract No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.")
        {
        }
        key(Key3; Description)
        {
        }
    }

    fieldgroups
    {
    }
}

