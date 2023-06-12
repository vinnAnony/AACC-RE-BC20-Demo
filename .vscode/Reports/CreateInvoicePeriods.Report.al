report 50019 "Create Invoice Periods"
{
    Caption = 'Create Fiscal Year';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; FiscalYearStartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(NoOfPeriods; NoOfPeriods)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Periods';
                        ToolTip = 'Specifies how many accounting periods to include.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if NoOfPeriods = 0 then begin
                NoOfPeriods := 12;
                Evaluate(PeriodLength, '<1M>');
            end;
            if AccountingPeriod.Find('+') then
                FiscalYearStartDate := AccountingPeriod."Starting Date";
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        AccountingPeriod."Starting Date" := FiscalYearStartDate;
        AccountingPeriod.TestField("Starting Date");

        if AccountingPeriod.Find('-') then begin
            FirstPeriodStartDate := AccountingPeriod."Starting Date";
            FirstPeriodLocked := AccountingPeriod."Date Locked";
            if (not HideDialog) and (FiscalYearStartDate < FirstPeriodStartDate) and FirstPeriodLocked then
                if not Confirm(CreateAndCloseQst) then
                    exit;
            if AccountingPeriod.Find('+') then
                LastPeriodStartDate := AccountingPeriod."Starting Date";
        end else
            if not HideDialog then
                if not Confirm(CreateQst) then
                    exit;

        FiscalYearStartDate2 := FiscalYearStartDate;

        for i := 1 to NoOfPeriods + 1 do begin
            if (FiscalYearStartDate <= FirstPeriodStartDate) and (i = NoOfPeriods + 1) then
                exit;

            if FirstPeriodStartDate <> 0D then
                if (FiscalYearStartDate >= FirstPeriodStartDate) and (FiscalYearStartDate < LastPeriodStartDate) then
                    Error(OnlyBeforeOrAfterErr);
            AccountingPeriod.Init;
            AccountingPeriod."Starting Date" := FiscalYearStartDate;
            AccountingPeriod.Validate("Starting Date");
            if (i = 1) or (i = NoOfPeriods + 1) then begin
                AccountingPeriod."New Fiscal Year" := true;
            end;
            if (FirstPeriodStartDate = 0D) and (i = 1) then
                AccountingPeriod."Date Locked" := true;
            if (AccountingPeriod."Starting Date" < FirstPeriodStartDate) and FirstPeriodLocked then begin
                AccountingPeriod.Closed := true;
                AccountingPeriod."Date Locked" := true;
            end;
            if not AccountingPeriod.Find('=') then
                AccountingPeriod.Insert;
            FiscalYearStartDate := CalcDate(PeriodLength, FiscalYearStartDate);
        end;

        AccountingPeriod.Get(FiscalYearStartDate2);
        // AccountingPeriod.UpdateAvgItems(0);
    end;

    var
        CreateAndCloseQst: Label 'The new fiscal year begins before an existing fiscal year, so the new year will be closed automatically.\\Do you want to create and close the fiscal year?';
        CreateQst: Label 'After you create the new fiscal year, you cannot change its starting date.\\Do you want to create the fiscal year?';
        OnlyBeforeOrAfterErr: Label 'It is only possible to create new fiscal years before or after the existing ones.';
        AccountingPeriod: Record "Tenant Invoicing Periods";
        NoOfPeriods: Integer;
        PeriodLength: DateFormula;
        FiscalYearStartDate: Date;
        FiscalYearStartDate2: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        i: Integer;
        HideDialog: Boolean;

    procedure InitializeRequest(NewNoOfPeriods: Integer; NewPeriodLength: DateFormula; StartingDate: Date)
    begin
        NoOfPeriods := NewNoOfPeriods;
        PeriodLength := NewPeriodLength;
        if AccountingPeriod.FindLast then
            FiscalYearStartDate := AccountingPeriod."Starting Date"
        else
            FiscalYearStartDate := StartingDate;
    end;

    procedure HideConfirmationDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

