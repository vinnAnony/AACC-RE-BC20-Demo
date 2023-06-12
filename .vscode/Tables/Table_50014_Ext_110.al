tableextension 50014 SalesShipmentHeaderExt extends "Sales Shipment Header"
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
    }

}