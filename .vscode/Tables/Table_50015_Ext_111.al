tableextension 50015 SalesShipmentLineExt extends "Sales Shipment Line"
{
    fields
    {
        field(50000; "Resource Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Property,GuestHouse;
        }
        field(50001; "Guest Hse. Cat"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Room,Laundry,Conference;
        }
        field(50021; "Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Main,Extra;
        }
        field(50022; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Contract,Parking';
            OptionMembers = " ",Contract,Parking;
        }
    }

}