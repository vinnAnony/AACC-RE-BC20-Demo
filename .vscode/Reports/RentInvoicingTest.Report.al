report 50001 "Rent Invoicing - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RentInvoicingTest.rdlc';
    Caption = 'Contract Invoicing - Test';

    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            DataItemTableView = SORTING ("Contract No.") WHERE (Status = FILTER (Signed | Amended));
            RequestFilterFields = "Bill-to Customer No.", "Contract No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(InvoiceToDate; InvoiceToDate)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(Rent_Contract_Header__TABLECAPTION__________RentContractFilters; "Rent Contract Header".TableCaption + ': ' + RentContractFilters)
            {
            }
            column(Rent_Contract_Header__Contract_No__; "Contract No.")
            {
            }
            column(Rent_Contract_Header_Status; Status)
            {
            }
            column(Rent_Contract_Header__Customer_No__; "Customer No.")
            {
            }
            column(NoOfInvoicesTotal; NoOfInvoicesTotal)
            {
                AutoFormatType = 1;
            }
            column(Rent_Invoicing___TestCaption; Rent_Invoicing___TestCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(InvoiceToDateCaption; InvoiceToDateCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem("Rent Contract Line"; "Rent Contract Line")
            {
                DataItemLink = "Contract No." = FIELD ("Contract No.");
                column(Rent_Contract_Line__Resource_Code_; "Resource Code")
                {
                }
                column(Rent_Contract_Line_Description; Description)
                {
                }
                column(Rent_Contract_Line__Starting_Date_; "Starting Date")
                {
                }
                column(Rent_Contract_Line__Expiration_Date_; "Expiration Date")
                {
                }
                column(Rent_Contract_Line__Invoice_Period_; "Invoice Period")
                {
                }
                column(Rent_Contract_Line__Last_Invoice_Date_; "Last Invoice Date")
                {
                }
                column(Rent_Contract_Line__Next_Invoice_Date_; "Next Invoice Date")
                {
                }
                column(ResultDescription; ResultDescription)
                {
                }
                column(Rent_Contract_Line__Amount_per_Period_; "Amount per Period")
                {
                }
                column(NoOfInvoicesTotal_Control1102750018; NoOfInvoicesTotal)
                {
                    AutoFormatType = 1;
                }
                column(Rent_Contract_Line__Amount_per_Period__Control1102750019; "Amount per Period")
                {
                }
                column(Rent_Contract_Line__Resource_Code_Caption; FieldCaption("Resource Code"))
                {
                }
                column(Rent_Contract_Line_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Rent_Contract_Line__Starting_Date_Caption; FieldCaption("Starting Date"))
                {
                }
                column(Rent_Contract_Line__Expiration_Date_Caption; FieldCaption("Expiration Date"))
                {
                }
                column(Rent_Contract_Line__Invoice_Period_Caption; FieldCaption("Invoice Period"))
                {
                }
                column(Rent_Contract_Line__Last_Invoice_Date_Caption; FieldCaption("Last Invoice Date"))
                {
                }
                column(Rent_Contract_Line__Next_Invoice_Date_Caption; FieldCaption("Next Invoice Date"))
                {
                }
                column(Rent_Contract_Line__Amount_per_Period_Caption; FieldCaption("Amount per Period"))
                {
                }
                column(TotalCaption_Control1102750017; TotalCaption_Control1102750017Lbl)
                {
                }
                column(Rent_Contract_Line_Contract_No_; "Contract No.")
                {
                }
                column(Rent_Contract_Line_Line_No; "Line No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(RentContractMgt);
                    RentContractLine := "Rent Contract Line";
                    NoOfInvoices := 0;
                    with RentContractLine do begin
                        RentContractMgt.GetNextInvoicePeriod(RentContractLine, InvoiceFrom, InvoiceTo);
                        InvoicedAmount := Round(
                          RentContractMgt.CalcContractAmount(RentContractLine, InvoiceFrom, InvoiceTo),
                          Currency."Amount Rounding Precision");

                        if InvoicedAmount = 0 then
                            CurrReport.Skip;
                        repeat
                            TestField("Resource Code");
                            Res.Get("Resource Code");
                            if Prepaid then
                                TestField("Resource Code");
                            Cust.Get("Customer No.");
                            ResultDescription := '';
                            if "Amount per Period" > 0 then begin
                                if not RentContractMgt.CheckIfWithinInvoicePeriod(RentContractLine) then
                                    ResultDescription := StrSubstNo(Text007, RentContractLine."Expiration Date");
                                if ResultDescription = '' then begin
                                    /*
                                     IF (NOT "Combine Invoices") OR
                                        (LastCustomer <> "Bill-to Customer No.") OR
                                        (NOT LastContractCombined)
                                     THEN
                                     */
                                    NoOfInvoices := NoOfInvoices + 1;
                                    Validate("Last Invoice Date", "Next Invoice Date");
                                end;
                                LastCustomer := "Bill-to Customer No.";
                                //  LastContractCombined := "Combine Invoices";
                            end else
                                if "Annual Amount" = 0 then
                                    ResultDescription := StrSubstNo(Text007, FieldCaption("Annual Amount"))
                                else
                                    ResultDescription := '';
                            RentContractMgt.GetNextInvoicePeriod(RentContractLine, InvoiceFrom, InvoiceTo);
                        until ("Next Invoice Date" > InvoiceToDate) or
                              (ResultDescription <> '') or
                              ((InvoiceTo = 0D) and (InvoiceFrom = 0D));
                    end;
                    NoOfInvoicesTotal := NoOfInvoicesTotal + NoOfInvoices;

                end;

                trigger OnPreDataItem()
                begin
                    if PostingDate = 0D then
                        Error(Text000);

                    if PostingDate > WorkDate then
                        if not Confirm(Text001) then
                            Error(Text002);

                    if InvoiceToDate = 0D then
                        Error(Text003);

                    if InvoiceToDate > WorkDate then
                        if not Confirm(Text004) then
                            Error(Text002);

                    LastCustomer := '';
                    LastContractCombined := false;
                    Currency.InitRoundingPrecision;

                    CurrReport.CreateTotals("Amount per Period");
                    SetFilter("Next Invoice Date", '<>%1&<=%2', 0D, InvoiceToDate);
                    if (GetFilter("Invoice Period") <> '') then
                        SetFilter("Invoice Period", GetFilter("Invoice Period") + '&<>%1', "Invoice Period"::None)
                    else
                        SetFilter("Invoice Period", '<>%1', "Invoice Period"::None);
                end;
            }
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

    trigger OnInitReport()
    begin
        if PostingDate = 0D then
            PostingDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        RentContractFilters := "Rent Contract Header".GetFilters;
    end;

    var
        Text000: Label 'You have not filled in the posting date.';
        Text001: Label 'The posting date is later than the work date.\\Confirm that this is the correct date.';
        Text002: Label 'The program has stopped the batch job at your request.';
        Text003: Label 'You must fill in the Invoice-to Date field.';
        Text004: Label 'The Invoice-to Date is later than the work date.\\Confirm that this is the correct date.';
        Text006: Label '%1 is missing';
        Text007: Label '%1 is within the invoice period';
        Cust: Record Customer;
        RentContract: Record "Rent Contract Header" temporary;
        RentContractLine: Record "Rent Contract Line";
        Currency: Record Currency;
        RentContractMgt: Codeunit "Property Management";
        RentContractFilters: Text[250];
        NoOfInvoices: Integer;
        NoOfInvoicesTotal: Integer;
        ResultDescription: Text[80];
        PostingDate: Date;
        InvoiceToDate: Date;
        InvoiceFrom: Date;
        InvoiceTo: Date;
        LastCustomer: Code[20];
        LastContractCombined: Boolean;
        InvoicedAmount: Decimal;
        Res: Record Resource;
        Rent_Invoicing___TestCaptionLbl: Label 'Rent Invoicing - Test';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        InvoiceToDateCaptionLbl: Label 'Invoice to Date';
        PostingDateCaptionLbl: Label 'Posting Date';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control1102750017Lbl: Label 'Total';

    [Scope('Internal')]
    procedure InitVariables(LocalPostingDate: Date; LocalInvoiceToDate: Date)
    begin
        PostingDate := LocalPostingDate;
        InvoiceToDate := LocalInvoiceToDate;
    end;
}

