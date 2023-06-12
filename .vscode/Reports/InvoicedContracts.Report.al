report 50040 "Invoiced Contracts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './InvoicedContracts.rdlc';
    Caption = '<Periodic Invoiced Contracts>';

    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            DataItemTableView = SORTING ("Contract No.") ORDER(Ascending) WHERE (Status = FILTER (" " | Signed | Amended));
            column(ContractNo_RentContractHeader; "Rent Contract Header"."Contract No.")
            {
            }
            column(Period__; DateFilter)
            {
            }
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "Contract No" = FIELD ("Contract No.");
                column(InvoiceNo_1; InvoiceNo[1])
                {
                }
                column(InvoiceNo_2; InvoiceNo[2])
                {
                }
                column(InvoiceNo_3; InvoiceNo[3])
                {
                }
                column(InvoiceNo_4; InvoiceNo[4])
                {
                }

                trigger OnAfterGetRecord()
                var
                    SaleInvHeader: Record "Sales Invoice Header";
                    Mydate: Date;
                begin
                    LineCount := 0;
                    Clear(InvoiceNo);

                    with TenantInvPeriod do begin
                        Reset;
                        SetFilter("Starting Date", '<=%1', StartDate);
                        if Find('+') then
                            PeriodStartDate := "Starting Date";
                    end;

                    with TenantInvPeriod do begin
                        Reset;
                        SetFilter("Starting Date", '>%1', EndDate);
                        if Find('-') then
                            PeriodEndDate := "Starting Date";
                    end;

                    //
                    FirstDateOfYear := CalcDate('<-CY>', PeriodStartDate);
                    LastDateOfYear := CalcDate('<CY>', PeriodEndDate);

                    //ERROR('Contract No %1 periodstart %2 period end %3', "Rent Contract Header"."Contract No.", PeriodStartDate, PeriodEndDate);

                    SalesInvoiceHeader.SetRange("Contract No", "Sales Invoice Header"."Contract No");
                    SalesInvoiceHeader.SetFilter("Invoice Period", '%1..%2', PeriodStartDate, PeriodEndDate);
                    if SalesInvoiceHeader.Find('-') then begin
                        LineCount := 0;
                        Clear(InvoiceNo);
                        with TenantInvPeriod do begin
                            Reset;
                            SetFilter("Starting Date", '%1..%2', FirstDateOfYear, LastDateOfYear);
                            if Find('-') then begin
                                repeat
                                    LineCount += 1;

                                    if LineCount = 1 then begin
                                        SaleInvHeader.SetRange("Contract No", "Sales Invoice Header"."Contract No");
                                        SaleInvHeader.SetFilter("Invoice Period", '%1', "Starting Date");
                                        SaleInvHeader.SetFilter(Reversed, '%1', false);
                                        if SaleInvHeader.Find('-') then begin
                                            if "Starting Date" = SaleInvHeader."Invoice Period" then
                                                InvoiceNo[1] := SaleInvHeader."Pre-Assigned No.";
                                        end else
                                            if "Starting Date" < "Sales Invoice Header"."Invoice Period" then begin
                                                InvoiceNo[1] := ' ';
                                            end else
                                                InvoiceNo[1] := 'Not Invoiced';
                                    end;

                                    if LineCount = 2 then begin
                                        SaleInvHeader.SetRange("Contract No", "Sales Invoice Header"."Contract No");
                                        SaleInvHeader.SetFilter("Invoice Period", '%1', "Starting Date");
                                        SaleInvHeader.SetFilter(Reversed, '%1', false);
                                        if SaleInvHeader.Find('-') then begin
                                            if "Starting Date" = SaleInvHeader."Invoice Period" then
                                                InvoiceNo[2] := SaleInvHeader."Pre-Assigned No.";
                                        end else
                                            if "Starting Date" < "Sales Invoice Header"."Invoice Period" then begin
                                                InvoiceNo[2] := '';
                                            end else
                                                InvoiceNo[2] := 'Not Invoiced';
                                        Mydate := SaleInvHeader."Invoice Period";
                                    end;

                                    if LineCount = 3 then begin
                                        SaleInvHeader.SetRange("Contract No", "Sales Invoice Header"."Contract No");
                                        SaleInvHeader.SetFilter("Invoice Period", '%1', "Starting Date");
                                        SaleInvHeader.SetFilter(Reversed, '%1', false);
                                        if SaleInvHeader.Find('-') then begin
                                            if "Starting Date" = SaleInvHeader."Invoice Period" then
                                                InvoiceNo[3] := SaleInvHeader."Pre-Assigned No.";
                                        end else
                                            if "Starting Date" < "Sales Invoice Header"."Invoice Period" then begin
                                                InvoiceNo[3] := ' ';
                                            end else
                                                InvoiceNo[3] := 'Not Invoiced';
                                    end;

                                    if LineCount = 4 then begin
                                        SaleInvHeader.SetRange("Contract No", "Sales Invoice Header"."Contract No");
                                        SaleInvHeader.SetFilter("Invoice Period", '%1', "Starting Date");
                                        SaleInvHeader.SetFilter(Reversed, '%1', false);
                                        if SaleInvHeader.Find('-') then begin
                                            if "Starting Date" = SaleInvHeader."Invoice Period" then
                                                InvoiceNo[4] := SaleInvHeader."Pre-Assigned No.";
                                        end else
                                            if "Starting Date" < "Sales Invoice Header"."Invoice Period" then begin
                                                InvoiceNo[4] := ' ';
                                            end else
                                                InvoiceNo[4] := 'Not Invoiced';
                                    end;

                                    //IF LineCount = 3 THEN
                                    // ERROR('count is  %1 starting date %2 sales in date %3', LineCount, "Starting Date", Mydate);

                                until Next = 0;
                            end;
                        end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Rent Contract Header".SetFilter("Starting Date", DateFilter);
                StartDate := "Rent Contract Header".GetRangeMin("Starting Date");
                EndDate := "Rent Contract Header".GetRangeMax("Starting Date");
                if StartDate > EndDate then
                    Error(Text002);
                StartYear := Date2DMY(StartDate, 3);
                EndYear := Date2DMY(EndDate, 3);
                if StartYear <> EndYear then
                    Error(Text003);
                //
                //
            end;

            trigger OnPreDataItem()
            begin
                if DateFilter = '' then
                    Error(Text001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(DateFilter; DateFilter)
                {
                    Caption = 'Period';
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

    var
        InvoiceNo: array[4] of Code[50];
        DateFilter: Text[200];
        Text001: Label 'Period must have a value';
        StartDate: Date;
        EndDate: Date;
        Text002: Label 'Start date cannot be greater than end date';
        TenantInvPeriod: Record "Tenant Invoicing Periods";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        StartYear: Integer;
        EndYear: Integer;
        Text003: Label 'The period range has to be in the same Year';
        FirstDateOfYear: Date;
        LastDateOfYear: Date;
        LineCount: Integer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
}

