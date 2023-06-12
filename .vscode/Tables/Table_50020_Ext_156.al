tableextension 50020 ResourceExt extends Resource
{
    fields
    {
        field(50000; "Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Property Types"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Rental Space",Parking,Room;
        }
        field(50002; "Rental Space"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(50003; "Occupied Space"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Remaining Units"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Service Charge"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Under Contract"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Guest House Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Room,Laundry,Conference;
        }
        field(50011; "Room Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Single,Suite,Twin';
            OptionMembers = Single,Suite,Twin;
        }
        field(50012; "Room Status"; Option)
        {
            DataClassification = ToBeClassified;
            InitValue = "vacant and ready";
            OptionMembers = "Occupied Cont","Occupied checking out",vacant,"out of order","vacant and ready";
        }
        field(50013; "Room Reserved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Last Departure Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Last Arrival Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "No of Beds"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50032; "No. Of Pers"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "No of Pax"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50034; "Resource Sub Type"; Option)
        {
            Caption = 'Resource Sub Type';
            OptionCaption = 'Rental Space,Parking,Service Charge';
            OptionMembers = "Rental Space",Parking,"Service Charge";
        }
        field(50035; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Date Released"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Enabled = true;
        }
        field(50037; "Released By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Enabled = true;
        }
        field(50038; "Release Comments"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Floor No."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Ground floor,1st Floor,2nd Floor,3rd Floor,4th Floor,5th Floor,6th Floor,7th Floor';
            OptionMembers = " ","Ground floor","1st Floor","2nd Floor","3rd Floor","4th Floor","5th Floor","6th Floor","7th Floor";
        }
        field(50040; "Current Tenant"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key7; "Resource Sub Type")
        {
        }
    }
}