tableextension 50019 ResourceGroupExt extends "Resource Group"
{
    fields
    {
        field(50000; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Property,GuestHouse';
            OptionMembers = " ",Property,GuestHouse;
        }
        field(50001; "Property Types"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Rental Space",Parking,Room;
        }
        field(50002; "Rental Space"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(50003; "Std Service Charge"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(50004; "Occupied Space"; Decimal)
        {
            CalcFormula = Sum(Resource."Rental Space" WHERE(Type = CONST(Property),
                                                             "Resource Group No." = FIELD("No."),
                                                             "Resource Sub Type" = CONST("Rental Space"),
                                                             "Under Contract" = CONST(true)));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Remaining Units"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(50006; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(50007; "L/R No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Service Charge"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50011; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(50012; "Parking Space"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Occupied Parking"; Decimal)
        {
            CalcFormula = Sum(Resource."Rental Space" WHERE(Type = CONST(Property),
                                                             "Resource Group No." = FIELD("No."),
                                                             "Resource Sub Type" = CONST(Parking),
                                                             "Under Contract" = CONST(true)));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Subdivided Space"; Decimal)
        {
            CalcFormula = Sum(Resource."Rental Space" WHERE(Type = CONST(Property),
                                                             "Resource Group No." = FIELD("No."),
                                                             "Resource Sub Type" = CONST("Rental Space")));
            FieldClass = FlowField;
        }
        field(50015; "Subdivided Parking"; Decimal)
        {
            CalcFormula = Sum(Resource."Rental Space" WHERE(Type = CONST(Property),
                                                             "Resource Group No." = FIELD("No."),
                                                             "Resource Sub Type" = CONST(Parking)));
            FieldClass = FlowField;
        }
    }

}