page 50005 "Receipt Card Posted"
{
    // For the Balancing Acount Type and No: Only Customer and Vendor are necessary. but cannot remove the others because Navision takes
    // into consideration index of options not values of the same options.
    // 
    // Release - Insert the Journal line and to allocate Status to Released
    // ReOpen - Deletes Journal line and Returns the status to Open

    Editable = false;
    PageType = Card;
    SourceTable = "Reciept - Payment Lines";
    SourceTableView = SORTING("Doc No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Doc No."; "Doc No.")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        // if AssistEdit(xRec) then
                        //     CurrPage.Update;
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    Caption = 'Account No.';
                }
                field("Customer Balance (LCY)"; "Customer Balance (LCY)")
                {
                    Visible = "Bal. Account Type" = "Bal. Account Type"::Customer;
                }
                field("Vendor Balance (LCY)"; "Vendor Balance (LCY)")
                {
                    Visible = "Bal. Account Type" = "Bal. Account Type"::Vendor;
                }
                field("Bal. Account Name"; "Bal. Account Name")
                {
                    Caption = 'Account Name';
                    Editable = true;
                }
                field("Receiced From"; "Receiced From")
                {
                }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
                field(Description; Description)
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                    Caption = 'Applies to Doc No.';
                }
                field("NumberText[1]"; NumberText[1])
                {
                    Caption = 'Number Text';
                    Editable = false;
                }
                field("NumberText[2]"; NumberText[2])
                {
                    Caption = 'Number Text';
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Caption = 'Payment Method';

                    trigger OnValidate()
                    begin
                        "Payment Method".SetFilter(Code, "Payment Method Code");
                        if "Payment Method"."Payment Method" <> "Payment Method"."Payment Method"::Cheque then begin
                            "Cheque NoEditable" := false;
                        end;
                    end;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Caption = 'Payment Method Date';
                }
                field("Cheque No"; "Cheque No")
                {
                    Editable = "Cheque NoEditable";
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field(Amount_paid_box; Amount_Paid)
                {
                    Caption = 'Amount Paid';

                    trigger OnValidate()
                    begin
                        Change := Amount_Paid - Amount;
                        Modify;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("&Release")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //validation checks - 0606706  JMG
                        if "Bal. Account No." = '' then
                            Error('Please Specify an Bal. Account No.');

                        if "Account No." = '' then
                            Error('Please Specify an Account No.');

                        if "Payment Method Code" = '' then
                            Error('Please Specify a Payment Method')
                        else begin
                            if Status = Status::Released then begin
                                Error('The Receipt is already Released');
                            end;
                            //validation checks - 0606706  JMG

                            if Status = Status::Open then begin
                                RoyaltyCodeUnit.ReopenDoc(Rec);  //simply changes the status of the Receipt

                                LineNo := 1;
                                //insert the Record into the Journal
                                if GenJnl.FindLast then
                                    LineNo := GenJnl.Count + 1000000;


                                RecSet.Get;
                                GenJnl.Init;
                                GenJnl."Journal Template Name" := RecSet."Journal Template";
                                GenJnl."Journal Batch Name" := RecSet."Journal Batch";
                                GenJnl."Line No." := LineNo;
                                GenJnl."Document No." := "Doc No.";
                                GenJnl."Posting Date" := "Posting Date";
                                GenJnl."Account Type" := "Bal. Account Type";
                                GenJnl."Account No." := "Bal. Account No.";
                                GenJnl.Description := Description;
                                GenJnl."External Document No." := "Cheque No";
                                GenJnl."Currency Code" := "Currency Code";
                                GenJnl.Amount := Amount;
                                GenJnl."Bal. Account Type" := "Account Type";
                                GenJnl."Bal. Account No." := "Account No.";
                                GenJnl."Amount (LCY)" := Amount;
                                GenJnl.Insert;

                                Status := Status::Released;
                                Modify;
                                CurrPage.Update(true);
                            end;
                        end;
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Simply Removes the lines from the Journal and Reopens the Receipt
                        //Cannot Reopen if lines not there

                        if Status <> Status::Open then begin
                            RecSet.Get;
                            GenJnl.SetFilter(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SetFilter(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.SetFilter(GenJnl."Document No.", "Doc No.");

                            if not GenJnl.Find('-') then
                                Error('The Receipt lines are not present in the Journal. Cannot be Reopened');

                            if GenJnl.Find('-') then begin
                                GenJnl.DeleteAll;
                                //RylCod.NoOfDayInYear(Rec);
                            end;
                        end;
                    end;
                }
                action("&Print Receipt")
                {
                    Caption = '&Print Receipt';

                    trigger OnAction()
                    begin
                        if not (Status = Status::Open) then begin
                            lines.Copy(Rec);
                            lines.SetRecFilter;

                            /*IF COMPANYNAME = 'AACC BUSSINESS UNITS' THEN BEGIN
                              REPORT.RUN(50016,FALSE,TRUE,lines)
                            END ELSE BEGIN*/
                            REPORT.RunModal(50005, true, false, lines)
                            //END;


                        end
                        else
                            Error('Please Release Receipt %1 first', "Doc No.");

                    end;
                }
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';
                    Visible = false;

                    trigger OnAction()
                    begin
                        if not (Status = Status::Open) then begin
                            //IF GenJnl.FIND('+') THEN BEGIN
                            RecSet.Get;
                            //LineNo := GenJnl.COUNT +1000000;
                            //MESSAGE('%1',LineNo);
                            LineNo := 1;
                            if GenJnl.FindLast then
                                LineNo := GenJnl.Count + 1000000;


                            GenJnl.SetFilter(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SetFilter(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.SetFilter(GenJnl."Document No.", "Doc No.");
                            if GenJnl.Find('-') then
                                GenJnl.DeleteAll;
                            GenJnl.Reset;
                            GenJnl.Init;
                            GenJnl."Journal Template Name" := RecSet."Journal Template";
                            GenJnl."Journal Batch Name" := RecSet."Journal Batch";
                            GenJnl."Line No." := LineNo;
                            GenJnl."Document No." := "Doc No.";
                            GenJnl."Posting Date" := "Posting Date";
                            GenJnl."Account Type" := "Bal. Account Type";
                            GenJnl."Account No." := "Bal. Account No.";
                            GenJnl.Description := Description;
                            GenJnl."External Document No." := "Cheque No";
                            GenJnl."Currency Code" := "Currency Code";
                            GenJnl.Amount := Amount;
                            GenJnl."Bal. Account Type" := "Account Type";
                            GenJnl."Bal. Account No." := "Account No.";
                            GenJnl."Amount (LCY)" := Amount;
                            GenJnl.Insert;
                            Commit;
                            //accounts below -For Test purposes VEGA NM
                            GenJnl.SetFilter(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SetFilter(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl2.SetFilter(GenJnl2."Document No.", "Doc No.");
                            if GenJnl2.Find('-') then
                                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Apply", GenJnl2)
                            else
                                Message('There is nothing to Apply');
                        end
                        else
                            Error('Please Release the Receipt %1 first.', "Doc No.");
                    end;
                }
                separator(Action1000000050)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Cheque NoEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        // CheckReport.InitTextVariable;
        CheckAmount := Amount;

        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
        OnActivateForm;
    end;

    var
        GenJnl: Record "Gen. Journal Line";
        Text001: Label 'Are you sure you want to Release the document?';
        RecSet: Record "Sales & Receivables Setup";
        LineNo: Integer;
        Text002: Label 'This receipt has already been released';
        text003: Label 'Please release the receipt before printing';
        RylCod: Codeunit "Property Management";
        ReceiptLine: Record "Reciept - Payment Lines";
        NoSeries: Codeunit NoSeriesManagement;
        Change_due: Decimal;
        Receivedby: Text[30];
        AccNo: Code[20];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Text000: Label 'You must specify %1 or %2.';
        Text101: Label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text102: Label 'Do you wish to continue?';
        Text103: Label 'The update has been interrupted to respect the warning.';
        Text105: Label 'The %1 or %2 must be Customer or Vendor.';
        Text106: Label 'All entries in one application must be in the same currency.';
        Text107: Label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
        OK: Boolean;
        CurrencyCode2: Code[10];
        Currency: Record Currency;
        RoyaltyCodeUnit: Codeunit "Property Management";
        GenSetup: Record "General Ledger Setup";
        window: Dialog;
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesline: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CompanyAddr: Text[80];
        CheckStatusText: Text[30];
        CheckAmount: Decimal;
        NumberText: array[2] of Text[80];
        lines: Record "Reciept - Payment Lines";
        GenJnl2: Record "Gen. Journal Line";
        "Payment Method": Record "Payment Method";
        [InDataSet]
        "Cheque NoEditable": Boolean;
    // CheckReport: Report "Check - Receipt Requirement";

    local procedure AmountOnAfterValidate()
    begin
        // CheckReport.InitTextVariable;
        CheckAmount := Amount;
        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        // CheckReport.InitTextVariable;
        CheckAmount := Amount;

        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
    end;

    local procedure OnActivateForm()
    begin
        // CheckReport.InitTextVariable;
        CheckAmount := Amount;
        // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
    end;
}

