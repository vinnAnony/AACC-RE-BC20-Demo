report 50000 "Create Rent Invoice"
{
    //   IGO 11/01/08 - posting date changed to begining of the quarter
    DefaultLayout = RDLC;
    RDLCLayout = './CreateRentInvoice.rdlc';


    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            DataItemTableView = SORTING ("Contract No.") WHERE (Status = CONST (Signed));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Contract No.";
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(Rent_Contract_Header__Contract_No__; "Contract No.")
            {
            }
            column(Rent_Contract_Header_Description; Description)
            {
            }
            column(Rent_Contract_Invoice_TestCaption; Rent_Contract_Invoice_TestCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            dataitem(Contract; "Rent Contract Line")
            {
                DataItemLink = "Contract No." = FIELD ("Contract No.");
                DataItemTableView = SORTING ("Contract No.", "Line No");
                column(Contract__Resource_Code_; "Resource Code")
                {
                }
                column(Contract_Description; Description)
                {
                }
                column(Contract__Starting_Date_; "Starting Date")
                {
                }
                column(Contract__Expiration_Date_; "Expiration Date")
                {
                }
                column(Contract__Amount_per_Period_; "Amount per Period")
                {
                }
                column(Contract__Service_Charge_; "Service Charge")
                {
                }
                column(Contract__Contract_Type_; "Contract Type")
                {
                }
                column(Contract_Contract_No_; "Contract No.")
                {
                }
                column(Contract_Line_No; "Line No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Post = true then begin
                        //Calculate Invoice frequency
                        case Contract."Invoice Period" of
                            Contract."Invoice Period"::Month:
                                LinePrice := Contract."Resource Price";
                            Contract."Invoice Period"::"Two Months":
                                LinePrice := Contract."Resource Price" * 2;
                            Contract."Invoice Period"::Quarter:
                                LinePrice := Contract."Resource Price" * 3;
                            Contract."Invoice Period"::"Half Year":
                                LinePrice := Contract."Resource Price" * 6;
                            Contract."Invoice Period"::Year:
                                LinePrice := Contract."Resource Price" * 12;
                            Contract."Invoice Period"::None:
                                LinePrice := 0;
                        end;

                        //Create the Line
                        LineNo := SL."Line No.";
                        SL.Init;
                        SL."Document Type" := SL."Document Type"::Invoice;
                        SL."Document No." := SH."No.";
                        SL."Line No." := LineNo + 10000;
                        SL.Type := SL.Type::Resource;
                        SL.Validate(SL."No.", Contract."Resource Code");
                        SL."Sell-to Customer No." := SH."Bill-to Customer No.";
                        SL.Validate(Quantity, Contract."No of Units");
                        SL.Description := Contract.Description;
                        SL.Validate("Unit Price", LinePrice);
                        SL."Contract Code" := Contract."Contract No.";
                        SL."Contract Type" := Contract."Contract Type";
                        SL.Insert;

                        //Post the Invoice

                        //Update Next Invoice Date
                        Validate("Last Invoice Date", "Next Invoice Date");
                        Modify;
                    end;
                end;

                trigger OnPostDataItem()
                begin

                    //Service Charge
                    if Post = true then begin
                        ResSetup.Get;
                        Contract.Reset;
                        "Rent Contract Header".CalcFields("Service Charge");
                        LineNo := SL."Line No.";
                        SL.Init;
                        SL."Document Type" := SL."Document Type"::Invoice;
                        SL."Document No." := SH."No.";
                        SL."Line No." := LineNo + 30000;
                        SL.Type := SL.Type::"G/L Account";
                        SL.Validate("No.", ResSetup."Service Charge Ac");
                        SL.Description := 'Service Charge';
                        Contract.SetCurrentKey("Contract No.", "Contract Type");
                        Contract.SetRange("Contract No.", Contract."Contract No.");
                        Contract.SetRange(Contract."Contract Type", "Contract Type"::Contract);
                        Contract.CalcSums(Contract."No of Units");
                        SL.Validate(Quantity, Contract."No of Units");


                        case Contract."Invoice Period" of
                            Contract."Invoice Period"::Month:
                                PeriodServCharge := "Rent Contract Header"."Service Charge";
                            Contract."Invoice Period"::"Two Months":
                                PeriodServCharge := "Rent Contract Header"."Service Charge" * 2;
                            Contract."Invoice Period"::Quarter:
                                PeriodServCharge := "Rent Contract Header"."Service Charge" * 3;
                            Contract."Invoice Period"::"Half Year":
                                PeriodServCharge := "Rent Contract Header"."Service Charge" * 6;
                            Contract."Invoice Period"::Year:
                                PeriodServCharge := "Rent Contract Header"."Service Charge" * 12;
                            Contract."Invoice Period"::None:
                                PeriodServCharge := 0;
                        end;

                        if PeriodServCharge > ResSetup."Service Charge Limit" then
                            SL.Validate("Unit Price", ResSetup."Service Charge Limit")
                        else
                            SL.Validate("Unit Price", PeriodServCharge);

                        SL."Contract Code" := Contract."Contract No.";
                        SL.Insert;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Contract.SetFilter("Next Invoice Period Start", '>= %1', StartDate);
                    Contract.SetFilter("Next Invoice Period End", '<=%1', EndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Post = true then begin
                    ResSetup.Get;
                    SH.Init;
                    SH."Document Type" := SH."Document Type"::Invoice;
                    /*SH.VALIDATE("Posting Date",EndDate);
                    SH.VALIDATE("Document Date",EndDate);  IGO 11/01/08*/
                    SH.Validate("Posting Date", StartDate);
                    SH.Validate("Document Date", StartDate);

                    SH."No." := NoSeries.GetNextNo(ResSetup."Rent Contr Invoice Nos.", Today, true);
                    SH.Validate("Sell-to Customer No.", "Rent Contract Header"."Bill-to Customer No.");
                    SH."Allow Line Disc." := false;
                    SH."Rent Invoice" := true;
                    SH."Invoice Period" := StartDate;
                    SH.Insert;
                end;

            end;

            trigger OnPostDataItem()
            begin
                if Post = true then begin
                    SalesPost.Run(SH);
                end;
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

    trigger OnPreReport()
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Error(Text001);
        if StartDate > EndDate then
            Error(Text000);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        Post: Boolean;
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        SRSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit NoSeriesManagement;
        LineNo: Integer;
        ResSetup: Record "Resources Setup";
        LinePrice: Decimal;
        Text000: Label 'The End Date cannot be an earlier date than the Start date';
        Text001: Label 'Both Start and End dates must be provided';
        SalesPost: Codeunit "Sales-Post";
        PeriodServCharge: Decimal;
        Rent_Contract_Invoice_TestCaptionLbl: Label 'Rent Contract Invoice Test';
        PeriodCaptionLbl: Label 'Period';
}

