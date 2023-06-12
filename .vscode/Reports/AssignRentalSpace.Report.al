report 50003 "Assign Rental Space"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AssignRentalSpace.rdlc';

    dataset
    {
        dataitem(Resource; Resource)
        {
            DataItemTableView = SORTING ("No.") WHERE (Type = CONST (Property));

            trigger OnAfterGetRecord()
            begin

                if SaveFilters then begin
                    Resfilter := GetFilter("No.");
                    SaveFilters := false;
                end;
                SetFilter("No.", Resfilter);
                Resource.TestField("Resource Group No.");
                Resgrp.Get(Resource."Resource Group No.");
                if Resgrp."Rental Space" > 0 then begin
                    Resgrp.Validate(Resgrp."Occupied Space");
                    if QtytoAssign < Resgrp."Remaining Units" then
                        Resource."Rental Space" := QtytoAssign;
                    Modify(true);
                end;

                begin
                    Resgrp.CalcFields(Resgrp."Occupied Space");
                    Resgrp."Remaining Units" := Resgrp."Rental Space" - Resgrp."Occupied Space";
                    //Res.VALIDATE(Res."Rental Space");
                    Resgrp.Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin

                if QtytoAssign < 1 then
                    Error('Please specify they Quantity to Assign');

                SaveFilters := true;
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
        SaveFilters: Boolean;
        QtytoAssign: Decimal;
        Resfilter: Text[30];
        Resgrp: Record "Resource Group";
}

