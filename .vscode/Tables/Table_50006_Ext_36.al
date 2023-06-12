tableextension 50006 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50000; "Rent Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Vega-NCM -To Identify documents created from Rent Contracts';
        }
        field(50001; "Member Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Guest Hse. Cat"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Room,Laundry,Conference,Restaurant;
        }
        field(50021; "Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Main,Extra;
        }
        field(50022; "Order Receiver"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; Package; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        field(50024; "Served BY"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Meal Served"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Apply Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50031; "Catering Levy Amount"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Catering Levy Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Prices incl. VAT and Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "VAT Calc"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Total Entered"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Total Line Entered" WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50035; "Adjust Levy amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Contract No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50037; "Property No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50038; "Invoice Period"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Tenant Invoicing Periods"."Starting Date";
        }
        field(50039; "General Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "No. of Months"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Amount Per Period"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Total Inclusive VAT"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Unit Price lcy" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50043; "Total Exclusive VAT"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Total Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "Period Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}