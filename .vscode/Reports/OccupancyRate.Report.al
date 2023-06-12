report 50020 "Occupancy Rate"
{
    DefaultLayout = RDLC;
    RDLCLayout = './OccupancyRate.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Occupancy Rate';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Resource Group"; "Resource Group")
        {
            column(No; "Resource Group"."No.")
            {
            }
            column(Name; "Resource Group".Name)
            {
            }
            column(RentalSpace; "Resource Group"."Rental Space")
            {
            }
            column(UOM; "Resource Group"."Base Unit of Measure")
            {
            }
            column(OccupiedSpace; "Resource Group"."Occupied Space")
            {
            }
            column(OccupiedSpacePC; OccupiedRentalPC)
            {
            }
            column(ParkingSpace; "Resource Group"."Parking Space")
            {
            }
            column(OccupiedParking; "Resource Group"."Occupied Parking")
            {
            }
            column(OccupiedParkingPC; OccupiedParkingPC)
            {
            }
            column(SubdividedSpace_ResourceGroup; "Resource Group"."Subdivided Space")
            {
            }
            column(SubdividedParking_ResourceGroup; "Resource Group"."Subdivided Parking")
            {
            }
            column(OccupiedParking_ResourceGroup; "Resource Group"."Occupied Parking")
            {
            }
            column(TotalParkingPC__; TotalParkingPC)
            {
            }
            column(TotalOccupiedRentalPC__; TotalOccupiedRentalPC)
            {
            }
            column(VacantSpace; VacantSpace)
            {
            }

            trigger OnAfterGetRecord()
            begin
                OccupiedRentalPC := 0;
                OccupiedParkingPC := 0;
                OccupiedParking := 0;
                ParkingSpace := 0;
                OccupiedSpace := 0;
                RentalSpace := 0;
                VacantSpace := 0;
                CalcFields("Occupied Space", "Occupied Parking");
                if ("Occupied Space" > 0) and ("Rental Space" > 0) then
                    OccupiedRentalPC := ("Occupied Space" / "Rental Space") * 100;
                VacantSpace := "Rental Space" - "Occupied Space";

                if ("Occupied Parking" > 0) and ("Parking Space" > 0) then
                    OccupiedParkingPC := ("Occupied Parking" / "Parking Space") * 100;

                OccupiedRentalPC := Round(OccupiedRentalPC, 0.1);
                OccupiedParkingPC := Round(OccupiedParkingPC, 0.1);

                if ResourceGroup.Find('-') then begin

                    repeat
                        ResourceGroup.CalcFields("Occupied Space", "Occupied Parking");
                        OccupiedParking += ResourceGroup."Occupied Parking";
                        ParkingSpace += ResourceGroup."Parking Space";
                        OccupiedSpace += ResourceGroup."Occupied Space";
                        RentalSpace += ResourceGroup."Rental Space";
                    until ResourceGroup.Next = 0;
                end;

                //Occupied parking vs parking space
                if ParkingSpace = 0 then
                    TotalParkingPC := 0
                else
                    TotalParkingPC := (OccupiedParking / ParkingSpace) * 100;

                //Occupied space vs rental space
                if RentalSpace = 0 then
                    TotalOccupiedRentalPC := 0
                else
                    TotalOccupiedRentalPC := (OccupiedSpace / RentalSpace) * 100;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        OccupiedRentalPC: Decimal;
        OccupiedParkingPC: Decimal;
        OccupiedParking: Decimal;
        ParkingSpace: Decimal;
        TotalParkingPC: Decimal;
        TotalOccupiedPC: Decimal;
        OccupiedSpace: Decimal;
        RentalSpace: Decimal;
        TotalOccupiedRentalPC: Decimal;
        ResourceGroup: Record "Resource Group";
        VacantSpace: Decimal;
}

