codeunit 50000 "Property Management"
{
    // //ktm 09/27/2019 added SH."General Description" := SH."Period Name";
    // //KTM 27/11/2019 Modified Function for applying entries to reciept
    // //KTM 09/01/2020 Added Function LockResource and UnlockResource
    // //VEGA/VNM 21/09/2022 Added functions to post Invoice to ETR API

    Permissions = TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd;

    trigger OnRun()
    begin
    end;

    var
        LineNo: Integer;
        RecSet: Record "Sales & Receivables Setup";
        GenJnl: Record "Gen. Journal Line";
        ResSetup: Record "Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesHeader: Record "Sales Header";
        DimMgt: Codeunit DimensionManagement;
        SalesLineNo: Integer;
        SalesLine: Record "Sales Line";
        Res: Record Resource;
        TempSalesLineDescription: Text[30];
        Text000: Label '%1 cannot be created for rent contract  %2, because %3 and %4 are not equal.';
        Text002: Label 'Rental Contract: %1';
        Text003: Label 'Rental contract line(s) included in:';
        Text004: Label 'A credit memo cannot be created, because the %1 %2 is after the work date.';
        Text005: Label '%1 %2 removed';
        Text006: Label 'Do you want to create a rent invoice for the period %1 .. %2';
        Text007: Label 'Sales Invoice cannot be created because amount to invoice for this invoice period is zero.';
        Text008: Label 'The combination of dimensions used in %1 %2 is blocked. %3.';
        Text009: Label 'The dimensions used in %1 %2 are invalid. %3.';
        Text010: Label 'You cannot create an invoice for contract %1 before the service under this contract is completed because the %2 check box is selected.';
        Text011: Label 'You cannot create an invoice for contract %1 because %2 is within the invoice period.';
        Text012: Label 'You must fill in the New Customer No. field.';
        Text013: Label '%1 cannot be created because the %2 is too long. Please shorten the %3 %4 %5 by removing %6 character(s).';
        Text014: Label 'You cannot Sign a cancelled contract.';
        Text015: Label 'The %1 has not been provided.//Is this ok?';
        Text016: Label 'The contracts initial invoice will not include a deposit amount.';
        Text017: Label '%1 must be the first date of the month';
        Text018: Label '%1 must be the last date of the month';
        Text019: Label 'Do You Want to sign the - %1 -Contract? ';
        Text020: Label 'The Contract has been signed!';
        GL: Record "G/L Account";
        SalesHead: Record "Sales Header";
        Selection: Integer;
        SalesPost: Codeunit "Sales-Post";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        ReportSelection: Record "Report Selections";
        Text021: Label 'Do You wish to Terminate contract -%1 ? Note that this change is permanent.';
        Text022: Label 'You cannot sign rent contract %1,\because some %2s have a missing %3.';
        LineNum: Integer;
        Text023: Label 'You cannot sign rent contract %1,\because some %2s have a missing %3.';
        Text024: Label 'There are no lines on this contract!';
        Text025: Label 'Please specify the start date for all lines';
        PVLine: Record "Payment Voucher Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        EmplLedgEntry: Record "Employee Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        ApplyEmplEntries: Page "Apply Employee Entries";
        AccNo: Code[20];
        CurrencyCode2: Code[10];
        OK: Boolean;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        PVHead: Record "Payment Voucher Header";
        Text000P: Label 'You must specify %1 or %2.';
        ConfirmChangeQst: Label 'CurrencyCode in the %1 will be changed from %2 to %3.\Do you wish to continue?', Comment = '%1 = Table Name, %2 and %3 = Currency Code';
        UpdateInterruptedErr: Label 'The update has been interrupted to respect the warning.';
        Text005P: Label 'The %1 or %2 must be Customer or Vendor.';
        Text006P: Label 'All entries in one application must be in the same currency.';
        Text007P: Label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
        Text026: Label 'Property %1 already under contract no. %2';
        Text027: Label 'Invoice No. %1 created successfully.';
        Text028: Label 'Are you sure you would like to create an invoice for this contract?';
        Text029: Label 'The Contract is over. Please Ammend or Create a new contract.';
        NoOfMnthGlobal: Integer;
        ReceiptHeader2: Record "Reciept - Payment Header";

    [Scope('Internal')]
    procedure GetNextInvoicePeriod(InvoicedRentContractHeader: Record "Rent Contract Line"; var InvFrom: Date; var InvTo: Date)
    begin
        InvFrom := InvoicedRentContractHeader."Next Invoice Period Start";
        InvTo := InvoicedRentContractHeader."Next Invoice Period End";
    end;

    [Scope('Internal')]
    procedure CheckIfWithinInvoicePeriod(RentContractHeader: Record "Rent Contract Line"): Boolean
    var
        ServContractLine: Record "Rent Contract Line";
    begin
        if (RentContractHeader."Date Filter" >= RentContractHeader."Next Invoice Period Start") and
        (RentContractHeader."Date Filter" <= RentContractHeader."Next Invoice Period End") then
            exit(true);
    end;

    [Scope('Internal')]
    procedure CalcContractAmount(RentContractHeader: Record "Rent Contract Line"; PeriodStarts: Date; PeriodEnds: Date) AmountCalculated: Decimal
    var
        ServContractLine: Record "Service Contract Line";
        Currency: Record Currency;
        LinePeriodStarts: Date;
        LinePeriodEnds: Date;
        ContractLineIncluded: Boolean;
    begin
        Currency.InitRoundingPrecision;
        AmountCalculated := 0;

        if RentContractHeader."Date Filter" <> 0D then begin
            if RentContractHeader."Date Filter" < PeriodStarts then
                exit;
            if (RentContractHeader."Date Filter" >= PeriodStarts) and
               (RentContractHeader."Date Filter" <= PeriodEnds)
            then
                PeriodEnds := RentContractHeader."Date Filter";
        end;

        //RentContractHeader.CALCFIELDS("Resource Price");
        AmountCalculated := RentContractHeader."No of Units" * RentContractHeader."Resource Price";

        AmountCalculated := Round(AmountCalculated, Currency."Amount Rounding Precision");
    end;

    [Scope('Internal')]
    procedure ReleaseDoc(var ReceiptLine: Record "Reciept - Payment Lines")
    begin
        LineNo := 10;
        RecSet.Get;
        GenJnl.SetFilter(GenJnl."Journal Template Name", RecSet."Journal Template");
        GenJnl.SetFilter(GenJnl."Journal Batch Name", RecSet."Journal Batch");
        if GenJnl.FindLast then begin
            LineNo := GenJnl."Line No." + 1;
        end;
    end;

    [Scope('Internal')]
    procedure ReopenDoc(var ReceiptLine_par: Record "Reciept - Payment Lines")
    begin
        if ReceiptLine_par.Status = ReceiptLine_par.Status::Open then
            Error('The Receipt is already Open.')
        else begin
            ReceiptLine_par.Status := ReceiptLine_par.Status::Open;
            ReceiptLine_par.Modify;
        end;
    end;

    [Scope('Internal')]
    procedure CreateSalesHeader(ServContract2: Record "Rent Contract Header"; ContractNo: Code[20]; PostDate: Date; ContractExists: Boolean) SalesInvNo: Code[20]
    var
        SalesHeader2: Record "Sales Header";
        Cust: Record Customer;
        ServDocReg: Record "Service Document Register";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PostDate = 0D then
            PostDate := WorkDate;

        Clear(SalesHeader2);
        SalesHeader2.Init;
        SalesHeader2.SetHideValidationDialog(true);
        SalesHeader2."Document Type" := SalesHeader2."Document Type"::Invoice;
        ResSetup.Get;
        ResSetup.TestField("Rent Contr Invoice Nos.");
        NoSeriesMgt.InitSeries(
          ResSetup."Rent Contr Invoice Nos.", '',
          PostDate, SalesHeader2."No.", SalesHeader2."No. Series");
        SalesHeader2.Insert(true);
        SalesInvNo := SalesHeader2."No.";
        SalesHeader2."Shipment Date" := WorkDate;
        SalesHeader2."Order Date" := WorkDate;
        SalesHeader2."Posting Description" :=
          Format(SalesHeader2."Document Type") + ' ' + SalesHeader2."No.";
        SalesHeader2.Validate("Bill-to Customer No.", ServContract2."Bill-to Customer No.");

        if ServContract2."Combine Invoices" then begin
            SalesHeader2."Sell-to Customer No." := ServContract2."Bill-to Customer No.";
        end else begin
            SalesHeader2."Sell-to Customer No." := ServContract2."Customer No.";
        end;


        Cust.Get(SalesHeader2."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, SalesHeader."Document Type", false, false);
        Cust.TestField("Gen. Bus. Posting Group");
        Cust.TestField(Cust."Customer Posting Group");
        SalesHeader2."Sell-to Customer Name" := Cust.Name;
        SalesHeader2."Sell-to Customer Name 2" := Cust."Name 2";
        SalesHeader2."Sell-to Address" := Cust.Address;
        SalesHeader2."Sell-to Address 2" := Cust."Address 2";
        SalesHeader2."Sell-to City" := Cust.City;
        SalesHeader2."Sell-to Post Code" := Cust."Post Code";
        SalesHeader2."Sell-to County" := Cust.County;
        SalesHeader2."Sell-to Country/Region Code" := Cust."Country/Region Code";
        SalesHeader2."Sell-to Contact" := Cust.Contact;
        /*
        IF NOT ContractExists THEN
          IF SalesHeader2."Sell-to Customer No." = ServContract2."Customer No." THEN
            SalesHeader2.VALIDATE("Ship-to Code",ServContract2."Ship-to Code");
        */
        SalesHeader2.Validate("Posting Date", PostDate);
        SalesHeader2.Validate("Document Date", PostDate);
        SalesHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        SalesHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
        SalesHeader2."Rent Invoice" := true;
        SalesHeader2."Currency Code" := ServContract2."Currency Code";
        SalesHeader2."Currency Factor" :=
          CurrExchRate.ExchangeRate(
            SalesHeader2."Posting Date", SalesHeader2."Currency Code");
        SalesHeader2.Validate("Payment Terms Code", ServContract2."Payment Terms Code");
        SalesHeader2."Shortcut Dimension 1 Code" := ServContract2."Shortcut Dimension 1 Code";
        SalesHeader2."Shortcut Dimension 2 Code" := ServContract2."Shortcut Dimension 2 Code";
        SalesHeader2.Modify;

    end;

    [Scope('Internal')]
    procedure CreateSalesLine(SalesHeader: Record "Sales Header"; ContractType: Integer; ContractNo: Code[20]; LineNum: Integer; InvFrom: Date; InvTo: Date; InvoiceAmount: Decimal; ServiceApplyEntry: Integer; SignningContract: Boolean)
    var
        RentContractLine: Record "Rent Contract Line";
        Cust: Record Customer;
        PeriodAmt: Decimal;
    begin
        RentContractLine.Get(ContractType, ContractNo, LineNum);
        if RentContractLine."Invoice Period" = RentContractLine."Invoice Period"::None then
            exit;
        Cust.Get(RentContractLine."Customer No.");
        SalesLineNo := 0;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.Find('+') then
            SalesLineNo := SalesLine."Line No.";
        SalesLine.Reset;
        SalesLine.Init;
        SalesLineNo := SalesLineNo + 10000;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := SalesLineNo;
        SalesLine.Type := SalesLine.Type::Resource;
        SalesLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        SalesLine."Location Code" := SalesHeader."Location Code";
        SalesLine."Shipment Date" := SalesHeader."Shipment Date";
        SalesLine.Validate(SalesLine.Quantity, RentContractLine."No of Units");
        SalesLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
        //SalesLine."Job No." := SalesHeader."Job No.";
        SalesLine.Validate("Gen. Bus. Posting Group", SalesHeader."Gen. Bus. Posting Group");
        SalesLine."Transaction Specification" := SalesHeader."Transaction Specification";
        if RentContractLine.Prepaid and not SignningContract then begin
            RentContractLine.TestField(RentContractLine."Resource Code");
            Res.Get(RentContractLine."Resource Code");
            Res.TestField(Res."No.");
            SalesLine.Validate(SalesLine."No.", Res."No.");
        end;
        SalesLine."Transport Method" := SalesHeader."Transport Method";
        SalesLine."Exit Point" := SalesHeader."Exit Point";
        SalesLine.Area := SalesHeader.Area;
        SalesLine.Description := Res.Name + ' ' + 'Rent for ' + ' ' + StrSubstNo('%1 - %2', Format(InvFrom), Format(InvTo));

        //Calculate Preiod amounts
        case RentContractLine."Invoice Period" of
            RentContractLine."Invoice Period"::Month:
                PeriodAmt := RentContractLine."Resource Price" * RentContractLine."No of Units" * 1;
            RentContractLine."Invoice Period"::"Two Months":
                PeriodAmt := RentContractLine."Resource Price" * RentContractLine."No of Units" * 2;
            RentContractLine."Invoice Period"::Quarter:
                PeriodAmt := RentContractLine."Resource Price" * RentContractLine."No of Units" * 3;
            RentContractLine."Invoice Period"::"Half Year":
                PeriodAmt := RentContractLine."Resource Price" * RentContractLine."No of Units" * 6;
            RentContractLine."Invoice Period"::Year:
                PeriodAmt := RentContractLine."Resource Price" * RentContractLine."No of Units" * 12;
            RentContractLine."Invoice Period"::None:
                PeriodAmt := 0;
        end;

        SalesLine."Unit Price" := RentContractLine."No of Units";
        SalesLine."Line Amount" := PeriodAmt;
        // SalesLine.VALIDATE("Line Discount %");
        SalesLine."Rent Invoice" := true;
        //SalesLine.VALIDATE(Amount);
        SalesLine."Contract Code" := ContractNo;
        SalesLine.Insert;
    end;

    [Scope('Internal')]
    procedure AmountToFCY(AmountLCY: Decimal; var SalesHeader3: Record "Sales Header"): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    begin
        Currency.Get(SalesHeader3."Currency Code");
        Currency.TestField("Unit-Amount Rounding Precision");
        exit(
          Round(
            CurrExchRate.ExchangeAmtLCYToFCY(
              SalesHeader3."Posting Date", SalesHeader3."Currency Code",
              AmountLCY, SalesHeader3."Currency Factor"),
              Currency."Unit-Amount Rounding Precision"));
    end;

    [Scope('Internal')]
    procedure CreateLastSalesLines(SalesHeader: Record "Sales Header"; ContractType: Integer; ContractNo: Code[20]; LineNum: Integer)
    var
        RentContractHeader: Record "Rent Contract Header";
        RentContractLine: Record "Rent Contract Line";
        StdText: Record "Standard Text";
        Cust: Record Customer;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ResSetup2: Record "Resources Setup";
        Service: Decimal;
    begin
        RentContractLine.Get(ContractType, ContractNo, LineNum);
        if RentContractLine."Invoice Period" = RentContractLine."Invoice Period"::None then
            exit;
        Cust.Get(RentContractLine."Customer No.");
        if RentContractLine."Service Charge" > 0 then begin
            SalesLine.Init;
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine.Type := SalesLine.Type::"G/L Account";

            ResSetup.Get;
            ResSetup.TestField("Service Charge Ac");
            SalesLine."No." := ResSetup."Service Charge Ac";
            //SalesLine."Service Contract No." := ContractNo;
            SalesLine.Description := 'Service Charge';
            if SalesLine.Description <> '' then begin
                SalesLineNo := SalesLineNo + 10000;
                SalesLine."Line No." := SalesLineNo;
                SalesLine.Validate(Quantity, RentContractLine."No of Units");
                // RentContractLine.CALCFIELDS("Service Charge");
                SalesLine.Validate("Unit Price", RentContractLine."Resource Price");

                GL.Get(ResSetup."Service Charge Ac");
                SalesLine."Gen. Bus. Posting Group" := GL."Gen. Bus. Posting Group";
                SalesLine."Gen. Prod. Posting Group" := GL."Gen. Prod. Posting Group";
                SalesLine."Contract Code" := ContractNo;
                SalesLine."Rent Invoice" := true;
                SalesLine.Insert;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure CreateAllSalesLines(InvNo: Code[20]; RentContractToInvoice: Record "Rent Contract Line"; InvoicedAmount: Decimal)
    var
        InvoiceFrom: Date;
        InvoiceTo: Date;
        ServiceApplyEntry: Integer;
        ServContractLine: Record "Service Contract Line";
        SalesHeader: Record "Sales Header";
        rescodes: Code[10];
    begin

        GetNextInvoicePeriod(RentContractToInvoice, InvoiceFrom, InvoiceTo);
        with RentContractToInvoice do begin
            if SalesHeader.Get(SalesHeader."Document Type"::Invoice, InvNo) then begin

                CreateSalesLine(
                  SalesHeader, "Contract Type", "Contract No.", "Line No",
                  InvoiceFrom, InvoiceTo, InvoicedAmount, ServiceApplyEntry, false);

                CreateLastSalesLines(SalesHeader, "Contract Type", "Contract No.", "Line No");
                // VALIDATE("E-Mail","Name 2");
                RentContractToInvoice.Modify;

            end;
        end;
    end;

    [Scope('Internal')]
    procedure SignContract(FromRentContractHeader: Record "Rent Contract Header")
    var
        RentContractLine: Record "Rent Contract Line";
        RentContractHeader: Record "Rent Contract Header";
        NoOfMonths: Integer;
        NoOfDays: Integer;
        InvFrom: Date;
        InvTo: Date;
        TempDate: Date;
        InvNo: Code[20];
    begin
        RentContractHeader := FromRentContractHeader;
        if RentContractHeader.Status = FromRentContractHeader.Status::Signed then
            exit;
        if RentContractHeader.Status = FromRentContractHeader.Status::Amended then
            exit;
        if RentContractHeader.Status = FromRentContractHeader.Status::Terminated then
            exit;
        RentContractHeader.TestField(RentContractHeader."Customer No.");
        RentContractHeader.TestField(RentContractHeader."Bill-to Customer No.");
        //RMM 29/09/2018 - Start Dates and more
        RentContractHeader.TestField(RentContractHeader."Starting Date");
        RentContractHeader.TestField(RentContractHeader."Expiration Date");
        RentContractHeader.TestField(RentContractHeader."Property No");

        //Check if contract has lines
        RentContractLine.Reset;
        RentContractLine.SetRange("Contract No.", RentContractHeader."Contract No.");
        if not RentContractLine.FindFirst then
            Error(Text024);

        //Check for missing property codes
        RentContractLine.Reset;
        RentContractLine.SetRange("Contract No.", RentContractHeader."Contract No.");
        RentContractLine.SetRange("Resource Code", '');
        if RentContractLine.Find('-') then
            if RentContractLine."Resource Code" = '' then
                Error(Text023,
                 RentContractHeader."Contract No.",
                 RentContractLine.TableCaption,
                 RentContractLine.FieldCaption("Resource Code"));

        /*//Check -Start Dates
        RentContractLine.RESET;
        RentContractLine.SETRANGE("Contract No.",RentContractHeader."Contract No.");
        RentContractLine.SETRANGE("Starting Date",0D);
        IF RentContractLine.FINDFIRST THEN
         ERROR(Text025);*/



        //Check -Line Amounts
        RentContractLine.Reset;
        RentContractLine.SetRange("Contract No.", RentContractHeader."Contract No.");
        RentContractLine.SetRange("Amount per Period", 0);
        if RentContractLine.Find('-') then
            Error(Text022,
            RentContractHeader."Contract No.",
            RentContractLine.TableCaption,
            RentContractLine.FieldCaption("Amount per Period"));

        RentContractHeader.Status := FromRentContractHeader.Status::Signed;
        RentContractHeader."Change Status" := FromRentContractHeader."Change Status"::Locked;
        RentContractHeader."Sign Date" := WorkDate;

        RentContractHeader.Modify;
        //RMM 29/09/2018 Lock Resource
        //Check if locked
        //
        //KTM 09/01/19 Commented  this and moved to Action Lock Contract
        //
        //
        // RentContractLine.RESET;
        // RentContractLine.SETRANGE("Contract No.",RentContractHeader."Contract No.");
        // IF RentContractLine.FIND('-') THEN
        //  BEGIN
        //    REPEAT
        //      Res.RESET;
        //      //Res.SETRANGE(Res."Resource Group No.",RentContractHeader."Property No");
        //      Res.SETRANGE(Res."No.",RentContractLine."Resource Code");
        //      Res.SETRANGE(Res."Under Contract",FALSE);
        //      IF NOT Res.FIND('-') THEN
        //        ERROR(Res."No.",Res."Contract Code");
        //    UNTIL RentContractLine.NEXT=0;
        //  END;
        //
        // RentContractLine.RESET;
        // RentContractLine.SETRANGE("Contract No.",RentContractHeader."Contract No.");
        // IF RentContractLine.FIND('-') THEN
        //  BEGIN
        //    REPEAT
        //      Res.RESET;
        //      //Res.SETRANGE(Res."Resource Group No.",RentContractHeader."Property No");
        //      Res.SETRANGE(Res."No.",RentContractLine."Resource Code");
        //      IF Res.FIND('-') THEN
        //        BEGIN
        //         IF Res."Resource Group No." <> 'PARKING' THEN
        //          Res."Under Contract":=TRUE;
        //
        //          Res."Contract Code":=RentContractHeader."Contract No.";
        //          Res.MODIFY;
        //          END;
        //    UNTIL RentContractLine.NEXT=0;
        //  END;
        //
        //END KTM 09/01/20
        Message(Text020);

    end;

    [Scope('Internal')]
    procedure TerminateContract(FromRentContractHeader: Record "Rent Contract Header"; ContractNo: Code[10])
    var
        Res: Record Resource;
        RentLines: Record "Rent Contract Line";
    begin
        FromRentContractHeader.SetRange(FromRentContractHeader."Contract No.");
        if FromRentContractHeader.Status = FromRentContractHeader.Status::Terminated then
            exit;
        if FromRentContractHeader.Status = FromRentContractHeader.Status::" " then
            exit;
        if not
              Confirm(
                  Text021, false,
                  FromRentContractHeader."Contract No.")
              then
            exit;

        //Release property from terminated contracts
        RentLines.SetRange("Contract No.", FromRentContractHeader."Contract No.");
        if RentLines.Find('-') then
            repeat
                if Res.Get(RentLines."Resource Code") then
                    Res."Under Contract" := false;
                Res."Contract Code" := '';
                Res."Date Released" := Today;
                Res."Released By" := UserId;
                Res."Release Comments" := 'Contract Terminated';
                Res.Modify
             until RentLines.Next = 0;

        begin
            FromRentContractHeader.Status := FromRentContractHeader.Status::Terminated;
            FromRentContractHeader."Change Status" := FromRentContractHeader."Change Status"::Locked;
            FromRentContractHeader.Modify;
        end;
    end;

    [Scope('Internal')]
    procedure NoOfDayInYear(InputDate: Date): Integer
    var
        W1: Date;
        W2: Date;
        YY: Integer;
    begin
        YY := Date2DMY(InputDate, 3);
        W1 := DMY2Date(1, 1, YY);
        W2 := DMY2Date(31, 12, YY);
        exit(W2 - W1 + 1);
    end;

    [Scope('Internal')]
    procedure NoOfDaysInMonth(WDay: Date): Integer
    var
        FirstDay: Date;
        LastDay: Date;
    begin
        FirstDay := CalcDate('<-CM>', WDay);
        LastDay := CalcDate('<CM>', WDay);
        exit(LastDay - FirstDay + 1);
    end;

    [Scope('Internal')]
    procedure NoOfMonthsAndDaysInPeriod(Day1: Date; Day2: Date; var NoOfMonthsInPeriod: Integer; var NoOfDaysInPeriod: Integer)
    var
        Wdate: Date;
        FirstDayinCrntMonth: Date;
        LastDayinCrntMonth: Date;
    begin
        NoOfMonthsInPeriod := 0;
        NoOfDaysInPeriod := 0;

        if Day1 > Day2 then
            exit;
        if Day1 = 0D then
            exit;
        if Day2 = 0D then
            exit;

        Wdate := Day1;
        repeat
            FirstDayinCrntMonth := CalcDate('<-CM>', Wdate);
            LastDayinCrntMonth := CalcDate('<CM>', Wdate);
            if (Wdate = FirstDayinCrntMonth) and (LastDayinCrntMonth <= Day2) then begin
                NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
                Wdate := LastDayinCrntMonth + 1;
            end else begin
                NoOfDaysInPeriod := NoOfDaysInPeriod + 1;
                Wdate := Wdate + 1;
            end;
        until Wdate > Day2;
    end;

    [Scope('Internal')]
    procedure "Post Sales"(var SalesHeader: Record "Sales Header")
    begin
        SalesHead.Copy(SalesHeader);
        Code;
        SalesHead := SalesHeader;
    end;

    [Scope('Internal')]
    procedure "Code"()
    begin
        with SalesHead do begin
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        Selection := StrMenu(Text000, 3);
                        if Selection = 0 then
                            exit;
                        Ship := Selection in [1, 3];
                        Invoice := Selection in [2, 3];
                    end;
                "Document Type"::"Return Order":
                    begin
                        Selection := StrMenu(Text002, 3);
                        if Selection = 0 then
                            exit;
                        Receive := Selection in [1, 3];
                        Invoice := Selection in [2, 3];
                    end else
                            if not
                               Confirm(
                                 Text000, false,
                                 "Document Type")
                            then
                                exit;
            end;
            SalesPost.Run(SalesHead);


            Commit;
        end;
    end;

    [Scope('Internal')]
    procedure ReleaseSalesOrder(var SalesHead: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        NotOnlyDropShipment: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        InvtSetup: Record "Inventory Setup";
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
    begin
        with SalesHead do begin

            if Status = Status::Released then
                exit;

            if ("Document Type" = "Document Type"::Quote) then
                if CheckCustomerCreated(true) then
                    Get("Document Type"::Quote, "No.")
                else
                    exit;

            TestField("Sell-to Customer No.");

            SalesLine.SetRange("Document Type", "Document Type");
            SalesLine.SetRange("Document No.", "No.");
            SalesLine.SetFilter(Type, '>0');
            SalesLine.SetFilter(Quantity, '<>0');
            if not SalesLine.Find('-') then
                Error(Text000, "Document Type", "No.");
            InvtSetup.Get;
            if (InvtSetup."Location Mandatory") then begin
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                if SalesLine.Find('-') then
                    repeat
                        SalesLine.TestField("Location Code");
                    until SalesLine.Next = 0;
                SalesLine.SetFilter(Type, '>0');
            end;
            SalesLine.SetRange("Drop Shipment", false);
            NotOnlyDropShipment := SalesLine.Find('-');
            SalesLine.Reset;

            SalesSetup.Get;
            if SalesSetup."Calc. Inv. Discount" then begin
                CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", SalesLine);
                Get("Document Type", "No.");
            end;

            Status := Status::Released;

            SalesLine.SetSalesHeader(SalesHead);
            SalesLine.CalcVATAmountLines(0, SalesHead, SalesLine, TempVATAmountLine0);
            SalesLine.CalcVATAmountLines(1, SalesHead, SalesLine, TempVATAmountLine1);
            SalesLine.UpdateVATOnLines(0, SalesHead, SalesLine, TempVATAmountLine0);
            SalesLine.UpdateVATOnLines(1, SalesHead, SalesLine, TempVATAmountLine1);

            Modify(true);

            if NotOnlyDropShipment then
                if "Document Type" in ["Document Type"::Order, "Document Type"::"Return Order"] then
                    WhseSalesRelease.Release(SalesHead);

        end;
    end;

    [Scope('Internal')]
    procedure ReOpenSalesOrder(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        InvtSetup: Record "Inventory Setup";
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
    begin
        with SalesHeader do begin
            if Status = Status::Open then
                exit;
            if "Document Type" in ["Document Type"::Order, "Document Type"::"Return Order"] then
                WhseSalesRelease.Reopen(SalesHeader);
            Status := Status::Open;
            SalesLine.SetSalesHeader(SalesHeader);
            SalesLine.SetRange("Document Type", "Document Type");
            SalesLine.SetRange("Document No.", "No.");
            SalesLine.SetFilter(Type, '>0');
            SalesLine.SetFilter(Quantity, '<>0');
            if SalesLine.Find('-') then
                repeat
                    SalesLine.Amount := 0;
                    SalesLine."Amount Including VAT" := 0;
                    SalesLine."VAT Base Amount" := 0;
                    SalesLine.InitOutstandingAmount;
                    SalesLine.Modify;
                until SalesLine.Next = 0;
            SalesLine.Reset;
            Modify(true);
        end;
    end;

    [Scope('Internal')]
    procedure "Post Sales + Print"(var Rec: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        ReportSelection: Record "Report Selections";
        SalesPost: Codeunit "Sales-Post";
        Selection: Integer;
    begin
        SalesHeader.Copy(Rec);
        Code_Print;
        Rec := SalesHeader;
    end;

    local procedure Code_Print()
    begin
        with SalesHeader do begin
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        Selection := StrMenu(Text000, 3);
                        if Selection = 0 then
                            exit;
                        Ship := Selection in [1, 3];
                        Invoice := Selection in [2, 3];
                    end;
                "Document Type"::"Return Order":
                    begin
                        Selection := StrMenu(Text002, 3);
                        if Selection = 0 then
                            exit;
                        Receive := Selection in [1, 3];
                        Invoice := Selection in [2, 3];
                    end else
                            if not
                               Confirm(
                                 Text000, false,
                                 "Document Type")
                            then
                                exit;
            end;

            SalesPost.Run(SalesHeader);

            GetReport_Order(SalesHeader);

            /*IF Ship AND WebSite.FIND('-') THEN
              NotificationMgt.SendOrderShipMail(SalesHeader); */

            Commit;
        end;

    end;

    [Scope('Internal')]
    procedure GetReport_Order(var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        if Ship then begin
                            SalesShptHeader."No." := "Last Shipping No.";
                            SalesShptHeader.SetRecFilter;
                            PrintReport_Order(ReportSelection.Usage::"S.Shipment");
                        end;
                        if Invoice then begin
                            SalesInvHeader."No." := "Last Posting No.";
                            SalesInvHeader.SetRecFilter;
                            PrintReport_Order(ReportSelection.Usage::"S.Invoice");
                        end;
                    end;
                "Document Type"::Invoice:
                    begin
                        if "Last Posting No." = '' then
                            SalesInvHeader."No." := "No."
                        else
                            SalesInvHeader."No." := "Last Posting No.";
                        SalesInvHeader.SetRecFilter;
                        PrintReport_Order(ReportSelection.Usage::"S.Invoice");
                    end;
                "Document Type"::"Return Order":
                    begin
                        if Receive then begin
                            ReturnRcptHeader."No." := "Last Return Receipt No.";
                            ReturnRcptHeader.SetRecFilter;
                            PrintReport_Order(ReportSelection.Usage::"S.Ret.Rcpt.");
                        end;
                        if Invoice then begin
                            SalesCrMemoHeader."No." := "Last Posting No.";
                            SalesCrMemoHeader.SetRecFilter;
                            PrintReport_Order(ReportSelection.Usage::"S.Cr.Memo");
                        end;
                    end;
                "Document Type"::"Credit Memo":
                    begin
                        if "Last Posting No." = '' then
                            SalesCrMemoHeader."No." := "No."
                        else
                            SalesCrMemoHeader."No." := "Last Posting No.";
                        SalesCrMemoHeader.SetRecFilter;
                        PrintReport_Order(ReportSelection.Usage::"S.Cr.Memo");
                    end;
            end;
        end;
    end;

    local procedure PrintReport_Order(ReportUsage: Integer)
    begin
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage, ReportUsage);
        ReportSelection.Find('-');
        repeat
            ReportSelection.TestField("Report ID");
            case ReportUsage of
                ReportSelection.Usage::"S.Invoice":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesInvHeader);
                ReportSelection.Usage::"S.Cr.Memo":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesCrMemoHeader);
                ReportSelection.Usage::"S.Shipment":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesShptHeader);
                ReportSelection.Usage::"S.Ret.Rcpt.":
                    REPORT.Run(ReportSelection."Report ID", false, false, ReturnRcptHeader);
            end;
        until ReportSelection.Next = 0;
    end;

    [Scope('Internal')]
    procedure Open(Rent: Record "Rent Contract Header"; ContractNo: Code[10])
    begin
        Rent.SetRange(Rent."Contract No.");

        if Rent.Status = Rent.Status::Terminated then
            Error('You are not allowed to edit a terminated contract');

        begin
            repeat
                if Rent."Change Status" = Rent."Change Status"::Open then
                    exit;

                begin
                    Rent."Change Status" := Rent."Change Status"::Open;
                    Rent.Modify;
                end;
            until Rent.Next = 0;
        end;

        //KTM 09/01/2020 Unlock Resource
        UnlockResource(ContractNo);
        //KTM end
    end;

    [Scope('Internal')]
    procedure Lock(Rent: Record "Rent Contract Header"; ContractNo: Code[10])
    begin
        Rent.SetRange(Rent."Contract No.");
        begin
            repeat
                if Rent."Change Status" = Rent."Change Status"::Locked then
                    exit;
                begin
                    Rent."Change Status" := Rent."Change Status"::Locked;
                    Rent.Modify;
                end;
            until Rent.Next = 0;
        end;

        //KTM 09/01/2020 Lock resource
        LockResource(ContractNo);
        //KTM END
    end;

    [Scope('Internal')]
    procedure GetDate() DateVal: Date
    begin
        exit(Today)
    end;

    local procedure UpdateCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        with PVLine do begin
            PVHead.Get(PVLine."PV No.");
            CustLedgEntry.CalcFields("Remaining Amount");
            CustLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                CustLedgEntry."Remaining Amount", CustLedgEntry."Currency Code", "Currency Code", PVHead.Date);
            CustLedgEntry."Remaining Amount" :=
              Round(CustLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
            CustLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                CustLedgEntry."Remaining Pmt. Disc. Possible", CustLedgEntry."Currency Code", "Currency Code", PVHead.Date);
            CustLedgEntry."Remaining Pmt. Disc. Possible" :=
              Round(CustLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
            CustLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                CustLedgEntry."Amount to Apply", CustLedgEntry."Currency Code", "Currency Code", PVHead.Date);
            CustLedgEntry."Amount to Apply" :=
              Round(CustLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
        end;
    end;

    local procedure UpdateVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        with PVLine do begin
            PVHead.Get(PVLine."PV No.");
            VendLedgEntry.CalcFields("Remaining Amount");
            VendLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                VendLedgEntry."Remaining Amount", VendLedgEntry."Currency Code", "Currency Code", PVHead.Date);
            VendLedgEntry."Remaining Amount" :=
              Round(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
            VendLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                VendLedgEntry."Remaining Pmt. Disc. Possible", VendLedgEntry."Currency Code", "Currency Code", PVHead.Date);
            VendLedgEntry."Remaining Pmt. Disc. Possible" :=
              Round(VendLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
            VendLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                VendLedgEntry."Amount to Apply", VendLedgEntry."Currency Code", "Currency Code", PVHead.Date);
            VendLedgEntry."Amount to Apply" :=
              Round(VendLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
        end;
    end;

    procedure CheckAgainstApplnCurrency(ApplnCurrencyCode: Code[10]; CompareCurrencyCode: Code[10]; AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset"; Message: Boolean): Boolean
    var
        Currency: Record Currency;
        Currency2: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CurrencyAppln: Option No,EMU,All;
    begin
        if ApplnCurrencyCode = CompareCurrencyCode then
            exit(true);

        case AccType of
            AccType::Customer:
                begin
                    SalesSetup.Get;
                    CurrencyAppln := SalesSetup."Appln. between Currencies";
                    case CurrencyAppln of
                        CurrencyAppln::No:
                            begin
                                if ApplnCurrencyCode <> CompareCurrencyCode then
                                    if Message then
                                        Error(Text006)
                                    else
                                        exit(false);
                            end;
                        CurrencyAppln::EMU:
                            begin
                                GLSetup.Get;
                                if not Currency.Get(ApplnCurrencyCode) then
                                    Currency."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency2.Get(CompareCurrencyCode) then
                                    Currency2."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency."EMU Currency" or not Currency2."EMU Currency" then
                                    if Message then
                                        Error(Text007)
                                    else
                                        exit(false);
                            end;
                    end;
                end;
            AccType::Vendor:
                begin
                    PurchSetup.Get;
                    CurrencyAppln := PurchSetup."Appln. between Currencies";
                    case CurrencyAppln of
                        CurrencyAppln::No:
                            begin
                                if ApplnCurrencyCode <> CompareCurrencyCode then
                                    if Message then
                                        Error(Text006)
                                    else
                                        exit(false);
                            end;
                        CurrencyAppln::EMU:
                            begin
                                GLSetup.Get;
                                if not Currency.Get(ApplnCurrencyCode) then
                                    Currency."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency2.Get(CompareCurrencyCode) then
                                    Currency2."EMU Currency" := GLSetup."EMU Currency";
                                if not Currency."EMU Currency" or not Currency2."EMU Currency" then
                                    if Message then
                                        Error(Text007)
                                    else
                                        exit(false);
                            end;
                    end;
                end;
        end;

        exit(true);
    end;

    local procedure GetCurrency()
    begin
        with PVLine do begin
            if "Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                Currency.Get("Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    local procedure ApplyEmployeeLedgerEntry(var GenJnlLine: Record "Gen. Journal Line")
    begin
        with GenJnlLine do begin
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", AccNo);
            EmplLedgEntry.SetRange(Open, true);
            if "Applies-to ID" = '' then
                "Applies-to ID" := "Document No.";
            if "Applies-to ID" = '' then
                Error(
                  Text000,
                  FieldCaption("Document No."), FieldCaption("Applies-to ID"));
            ApplyEmplEntries.SetGenJnlLine(GenJnlLine, FieldNo("Applies-to ID"));
            ApplyEmplEntries.SetRecord(EmplLedgEntry);
            ApplyEmplEntries.SetTableView(EmplLedgEntry);
            ApplyEmplEntries.LookupMode(true);
            OK := ApplyEmplEntries.RunModal = ACTION::LookupOK;
            Clear(ApplyEmplEntries);
            if not OK then
                exit;
            EmplLedgEntry.Reset;
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", AccNo);
            EmplLedgEntry.SetRange(Open, true);
            EmplLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if EmplLedgEntry.Find('-') then begin
                if Amount = 0 then begin
                    repeat
                        Amount := Amount - EmplLedgEntry."Amount to Apply";
                    until EmplLedgEntry.Next = 0;
                    if ("Bal. Account Type" = "Bal. Account Type"::Customer) or
                       ("Bal. Account Type" = "Bal. Account Type"::Vendor) or
                       ("Bal. Account Type" = "Bal. Account Type"::Employee)
                    then
                        Amount := -Amount;
                    Validate(Amount);
                end;
                "Applies-to Doc. Type" := 0;
                "Applies-to Doc. No." := '';
            end else
                "Applies-to ID" := '';
            if Modify then;
        end;
    end;

    [Scope('Internal')]
    procedure ApplyPaymentEntries(Rec: Record "Payment Voucher Line")
    var
        PVLine: Record "Payment Voucher Line";
        PVHeader: Record "Payment Voucher Header";
    begin
        PVLine.Copy(Rec);

        //OnBeforeRun(PVLine);

        with PVLine do begin
            GetCurrency;
            if "Account Type" in
               ["Account Type"::Customer, "Account Type"::Supplier, "Account Type"::Employee]
            then begin
                /*AccType := "Account Type";
                AccNo := "Bal. Account No.";
              END ELSE BEGIN*/
                AccType := "Account Type";
                AccNo := "Account No.";
            end;
            case AccType of
                AccType::Customer:
                    begin
                        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                        CustLedgEntry.SetRange("Customer No.", AccNo);
                        CustLedgEntry.SetRange(Open, true);
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := PVLine."PV No.";
                        if "Applies-to ID" = '' then
                            Error(
                              Text000,
                              FieldCaption(PVLine."PV No."), FieldCaption("Applies-to ID"));
                        // ApplyCustEntries.SetGenJnlLinePV(PVLine, FieldNo("Applies-to ID"));
                        ApplyCustEntries.SetRecord(CustLedgEntry);
                        ApplyCustEntries.SetTableView(CustLedgEntry);
                        ApplyCustEntries.LookupMode(true);
                        OK := ApplyCustEntries.RunModal = ACTION::LookupOK;
                        Clear(ApplyCustEntries);
                        if not OK then
                            exit;

                        CustLedgEntry.Reset;
                        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                        CustLedgEntry.SetRange("Customer No.", AccNo);
                        CustLedgEntry.SetRange(Open, true);
                        CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if CustLedgEntry.Find('-') then begin
                            CurrencyCode2 := CustLedgEntry."Currency Code";
                            if Amount = 0 then begin
                                repeat
                                    // PaymentToleranceMgt.DelPmtTolApllnDocNoPV(PVLine, CustLedgEntry."Document No.");
                                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                                    UpdateCustLedgEntry(CustLedgEntry);
                                // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCustPV(Rec, CustLedgEntry, 0, false) and
                                //    (Abs(CustLedgEntry."Amount to Apply") >=
                                //     Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
                                // then
                                //     Amount := Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                                // else
                                //     Amount := Amount - CustLedgEntry."Amount to Apply";
                                until CustLedgEntry.Next = 0;
                                /*IF ("Account Type" = "Account Type"::Customer) OR
                                   ("Account Type" = "Account Type"::Vendor)
                                THEN
                                  Amount := -Amount;
                                VALIDATE(Amount);*/
                            end else
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                                until CustLedgEntry.Next = 0;
                            if "Currency Code" <> CurrencyCode2 then
                                if Amount = 0 then begin
                                    if not
                                       Confirm(
                                         ConfirmChangeQst, true, TableCaption, "Currency Code", CustLedgEntry."Currency Code")
                                    then
                                        Error(UpdateInterruptedErr);
                                    "Currency Code" := CustLedgEntry."Currency Code"
                                end else
                                    CheckAgainstApplnCurrency("Currency Code", CustLedgEntry."Currency Code", AccType::Customer, true);
                            "Applies-to Doc. Type" := 0;
                            "Applies-to Doc. No." := '';
                        end else
                            "Applies-to ID" := '';
                        Modify;
                        // if Rec.Amount <> 0 then
                        // if not PaymentToleranceMgt.PmtTolGenJnlPV(PVLine) then
                        //     exit;
                    end;
                AccType::Vendor:
                    begin
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", AccNo);
                        VendLedgEntry.SetRange(Open, true);
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := "PV No.";
                        if "Applies-to ID" = '' then
                            Error(
                              Text000,
                              FieldCaption("PV No."), FieldCaption("Applies-to ID"));
                        // ApplyVendEntries.SetGenJnlLinePV(PVLine, FieldNo("Applies-to ID"));
                        ApplyVendEntries.SetRecord(VendLedgEntry);
                        ApplyVendEntries.SetTableView(VendLedgEntry);
                        ApplyVendEntries.LookupMode(true);
                        OK := ApplyVendEntries.RunModal = ACTION::LookupOK;
                        Clear(ApplyVendEntries);
                        if not OK then
                            exit;

                        VendLedgEntry.Reset;
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", AccNo);
                        VendLedgEntry.SetRange(Open, true);
                        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if VendLedgEntry.Find('-') then begin
                            CurrencyCode2 := VendLedgEntry."Currency Code";
                            if Amount = 0 then begin
                                repeat
                                    // PaymentToleranceMgt.DelPmtTolApllnDocNoPV(PVLine, VendLedgEntry."Document No.");
                                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                                    UpdateVendLedgEntry(VendLedgEntry);
                                // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVendPV(Rec, VendLedgEntry, 0, false) and
                                //    (Abs(VendLedgEntry."Amount to Apply") >=
                                //     Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible"))
                                // then
                                //     Amount := Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                                // else
                                //     Amount := Amount - VendLedgEntry."Amount to Apply";

                                until VendLedgEntry.Next = 0;
                                /*IF ("Bal. Account Type" = "Bal. Account Type"::Customer) OR
                                   ("Bal. Account Type" = "Bal. Account Type"::Vendor)
                                THEN
                                  Amount := -Amount;
                                VALIDATE(Amount);*/
                            end else
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                                until VendLedgEntry.Next = 0;
                            if "Currency Code" <> CurrencyCode2 then
                                if Amount = 0 then begin
                                    if not
                                       Confirm(
                                         ConfirmChangeQst, true, TableCaption, "Currency Code", VendLedgEntry."Currency Code")
                                    then
                                        Error(UpdateInterruptedErr);
                                    "Currency Code" := VendLedgEntry."Currency Code"
                                end else
                                    CheckAgainstApplnCurrency("Currency Code", VendLedgEntry."Currency Code", AccType::Vendor, true);
                            "Applies-to Doc. Type" := 0;
                            "Applies-to Doc. No." := '';
                        end else
                            "Applies-to ID" := '';
                        Modify;
                        // if Rec.Amount <> 0 then
                        //     if not PaymentToleranceMgt.PmtTolGenJnlPV(PVLine) then
                        //         exit;
                    end;
                AccType::Employee:
                    ApplyEmployeeLedgerEntryPV(PVLine);
                else
                    Error(
                      Text005,
                      FieldCaption("Account Type"));
            end;
        end;
        //OnAfterRun(PVLine);

        Rec := PVLine;

    end;

    local procedure ApplyEmployeeLedgerEntryPV(var PVLine: Record "Payment Voucher Line")
    begin
        with PVLine do begin
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", AccNo);
            EmplLedgEntry.SetRange(Open, true);
            if "Applies-to ID" = '' then
                "Applies-to ID" := "PV No.";
            if "Applies-to ID" = '' then
                Error(
                  Text000,
                  FieldCaption("PV No."), FieldCaption("Applies-to ID"));
            // ApplyEmplEntries.SetGenJnlLinePV(PVLine, FieldNo("Applies-to ID"));
            ApplyEmplEntries.SetRecord(EmplLedgEntry);
            ApplyEmplEntries.SetTableView(EmplLedgEntry);
            ApplyEmplEntries.LookupMode(true);
            OK := ApplyEmplEntries.RunModal = ACTION::LookupOK;
            Clear(ApplyEmplEntries);
            if not OK then
                exit;
            EmplLedgEntry.Reset;
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", AccNo);
            EmplLedgEntry.SetRange(Open, true);
            EmplLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if EmplLedgEntry.Find('-') then begin
                if Amount = 0 then begin
                    repeat
                        Amount := Amount - EmplLedgEntry."Amount to Apply";
                    until EmplLedgEntry.Next = 0;
                    /*IF ("Bal. Account Type" = "Bal. Account Type"::Customer) OR
                       ("Bal. Account Type" = "Bal. Account Type"::Vendor) OR
                       ("Bal. Account Type" = "Bal. Account Type"::Employee)
                    THEN
                      Amount := -Amount;
                    VALIDATE(Amount);*/
                end;
                "Applies-to Doc. Type" := 0;
                "Applies-to Doc. No." := '';
            end else
                "Applies-to ID" := '';
            if Modify then;
        end;

    end;

    [Scope('Internal')]
    procedure ApplyReceiptEntries(Rec: Record "Reciept - Payment Header")
    var
        RecHeader: Record "Reciept - Payment Header";
        RecieptLines: Record "Reciept - Payment Lines";
    begin
        RecHeader.Copy(Rec);

        //OnBeforeRun(PVLine);
        //ERROR('Stop apply entry');

        with RecHeader do begin
            GetCurrency;
            if "Bal. Account Type" in
               ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]
            then begin
                AccType := "Bal. Account Type";
                AccNo := "Bal. Account No.";
            end;
            case AccType of
                AccType::Customer:
                    begin
                        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                        CustLedgEntry.SetRange("Customer No.", AccNo);
                        CustLedgEntry.SetRange(Open, true);
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := RecHeader."Doc No.";
                        if "Applies-to ID" = '' then
                            Error(
                              Text000,
                              FieldCaption(RecHeader."Doc No."), FieldCaption("Applies-to ID"));


                        // ApplyCustEntries.SetGenJnlLineRec(RecHeader, FieldNo("Applies-to ID"));
                        ApplyCustEntries.SetRecord(CustLedgEntry);
                        ApplyCustEntries.SetTableView(CustLedgEntry);
                        ApplyCustEntries.LookupMode(true);
                        OK := ApplyCustEntries.RunModal = ACTION::LookupOK;
                        Clear(ApplyCustEntries);
                        if not OK then
                            exit;

                        CustLedgEntry.Reset;
                        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                        CustLedgEntry.SetRange("Customer No.", AccNo);
                        CustLedgEntry.SetRange(Open, true);
                        CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if CustLedgEntry.Find('-') then begin
                            CurrencyCode2 := CustLedgEntry."Currency Code";
                            if Amount = 0 then begin
                                repeat
                                    // PaymentToleranceMgt.DelPmtTolApllnDocNoRec(RecHeader, CustLedgEntry."Document No.");
                                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                                    UpdateCustLedgEntry(CustLedgEntry);
                                // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCustRec(Rec, CustLedgEntry, 0, false) and
                                //    (Abs(CustLedgEntry."Amount to Apply") >=
                                //     Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
                                // then
                                //     Amount := Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                                // else
                                //     Amount := Amount - CustLedgEntry."Amount to Apply";
                                until CustLedgEntry.Next = 0;
                                /*IF ("Account Type" = "Account Type"::Customer) OR
                                   ("Account Type" = "Account Type"::Vendor)
                                THEN
                                  Amount := -Amount;
                                VALIDATE(Amount);*/
                            end else
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, CustLedgEntry."Currency Code", AccType::Customer, true);
                                until CustLedgEntry.Next = 0;
                            if "Currency Code" <> CurrencyCode2 then
                                if Amount = 0 then begin
                                    if not
                                       Confirm(
                                         ConfirmChangeQst, true, TableCaption, "Currency Code", CustLedgEntry."Currency Code")
                                    then
                                        Error(UpdateInterruptedErr);
                                    "Currency Code" := CustLedgEntry."Currency Code"
                                end else
                                    CheckAgainstApplnCurrency("Currency Code", CustLedgEntry."Currency Code", AccType::Customer, true);
                            "Applies-to Doc. Type" := 0;
                            //
                            "Applies-to Doc. No." := CustLedgEntry."Document No.";
                            //"Applies-to Doc. No." := '';

                        end else
                            "Applies-to ID" := '';

                        Modify;
                        //Copy to Receipt Lines
                        ReceiptHeader2 := RecHeader;
                        if "Applies-to ID" <> '' then
                            InitializeAppliesToID("Doc No.")
                        else
                            ReinitializeAppliesToID("Doc No.");
                        //end

                        // if Rec.Amount <> 0 then
                        //     if not PaymentToleranceMgt.PmtTolGenJnlRec(RecHeader) then
                        //         exit;
                    end;
                AccType::Vendor:
                    begin
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", AccNo);
                        VendLedgEntry.SetRange(Open, true);
                        if "Applies-to ID" = '' then
                            "Applies-to ID" := "Doc No.";
                        if "Applies-to ID" = '' then
                            Error(
                              Text000,
                              FieldCaption("Doc No."), FieldCaption("Applies-to ID"));
                        // ApplyVendEntries.SetGenJnlLinePV(PVLine, FieldNo("Applies-to ID"));
                        ApplyVendEntries.SetRecord(VendLedgEntry);
                        ApplyVendEntries.SetTableView(VendLedgEntry);
                        ApplyVendEntries.LookupMode(true);
                        OK := ApplyVendEntries.RunModal = ACTION::LookupOK;
                        Clear(ApplyVendEntries);
                        if not OK then
                            exit;

                        VendLedgEntry.Reset;
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", AccNo);
                        VendLedgEntry.SetRange(Open, true);
                        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if VendLedgEntry.Find('-') then begin
                            CurrencyCode2 := VendLedgEntry."Currency Code";
                            if Amount = 0 then begin
                                repeat
                                    // PaymentToleranceMgt.DelPmtTolApllnDocNoPV(PVLine, VendLedgEntry."Document No.");
                                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                                    UpdateVendLedgEntry(VendLedgEntry);
                                // if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVendRec(Rec, VendLedgEntry, 0, false) and
                                //    (Abs(VendLedgEntry."Amount to Apply") >=
                                //     Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible"))
                                // then
                                //     Amount := Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                                // else
                                //     Amount := Amount - VendLedgEntry."Amount to Apply";

                                until VendLedgEntry.Next = 0;
                                /*IF ("Bal. Account Type" = "Bal. Account Type"::Customer) OR
                                   ("Bal. Account Type" = "Bal. Account Type"::Vendor)
                                THEN
                                  Amount := -Amount;
                                VALIDATE(Amount);*/
                            end else
                                repeat
                                    CheckAgainstApplnCurrency(CurrencyCode2, VendLedgEntry."Currency Code", AccType::Vendor, true);
                                until VendLedgEntry.Next = 0;
                            if "Currency Code" <> CurrencyCode2 then
                                if Amount = 0 then begin
                                    if not
                                       Confirm(
                                         ConfirmChangeQst, true, TableCaption, "Currency Code", VendLedgEntry."Currency Code")
                                    then
                                        Error(UpdateInterruptedErr);
                                    "Currency Code" := VendLedgEntry."Currency Code"
                                end else
                                    CheckAgainstApplnCurrency("Currency Code", VendLedgEntry."Currency Code", AccType::Vendor, true);
                            "Applies-to Doc. Type" := 0;
                            //
                            "Applies-to Doc. No." := VendLedgEntry."Document No.";
                            //"Applies-to Doc. No." := '';
                        end else
                            "Applies-to ID" := '';
                        Modify;
                        //Copy to Receipt Lines
                        ReceiptHeader2 := RecHeader;
                        if "Applies-to ID" <> '' then
                            InitializeAppliesToID("Doc No.")
                        else
                            ReinitializeAppliesToID("Doc No.");

                        // if Rec.Amount <> 0 then
                        //     if not PaymentToleranceMgt.PmtTolGenJnlRec(RecHeader) then
                        //         exit;
                    end;
                AccType::Employee:
                    ApplyEmployeeLedgerEntryRec(RecHeader);
                else
                    Error(
                      Text005,
                      FieldCaption("Account Type"));
            end;

            //assign applies to ID to ReceiptLine


        end;
        //OnAfterRun(PVLine);

        Rec := RecHeader;

    end;

    local procedure ApplyEmployeeLedgerEntryRec(RecLine: Record "Reciept - Payment Header")
    begin
        with RecLine do begin
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", AccNo);
            EmplLedgEntry.SetRange(Open, true);
            if "Applies-to ID" = '' then
                "Applies-to ID" := "Doc No.";
            if "Applies-to ID" = '' then
                Error(
                  Text000,
                  FieldCaption("Doc No."), FieldCaption("Applies-to ID"));
            // ApplyEmplEntries.SetGenJnlLinePV(PVLine, FieldNo("Applies-to ID"));
            ApplyEmplEntries.SetRecord(EmplLedgEntry);
            ApplyEmplEntries.SetTableView(EmplLedgEntry);
            ApplyEmplEntries.LookupMode(true);
            OK := ApplyEmplEntries.RunModal = ACTION::LookupOK;
            Clear(ApplyEmplEntries);
            if not OK then
                exit;
            EmplLedgEntry.Reset;
            EmplLedgEntry.SetCurrentKey("Employee No.", Open, Positive);
            EmplLedgEntry.SetRange("Employee No.", AccNo);
            EmplLedgEntry.SetRange(Open, true);
            EmplLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if EmplLedgEntry.Find('-') then begin
                if Amount = 0 then begin
                    repeat
                        Amount := Amount - EmplLedgEntry."Amount to Apply";
                    until EmplLedgEntry.Next = 0;
                    /*IF ("Bal. Account Type" = "Bal. Account Type"::Customer) OR
                       ("Bal. Account Type" = "Bal. Account Type"::Vendor) OR
                       ("Bal. Account Type" = "Bal. Account Type"::Employee)
                    THEN
                      Amount := -Amount;
                    VALIDATE(Amount);*/
                end;
                "Applies-to Doc. Type" := 0;
                //
                "Applies-to Doc. No." := EmplLedgEntry."Document No.";
                //"Applies-to Doc. No." := '';
            end else
                "Applies-to ID" := '';
            if Modify then;
            //Copy to Receipt Lines
            ReceiptHeader2 := RecLine;
            if "Applies-to ID" <> '' then
                InitializeAppliesToID("Doc No.")
            else
                ReinitializeAppliesToID("Doc No.");

        end;

    end;

    [Scope('Internal')]
    procedure CreateRentInvoice(ContractNo: Code[20]; InvoiceDate: Date; Post: Boolean; ContractAmount: Decimal; StartingDate: Date)
    var
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        ResSetup: Record "Resources Setup";
        Contract: Record "Rent Contract Header";
        NoSeries: Codeunit NoSeriesManagement;
        ContractLine: Record "Rent Contract Line";
        Text001: Label 'Contract Amount for %1 must be greater than 0.';
        NextPeriodDate: Date;
        NoOfMnth: Integer;
        PropMgmt: Codeunit "Property Management";
        Text002: Label 'Contract No. %1 Status must be signed.';
        Text003: Label 'Contract No. %1 Change Status must be locked.';
        Text004: Label 'Property No must be selected on Contract No. %1';
        Text005: Label 'Contract Start Date must be entered on Contract No %1';
        Text006: Label 'Contract End Date must be entered on Contract No %1';
        CurrPeriodDate: Date;
        Year: Integer;
        InvPeriod: Record "Tenant Invoicing Periods";
        InvoiceDateToday: Date;
        ResourceTypeOpt: Text[200];
        ResourceOp: Option "Rental Space",Parking,"Service Charge";
        AmountPerMonth: Decimal;
    begin

        if Confirm(Text028, false) = false then
            exit;

        if ContractAmount <= 0 then
            Error(Text001, ContractNo);

        Contract.Get(ContractNo);

        if Contract.Status = Contract.Status::Terminated then
            exit;

        if Contract."Change Status" <> Contract."Change Status"::Locked then
            Error(Text003, ContractNo);

        if Contract."Property No" = '' then
            Error(Text004, ContractNo);

        if Contract."Starting Date" = 0D then
            Error(Text005, ContractNo);

        if Contract."Expiration Date" = 0D then
            Error(Text006, ContractNo);

        //IF InvoiceDate=0D THEN
        //InvoiceDate:=TODAY;
        /*
        IF InvoiceDate > TODAY THEN
          EXIT;*/
        //ktm 10/16/19
        if InvoiceDate = StartingDate then begin
            NextPeriodDate := GetNextPeriod(StartingDate);
        end else
            if InvoiceDate = 0D then begin
                NextPeriodDate := GetNextPeriod(StartingDate);
            end else
                if InvoiceDate <> StartingDate then
                    NextPeriodDate := GetNextPeriod(InvoiceDate);


        if InvoiceDate = StartingDate then begin
            CurrPeriodDate := GetCurrPeriod(StartingDate);
        end else
            if InvoiceDate = 0D then begin
                CurrPeriodDate := GetCurrPeriod(StartingDate);
            end else
                if InvoiceDate <> StartingDate then
                    CurrPeriodDate := GetCurrPeriod(InvoiceDate);
        //ktm 10/16/19

        //ktm 25-06-19
        if NextPeriodDate > Contract."Expiration Date" + 90 then
            Error(Text029);
        //Ktm 25-06-19

        //ktm 10/16/19
        if InvoiceDate = StartingDate then begin
            InvoiceDate := StartingDate;
            NoOfMnth := GetInvoiceMonths(InvoiceDate, NextPeriodDate - 1);
        end else
            if InvoiceDate = 0D then begin
                InvoiceDate := StartingDate;
                NoOfMnth := GetInvoiceMonths(InvoiceDate, NextPeriodDate - 1);
            end else
                if InvoiceDate <> StartingDate then begin
                    InvoiceDate := InvoiceDate;
                    NoOfMnth := GetInvoiceMonths(InvoiceDate, NextPeriodDate - 1);
                end;
        //ktm end



        ResSetup.Get;

        //Header
        SH.Init;
        SH."Document Type" := SH."Document Type"::Invoice;
        /*SH.VALIDATE("Posting Date",EndDate);
        SH.VALIDATE("Document Date",EndDate);  IGO 11/01/08*/
        SH.Validate("Posting Date", Today);
        SH.Validate("Document Date", InvoiceDate);

        SH."No." := NoSeries.GetNextNo(ResSetup."Rent Contr Invoice Nos.", Today, true);
        SH.Validate("Sell-to Customer No.", Contract."Bill-to Customer No.");
        SH."Allow Line Disc." := false;
        SH."Rent Invoice" := true;
        SH."Property No" := Contract."Property No";
        SH."Contract No" := Contract."Contract No.";
        SH."Invoice Period" := GetCurrPeriod(CurrPeriodDate);
        SH.Insert;




        //Create the Line
        with ContractLine do begin
            Reset;
            SetRange("Contract No.", Contract."Contract No.");
            if Find('-') then begin
                repeat

                    SL.Init;
                    LineNo := SL."Line No.";
                    SL."Document Type" := SL."Document Type"::Invoice;
                    SL."Document No." := SH."No.";
                    SL."Line No." := LineNo + 10000;
                    SL.Type := SL.Type::Resource;
                    SL.Validate(SL."No.", "Resource Code");
                    //ktm
                    if "Resource Sub Type" <> 0 then begin
                        SL."Resource Sub Type" := "Resource Sub Type";
                    end;
                    SL."Unit of Measure" := "Base Unit of Measure";
                    //ktm
                    SL."Sell-to Customer No." := SH."Bill-to Customer No.";
                    SL."Qty. Invoiced (Base)" := "No of Units";
                    SL."Unit Price" := "Resource Price";
                    SL."No. of Months" := NoOfMnth;
                    AmountPerMonth := "No of Units" * "Resource Price" * NoOfMnth;
                    SL."Amount Per Period" := AmountPerMonth;
                    SL.Validate(Quantity, NoOfMnth);
                    SL.Description := Description;
                    SL.Validate("Unit Price");
                    SL."Contract Code" := "Contract No.";
                    //ktm
                    SL."Qty. to Invoice" := "No of Units" * NoOfMnth;
                    //ktm
                    SL."Contract Type" := "Contract Type";
                    SL.Quantity := "No of Units";
                    SL."Total Amount" := AmountPerMonth;
                    if SL."VAT Prod. Posting Group" = 'VAT16' then
                        SL."Unit Price lcy" := AmountPerMonth * 1.16;
                    //ktm
                    SL.Amount := AmountPerMonth;
                    if SL."VAT Prod. Posting Group" = 'VAT16' then
                        SL."Amount Including VAT" := AmountPerMonth * 1.16;
                    SL."Line Amount" := AmountPerMonth;

                    SL.Insert;
                //ERROR('No of Units %1 Resource price %2 No of months %3 total amount per month %4 unit price %5 total amount %6',"No of Units"
                //, "Resource Price", NoOfMnth, AmountPerMonth, SL."Unit Price", SL."Total Amount");
                until Next = 0;
            end;
        end;

        //Create Period Name
        Year := Date2DMY(SH."Invoice Period", 3);
        if InvPeriod.Get(SH."Invoice Period") then begin
            if InvPeriod.Name = 'January' then begin
                SH."Period Name" := 'First Quarter' + ' ' + Format(Year);
            end else
                if InvPeriod.Name = 'April' then begin
                    SH."Period Name" := 'Second Quarter' + ' ' + Format(Year);
                end else
                    if InvPeriod.Name = 'July' then begin
                        SH."Period Name" := 'Third Quarter' + ' ' + Format(Year);
                    end else
                        if InvPeriod.Name = 'October' then begin
                            SH."Period Name" := 'Fourth Quarter' + ' ' + Format(Year);
                        end;
            //ktm 09/27/2019
            SH."General Description" := SH."Period Name";
            //ktm
            SH.Modify;
        end;
        //ERROR('Period name %1', SH."Period Name");

        //IF Post THEN
        //Update Next Invoice Date
        Contract."Last Invoice Date" := Today;
        Contract."Next Invoice Date" := NextPeriodDate;
        Contract.Modify;
        Message(Text027, SH."No.");

        NoOfMnthGlobal := NoOfMnth;
        //ERROR('No of months %1', NoOfMnthGlobal);

    end;

    [Scope('Internal')]
    procedure GetCurrPeriod(PeriodStartDate: Date) PeriodDate: Date
    var
        TenantInvPeriod: Record "Tenant Invoicing Periods";
    begin
        with TenantInvPeriod do begin
            Reset;
            SetFilter("Starting Date", '<=%1', PeriodStartDate);
            if Find('+') then
                exit("Starting Date");
        end;
    end;

    [Scope('Internal')]
    procedure GetNextPeriod(PeriodStartDate: Date) PeriodDate: Date
    var
        TenantInvPeriod: Record "Tenant Invoicing Periods";
        contractHeader: Record "Rent Contract Header";
    begin
        with TenantInvPeriod do begin
            Reset;
            SetFilter("Starting Date", '>%1', PeriodStartDate);
            if Find('-') then
                exit("Starting Date");
        end;
    end;

    [Scope('Internal')]
    procedure GetInvoiceMonths(PeriodStartDate: Date; PeriodEndDate: Date) Months: Integer
    var
    // Calendar: Record Date;
    begin
        //RMM Gets no. of months to invoice
        // with Calendar do begin
        //     if (PeriodStartDate <> 0D) and (PeriodEndDate <> 0D) then begin
        //         Reset;
        //         SetRange("Period Type", Calendar."Period Type"::Month);
        //         SetRange("Period Start", PeriodStartDate, PeriodEndDate);
        //         exit(Count);
        //     end else
        //         exit(0);

        // end;
    end;

    [Scope('Internal')]
    procedure UpdateSalesLineVATIncl()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Currency: Record Currency;
        RecalculatePrice: Boolean;
    begin
        // IF  SalesHeaderRec.FIND('-') THEN BEGIN
        //  REPEAT
        //  IF SalesHeaderRec."Prices Including VAT" = FALSE THEN BEGIN
        //    SalesHeaderRec."Prices Including VAT" := TRUE;
        //    SalesHeaderRec.MODIFY;
        //  END;
        SalesHeaderRec.Reset;
        if SalesHeaderRec.Find('-') then begin
            repeat
                //
                if SalesHeaderRec."Prices Including VAT" = false then begin
                    SalesHeaderRec."Prices Including VAT" := true;
                    SalesHeaderRec.Modify;
                end;
                if SalesHeaderRec."Prices Including VAT" = true then begin
                    SalesHeaderRec.TestField(SalesHeaderRec.Status, SalesHeaderRec.Status::Open);
                    //IF SalesHeaderRec."Prices Including VAT" = SalesHeaderRec."Prices Including VAT" THEN BEGIN
                    SalesLine.SetRange(SalesLine."Document Type", SalesHeaderRec."Document Type");
                    SalesLine.SetRange(SalesLine."Document No.", SalesHeaderRec."No.");
                    SalesLine.SetFilter(SalesLine."Job Contract Entry No.", '<>%1', 0);
                    if SalesLine.Find('-') then begin
                        SalesLine.TestField(SalesLine."Job No.", '');
                        SalesLine.TestField(SalesLine."Job Contract Entry No.", 0);
                    end;

                    SalesLine.Reset;
                    SalesLine.SetRange(SalesLine."Document Type", SalesHeaderRec."Document Type");
                    SalesLine.SetRange(SalesLine."Document No.", SalesHeaderRec."No.");
                    SalesLine.SetFilter(SalesLine."Unit Price", '<>%1', 0);
                    SalesLine.SetFilter(SalesLine."VAT %", '<>%1', 0);
                    if SalesLine.Find('-') then begin
                        RecalculatePrice := true;

                        /*CONFIRM(
                          STRSUBSTNO(
                            Text024,
                            FIELDCAPTION("Prices Including VAT"),SalesLine.FIELDCAPTION(SalesLine."Unit Price")),
                          TRUE);*/
                        SalesLine.SetSalesHeader(SalesHeaderRec);

                        if RecalculatePrice and SalesHeaderRec."Prices Including VAT" then
                            SalesLine.ModifyAll(SalesLine.Amount, 0, true);

                        if SalesHeaderRec."Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else
                            Currency.Get(SalesHeaderRec."Currency Code");
                        SalesLine.LockTable;
                        SalesHeaderRec.LockTable;
                        SalesLine.FindSet;
                        repeat
                            SalesLine.TestField(SalesLine."Quantity Invoiced", 0);
                            SalesLine.TestField(SalesLine."Prepmt. Amt. Inv.", 0);
                            if not RecalculatePrice then begin
                                SalesLine."VAT Difference" := 0;
                                SalesLine.UpdateAmounts;
                            end else
                                if SalesHeaderRec."Prices Including VAT" then begin
                                    SalesLine."Unit Price" :=
                                      Round(
                                        SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    if SalesLine.Quantity <> 0 then begin
                                        SalesLine."Line Discount Amount" :=
                                          Round(
                                            SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        SalesLine.Validate("Inv. Discount Amount",
                                          Round(
                                            SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                    end;
                                end else begin
                                    SalesLine."Unit Price" :=
                                      Round(
                                        SalesLine."Unit Price" / (1 + (SalesLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    if SalesLine.Quantity <> 0 then begin
                                        SalesLine."Line Discount Amount" :=
                                          Round(
                                            SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        SalesLine.Validate("Inv. Discount Amount",
                                          Round(
                                            SalesLine."Inv. Discount Amount" / (1 + (SalesLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                    end;
                                end;
                            SalesLine.Modify;
                        until SalesLine.Next = 0;
                    end;
                    //END;
                end;
            until SalesHeaderRec.Next = 0;
        end;

    end;

    [Scope('Internal')]
    procedure UpdateAmountInclVAT()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        ContractLine: Record "Rent Contract Line";
        AmountPerMonth: Decimal;
    begin
        with ContractLine do begin
            SetFilter("Contract No.", SalesHeader."Contract No");
            if "Amount per Month" <> 0 then begin
                AmountPerMonth := "No of Units" * "Resource Price" * NoOfMnthGlobal;
                SalesLine."Amount Including VAT" := AmountPerMonth * 1.16;
            end else
                SalesLine."Amount Including VAT" := 0;

        end;
    end;

    [Scope('Internal')]
    procedure ReversePeriod(ContractNo: Code[50])
    var
        TenantInvPeriod: Record "Tenant Invoicing Periods";
        contractHeader: Record "Rent Contract Header";
    begin
        contractHeader.SetRange("Contract No.", ContractNo);
        if contractHeader.Find('-') then begin
            if contractHeader."Next Invoice Date" <> contractHeader."Starting Date" then begin
                if contractHeader."Next Invoice Date" > contractHeader."Starting Date" then begin
                    with TenantInvPeriod do begin
                        Reset;
                        SetFilter("Starting Date", '<%1', contractHeader."Next Invoice Date");
                        if FindLast then
                            contractHeader."Next Invoice Date" := "Starting Date";
                    end;
                end else
                    contractHeader."Next Invoice Date" := contractHeader."Starting Date";
                contractHeader.Modify;
            end else
                Error('The next invoice date can not be less than contract start date');
            if contractHeader."Next Invoice Date" < contractHeader."Starting Date" then begin
                contractHeader."Next Invoice Date" := contractHeader."Starting Date";
                contractHeader.Modify;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure InitializeAppliesToID(DocNo: Code[50])
    var
        RecieptLines: Record "Reciept - Payment Lines";
    begin

        with ReceiptHeader2 do begin

            RecieptLines.SetRange("Doc No.", DocNo);
            if RecieptLines.Find('-') then begin
                repeat
                    RecieptLines."Applies-to ID" := "Applies-to ID";
                    RecieptLines."Applies-to Doc. No." := "Applies-to Doc. No.";
                    RecieptLines.Modify;
                until RecieptLines.Next = 0;
            end;

        end;
    end;

    [Scope('Internal')]
    procedure ReinitializeAppliesToID(DocNo: Code[50])
    var
        RecieptLines: Record "Reciept - Payment Lines";
    begin

        with ReceiptHeader2 do begin

            RecieptLines.SetRange("Doc No.", DocNo);
            if RecieptLines.Find('-') then begin
                repeat
                    RecieptLines."Applies-to ID" := '';
                    RecieptLines."Applies-to Doc. No." := '';
                    RecieptLines.Modify;
                until RecieptLines.Next = 0;
            end;

        end;
    end;

    [Scope('Internal')]
    procedure LockResource(ContractNo: Code[50])
    var
        RentContractLine: Record "Rent Contract Line";
        RentContractHeader: Record "Rent Contract Header";
    begin

        //KTM 09/01/19 Lock Resource after Locking a contract

        RentContractLine.Reset;
        RentContractLine.SetRange("Contract No.", ContractNo);
        if RentContractLine.Find('-') then begin
            repeat
                Res.Reset;
                Res.SetRange(Res."No.", RentContractLine."Resource Code");
                Res.SetRange(Res."Under Contract", false);
                if not Res.Find('-') then
                    Error(Res."No.", Res."Contract Code");
            until RentContractLine.Next = 0;
        end;

        RentContractLine.Reset;
        RentContractLine.SetRange("Contract No.", ContractNo);
        if RentContractLine.Find('-') then begin
            repeat
                Res.Reset;
                Res.SetRange(Res."No.", RentContractLine."Resource Code");
                if Res.Find('-') then begin
                    if Res."Resource Group No." <> 'PARKING' then
                        Res."Under Contract" := true;

                    Res."Contract Code" := ContractNo;
                    Res.Modify;
                end;
            until RentContractLine.Next = 0;
        end;

        //END KTM 09/01/20
    end;

    [Scope('Internal')]
    procedure UnlockResource(ContractNo: Code[50])
    var
        RentContractLine: Record "Rent Contract Line";
        RentContractHeader: Record "Rent Contract Header";
    begin

        //KTM 09/01/19 Lock Resource after Locking a contract

        RentContractLine.Reset;
        RentContractLine.SetRange("Contract No.", ContractNo);
        if RentContractLine.Find('-') then begin
            repeat
                Res.Reset;
                Res.SetRange("No.", RentContractLine."Resource Code");
                if Res.Find('-') then begin
                    if Res."Resource Group No." <> 'PARKING' then
                        Res."Under Contract" := false;

                    Res."Contract Code" := ContractNo;
                    Res.Modify;
                end;
            until RentContractLine.Next = 0;
        end;
    end;

    [Scope('Internal')]
    procedure SendApiRequest(TransactionType: Integer; SaleHeaderDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; SaleHeaderNo: Code[20]): Text
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        ApiUrl: Text;
        ResponseInStream: InStream;
        // HttpsStatusCode: Dotnet BCHttpStatusCode;
        // ResponseHeaders: Dotnet BCHttpStatusCode;
        // TempBlob: Record TempBlob;
        ApiResponseText: Text;
        // ApiResponseObject: Dotnet BCJObject;
        JsonMgt: Codeunit "JSON Management";
        // HttpContent: Dotnet BCHttpContent;
        // HttpClient: Dotnet BCHttpClient;
        // Uri: Dotnet BCUri;
        // HttpResponseMessage: Dotnet BCHttpResponseMessage;
        // ApiBodyObject: Dotnet BCJObject;
        // TempBlobBody: Record TempBlob;
        OutStream: OutStream;
        // ResponseJsonObject: Dotnet BCJObject;
        // ResponseJsonArray: Dotnet BCJArray;
        Errors: Text;
        CONFIRM_ERROR: Label 'Some errors were encountered while posting to KRA TIMS.\\ERRORS\%1\\Do you want to post the Invoice/Credit Note without KRA signature?';
    begin
        //Test IP - http://197.248.125.81:8086/api/v3/invoices
        ApiUrl := 'http://197.248.125.81:8086/api/v3/invoices';
        HttpWebRequestMgt.Initialize(ApiUrl);
        HttpWebRequestMgt.DisableUI;
        HttpWebRequestMgt.SetMethod('POST');
        HttpWebRequestMgt.SetReturnType('application/json');
        HttpWebRequestMgt.SetContentType('application/json');
        HttpWebRequestMgt.AddHeader('cache-control', 'no-cache');
        HttpWebRequestMgt.AddHeader('RequestId', GetRequestId(TransactionType));

        // TempBlob.DeleteAll;

        // if TransactionType = 0 then begin
        //     TempBlobBody.Init;
        //     TempBlobBody.Blob.CreateOutStream(OutStream);
        //     OutStream.WriteText(InvoiceRequestBody(SaleHeaderDocType, SaleHeaderNo));
        //     TempBlobBody.Insert;
        //     TempBlobBody.CalcFields(Blob);
        // end
        // else
        //     if TransactionType = 1 then begin
        //         TempBlobBody.Init;
        //         TempBlobBody.Blob.CreateOutStream(OutStream);
        //         OutStream.WriteText(CreditNoteRequestBody(SaleHeaderDocType, SaleHeaderNo));
        //         TempBlobBody.Insert;
        //         TempBlobBody.CalcFields(Blob);
        //     end;
        // HttpWebRequestMgt.AddBodyBlob(TempBlobBody);

        // TempBlob.Init;
        // TempBlob.Blob.CreateInStream(ResponseInStream);
        // if HttpWebRequestMgt.GetResponse(ResponseInStream, HttpsStatusCode, ResponseHeaders) then begin
        //     ApiResponseText := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
        //     if ApiResponseText <> '' then begin
        //         ApiResponseObject := ApiResponseObject.Parse(ApiResponseText);
        //         //Response Error Handling
        //         if not IsNull(ApiResponseObject.GetValue('modelState')) then begin
        //             JsonMgt.InitializeCollection(ApiResponseObject.GetValue('modelState').ToString);
        //             JsonMgt.GetJsonArray(ResponseJsonArray);
        //             foreach ResponseJsonObject in ResponseJsonArray do begin
        //                 if Errors <> '' then
        //                     Errors += '\';
        //                 Errors += ResponseJsonObject.GetValue('property').ToString;
        //             end;

        //             if (Confirm(CONFIRM_ERROR, false, Errors)) then
        //                 exit
        //             else
        //                 Error('Posting cancelled.');
        //         end;

        //         exit(ApiResponseObject.ToString);
        //     end;
        // end
        // else
        //     HttpWebRequestMgt.ProcessFaultResponse('');
    end;

    local procedure InvoiceRequestBody(SaleHeaderDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; SaleHeaderNo: Code[20]) RequestBody: Text
    var
        JsonMgt: Codeunit "JSON Management";
        // RequestBodyObject: Dotnet BCJObject;
        // PaymentArray: Dotnet BCJArray;
        // OptionsObject: Dotnet BCJObject;
        // BuyerObject: Dotnet BCJObject;
        // ItemsArray: Dotnet BCJArray;
        // ItemDescriptionArray: Dotnet BCJArray;
        // LinesArray: Dotnet BCJArray;
        // Value: Dotnet BCJObject;
        Cashier: Text;
        InvoiceType: Integer;
        TransactionType: Integer;
        InvoiceNo: Text;
        ExemptionNo: Text;
        RelevantNo: Text;
        // PaymentSubEntryObject: Dotnet BCJObject;
        // ItemDescriptionSubEntryObject: Dotnet BCJObject;
        // ItemSubEntryObject: Dotnet BCJObject;
        // LineSubEntryObject: Dotnet BCJObject;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TotalLineQty: Decimal;
        LinePriceInclVAT: Decimal;
        CalculatedAmountVAT: Decimal;
    begin

        // BuyerObject := BuyerObject.JObject;

        InvoiceType := 0;
        TransactionType := 0;

        with SalesHeader do begin
            SetRange("Document Type", SaleHeaderDocType);
            SetRange("No.", SaleHeaderNo);
            if Find('-') then begin
                InvoiceNo := SalesHeader."No.";

                RequestBody += '{';
                RequestBody += StrSubstNo('"invoiceType":%1,', InvoiceType);
                RequestBody += StrSubstNo('"transactionType":%1,', TransactionType);
                RequestBody += StrSubstNo('"TraderSystemInvoiceNumber":"%1",', InvoiceNo);

                /*
                JsonMgt.AddJPropertyToJObject(BuyerObject, 'pinOfBuyer', SalesInvoiceHeader."VAT Registration No.");
                JsonMgt.AddJPropertyToJObject(BuyerObject, 'buyerName', SalesInvoiceHeader."Bill-to Name");
                JsonMgt.AddJPropertyToJObject(BuyerObject, 'buyerAddress', SalesInvoiceHeader."Bill-to Address");
                JsonMgt.AddJPropertyToJObject(BuyerObject, 'buyerPhone', '');
                RequestBody += STRSUBSTNO('"buyer":%1,', BuyerObject);
                */

                RequestBody += '"items":[';
                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
                if SalesLine.Find('-') then begin
                    repeat
                        RequestBody += '{';
                        RequestBody += StrSubstNo('"name":"%1",', SalesLine."Resource Sub Type");
                        TotalLineQty := (SalesLine.Quantity * SalesLine."No. of Months");
                        RequestBody += StrSubstNo('"quantity":%1,', Format(TotalLineQty, 0, 1));
                        LinePriceInclVAT := Round(SalesLine."Unit Price" * ((SalesLine."VAT %" + 100) / 100), 0.01, '<');
                        RequestBody += StrSubstNo('"unitPrice":%1,', Format(LinePriceInclVAT, 0, 1));
                        CalculatedAmountVAT += LinePriceInclVAT * TotalLineQty;
                        RequestBody += '"description":[';
                        RequestBody += '{';
                        RequestBody += StrSubstNo('"value":"%1"', SalesLine.Description);
                        RequestBody += '}';
                        RequestBody += ']';
                        RequestBody += '},';
                    until SalesLine.Next = 0;
                end;

                RequestBody := DelChr(RequestBody, '>', ',');
                RequestBody += '],';

                RequestBody += '"payment":[';
                RequestBody += '{';
                RequestBody += StrSubstNo('"amount":%1,', Format(CalculatedAmountVAT, 0, 1));
                RequestBody += StrSubstNo('"paymentType":%1', 2);
                RequestBody += '}';
                RequestBody += ']';

                RequestBody += '}';
            end;
        end;
        RequestBody := DelChr(RequestBody, '<>', ' ');
        exit(RequestBody);

    end;

    local procedure CreditNoteRequestBody(SaleHeaderDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; SaleHeaderNo: Code[20]) RequestBody: Text
    var
        JsonMgt: Codeunit "JSON Management";
        // RequestBodyObject: Dotnet BCJObject;
        // PaymentArray: Dotnet BCJArray;
        // OptionsObject: Dotnet BCJObject;
        // BuyerObject: Dotnet BCJObject;
        // ItemsArray: Dotnet BCJArray;
        // ItemDescriptionArray: Dotnet BCJArray;
        // LinesArray: Dotnet BCJArray;
        // Value: Dotnet BCJObject;
        Cashier: Text;
        InvoiceType: Integer;
        TransactionType: Integer;
        InvoiceNo: Text;
        ExemptionNo: Text;
        RelevantNo: Text;
        // PaymentSubEntryObject: Dotnet BCJObject;
        // ItemDescriptionSubEntryObject: Dotnet BCJObject;
        // ItemSubEntryObject: Dotnet BCJObject;
        // LineSubEntryObject: Dotnet BCJObject;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesLine: Record "Sales Line";
        TotalLineQty: Decimal;
        LinePriceInclVAT: Decimal;
    begin

        // BuyerObject := BuyerObject.JObject;

        InvoiceType := 0;
        TransactionType := 1;

        with SalesHeader do begin
            SetRange("Document Type", SaleHeaderDocType);
            SetRange("No.", SaleHeaderNo);
            if Find('-') then begin
                InvoiceNo := SalesHeader."Applies-to Doc. No.";

                RequestBody += '{';
                RequestBody += StrSubstNo('"invoiceType":%1,', InvoiceType);
                RequestBody += StrSubstNo('"transactionType":%1,', TransactionType);
                RequestBody += StrSubstNo('"TraderSystemInvoiceNumber":"%1",', InvoiceNo);

                SalesInvoiceHeader.Get(SalesHeader."Applies-to Doc. No.");
                // RequestBody += StrSubstNo('"relevantNumber":"%1",', SalesInvoiceHeader."ETR Mtn");

                RequestBody += '"items":[';
                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
                if SalesLine.FindFirst then begin
                    repeat
                        if SalesLine.Amount > 0 then begin
                            RequestBody += '{';
                            RequestBody += StrSubstNo('"name":"%1",', SalesLine."Resource Sub Type");
                            TotalLineQty := (SalesLine.Quantity * SalesLine."No. of Months");
                            RequestBody += StrSubstNo('"quantity":%1,', Format(TotalLineQty, 0, 1));
                            LinePriceInclVAT := Round(SalesLine."Unit Price" * ((SalesLine."VAT %" + 100) / 100), 0.01, '<');
                            RequestBody += StrSubstNo('"totalAmount":%1', Format(LinePriceInclVAT, 0, 1));
                            RequestBody += '},';
                        end;

                    until SalesLine.Next = 0;
                end;

                RequestBody := DelChr(RequestBody, '>', ',');
                RequestBody += ']';
                RequestBody += '}';
            end;
        end;
        RequestBody := DelChr(RequestBody, '<>', ' ');
        exit(RequestBody);
    end;

    local procedure GetRequestId(TransactionType: Integer): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if TransactionType = 0 then begin
            if SalesInvoiceHeader.FindLast then
                exit(SalesInvoiceHeader."No.");
        end
        else
            if TransactionType = 1 then begin
                if SalesCrMemoHeader.FindLast then
                    exit(SalesCrMemoHeader."No.")
            end;
    end;

    [Scope('Internal')]
    procedure UpdateETRInfo(TransactionType: Integer; ApiResponseText: Text)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        // ApiResponseObject: Dotnet BCJObject;
        JsonMgt: Codeunit "JSON Management";
    begin
        // ApiResponseObject := ApiResponseObject.Parse(ApiResponseText);

        if TransactionType = 0 then begin
            if SalesInvoiceHeader.FindLast then begin
                // SalesInvoiceHeader."ETR Posted" := true;
                // SalesInvoiceHeader."ETR DateTime" := ApiResponseObject.GetValue('DateTime').ToString;
                // SalesInvoiceHeader."ETR InvoiceExtension" := ApiResponseObject.GetValue('invoiceExtension').ToString;
                // SalesInvoiceHeader."ETR Msn" := ApiResponseObject.GetValue('msn').ToString;
                // SalesInvoiceHeader."ETR Mtn" := ApiResponseObject.GetValue('mtn').ToString;
                // SalesInvoiceHeader."ETR VerificationUrl" := ApiResponseObject.GetValue('verificationUrl').ToString;
                // Evaluate(SalesInvoiceHeader."ETR TotalAmount", ApiResponseObject.GetValue('totalAmount').ToString);
                // SalesInvoiceHeader."ETR RelevantNumber" := ApiResponseObject.GetValue('mtn').ToString;

                SalesInvoiceHeader.Modify;
            end;
        end
        else
            if TransactionType = 1 then begin
                ;
                if SalesCrMemoHeader.FindLast then begin
                    SalesCrMemoHeader."ETR Posted" := true;
                    // SalesCrMemoHeader."ETR DateTime" := ApiResponseObject.GetValue('DateTime').ToString;
                    // SalesCrMemoHeader."ETR InvoiceExtension" := ApiResponseObject.GetValue('invoiceExtension').ToString;
                    // SalesCrMemoHeader."ETR Msn" := ApiResponseObject.GetValue('msn').ToString;
                    // SalesCrMemoHeader."ETR Mtn" := ApiResponseObject.GetValue('mtn').ToString;
                    // SalesCrMemoHeader."ETR VerificationUrl" := ApiResponseObject.GetValue('verificationUrl').ToString;
                    // Evaluate(SalesCrMemoHeader."ETR TotalAmount", ApiResponseObject.GetValue('totalAmount').ToString);
                    // SalesCrMemoHeader."ETR RelevantNumber" := ApiResponseObject.GetValue('relevantNumber').ToString;

                    SalesCrMemoHeader.Modify;
                end;
            end;
    end;
}

