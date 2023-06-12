tableextension 50002 CustomerExt extends Customer
{
    fields
    {
        field(50000; "Customer Types"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","AACC Members",Tenants,Guests;
        }
        field(50001; "Check Out(Guests)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'To Close any further transactions for guests checking out';
        }
        field(50003; "Deposit Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Customer Code" = FIELD("No."),
                                                        "Deposit Type" = CONST(Deposit),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Refunded Deposit"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Customer Code" = FIELD("No."),
                                                        "Deposit Type" = CONST(Refund),
                                                        Amount = FILTER(> 0),
                                                        Reversed = CONST(false)));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Member Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Reservation Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Categorise reservation according to Group or Individual';
            OptionMembers = " ",Individual,Group;
        }
        field(50011; "Reservation Method"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Reservation Confirmation method-Letter/Deposit';
            OptionMembers = " ",Letter,Deposit;
        }
        field(50012; "Reservation Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Tentative,Confirmed,Amended,Terminated';
            OptionMembers = " ",Tentative,Amended,Confirmed,Terminated;
        }
        field(50020; "Identification No."; Code[20])
        {
            Caption = 'ID No./Passport';
            DataClassification = ToBeClassified;
        }
        field(50021; "Extra Bills Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50022; "Room Res. Status"; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionMembers = Tentative,Amended,Confirmed,Terminated;
        }
        field(50023; "Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Contract No."; Code[20])
        {
            CalcFormula = Lookup("Rent Contract Header"."Contract No." WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
            TableRelation = "Rent Contract Header"."Contract No." WHERE("Customer No." = FIELD("No."));
        }
        field(50025; "Contract Status"; Option)
        {
            CalcFormula = Lookup("Rent Contract Header".Status WHERE("Contract No." = FIELD("Contract No.")));
            FieldClass = FlowField;
            OptionCaption = '  ,Signed,Amended,Terminated';
            OptionMembers = " ",Signed,Amended,Terminated;
        }
    }

}