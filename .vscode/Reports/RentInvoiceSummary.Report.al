report 50030 "Rent Invoice Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RentInvoiceSummary.rdlc';

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            column(Doc_No; "Sales Invoice Line"."Document No.")
            {
            }
            column(Tenant; InvoiceHeader."Bill-to Name")
            {
            }
            // column(Amount; "Sales Invoice Line"."Total Amount")
            // {
            // }
            column(Date; "Sales Invoice Line"."Posting Date")
            {
            }
            column(No; "Sales Invoice Line"."No.")
            {
            }
            column(FloorNo; FloorNo)
            {
            }
            column(PropertyNo; PropertyNo)
            {
            }
            column(UnitPrice; UnitPrice)
            {
            }
            column(Quantity; "Sales Invoice Line".Quantity)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Sales Invoice Line".SetRange("Sales Invoice Line"."Posting Date", StartDate, EndDate);
                ResourceRec.SetFilter("No.", "Sales Invoice Line"."No.");
                if ResourceRec.Find('-') then begin
                    FloorNo := Format(ResourceRec."Floor No.");
                    PropertyNo := ResourceRec."Resource Group No.";
                    UnitPrice := ResourceRec."Unit Price";
                end;
                InvoiceHeader.SetFilter("Sell-to Customer No.", "Sales Invoice Line"."Bill-to Customer No.");
                if InvoiceHeader.Find('-') then begin
                    TenantName := InvoiceHeader."Bill-to Name";
                end;

                // if "Sales Invoice Line"."Total Amount" = 0 then
                //     CurrReport.Skip;
                //MESSAGE('posting date is %1 documentno is %2',"Sales Invoice Line"."Posting Date","Sales Invoice Line"."Document No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                }
                field(EndDate; EndDate)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (StartDate <> 0D) and (EndDate <> 0D) then
            "Sales Invoice Line".SetRange("Sales Invoice Line"."Posting Date", StartDate, EndDate)
        else
            if StartDate <> 0D then
                "Sales Invoice Line".SetFilter("Posting Date", '>="Posting Date"', StartDate)
            else
                if EndDate <> 0D then
                    "Sales Invoice Line".SetFilter("Posting Date", '<="Posting Date"', EndDate);
    end;

    var
        ResourceRec: Record Resource;
        FloorNo: Code[100];
        PropertyNo: Code[100];
        UnitPrice: Decimal;
        InvoiceHeader: Record "Sales Invoice Header";
        TenantName: Code[100];
        StartDate: Date;
        EndDate: Date;
        PostingDate: Code[100];
}

