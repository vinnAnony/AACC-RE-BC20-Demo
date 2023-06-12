page 50015 "Deposit Receipt"
{
    // For the Balancing Acount Type and No: Only Customer and Vendor are necessary. but cannot remove the others because Navision takes
    // into consideration index of options not values of the same options.
    // 
    // Release - Insert the Journal line and to allocate Status to Released
    // ReOpen - Deletes Journal line and Returns the status to Open

    PageType = Card;
    SourceTable = "Reciept - Payment Lines";
    SourceTableView = SORTING("Doc No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Open),
                            "Doc Type" = CONST(Deposit));

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
                    Editable = "Doc No.Editable";

                    trigger OnAssistEdit()
                    begin
                        // if AssistEdit(xRec) then
                        //     CurrPage.Update;
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = "Posting DateEditable";
                }
                field("Doc Type"; "Doc Type")
                {
                    Editable = "Doc TypeEditable";
                    Visible = false;
                }
                field(Description; Description)
                {
                    Editable = DescriptionEditable;
                }
                field("Contract Code"; "Contract Code")
                {
                    // LookupPageID = 50002;
                    TableRelation = "Rent Contract Header"."Contract No." WHERE(Header = CONST(true));

                    trigger OnValidate()
                    begin
                        Rent.Get("Contract Code");
                        "Customer Code" := Rent."Customer No.";
                        if Rent.Status <> Rent.Status::Signed then //OR (Rent.Status<> Rent.Status::Amended) THEN
                            Error(Text005, "Contract Code");
                    end;
                }
                field("Customer Code"; "Customer Code")
                {

                    trigger OnValidate()
                    begin
                        Cust.Get("Customer Code");
                        Name := Cust.Name;
                        "Receiced From" := Name;
                    end;
                }
                field("Property Code"; "Property Code")
                {

                    trigger OnValidate()
                    begin
                        Res.Get("Property Code");
                        Description := Description + ' ' + Res.Name;
                    end;
                }
                field("Receiced From"; "Receiced From")
                {
                    Caption = 'Received From';
                    Editable = "Receiced FromEditable";
                }
                field(Amount; Amount)
                {
                    Editable = AmountEditable;

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
                field(Name; Name)
                {
                    Editable = NameEditable;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Caption = 'Payment Method';
                    Editable = "Payment Method CodeEditable";

                    trigger OnValidate()
                    begin

                        "Cheque NoEditable" := true;


                        "Payment Method".SetRange(Code, "Payment Method Code");
                        "Payment Method".SetRange("Payment Method", "Payment Method"."Payment Method"::Cheque);

                        if "Payment Method".FindFirst then
                            "Cheque NoEditable" := true
                        else
                            "Cheque NoEditable" := false;
                    end;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Caption = 'Payment Method Date';
                    Editable = "Cheque DateEditable";
                }
                field("Cheque No"; "Cheque No")
                {
                    Editable = "Cheque NoEditable";
                }
                field("NumberText[1]"; NumberText[1])
                {
                    Editable = false;
                }
                field("NumberText[2]"; NumberText[2])
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
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

                    trigger OnAction()
                    begin
                        //validation checks - 0606706  JMG
                        /*IF "Bal. Account No." = '' THEN
                        ERROR('Please Specify a Bal. Account No.');
                        
                        IF "Account No." = '' THEN
                        ERROR('Please Specify an Account No.');
                        
                        IF "Payment Method Code" = '' THEN
                        ERROR('Please Specify a Payment Method')
                        ELSE BEGIN
                        IF Status = Status::Released THEN BEGIN
                        ERROR('The Receipt is already Released');
                        END;
                        //validation checks - 0606706  JMG
                        
                        IF Status = Status::Open THEN BEGIN
                        RoyaltyCodeUnit.ReleaseDoc(Rec);  //simply changes the status of the Receipt
                        
                        LineNo :=1;
                        //insert the Record into the Journal
                        IF GenJnl.FINDLAST THEN
                        LineNo := GenJnl.COUNT+1000000;
                        
                        
                        RecSet.GET;
                        GenJnl.INIT;
                        GenJnl."Journal Template Name" :=  RecSet."Journal Template";
                        GenJnl."Journal Batch Name" := RecSet."Journal Batch";
                        GenJnl."Line No." := LineNo;
                        GenJnl."Document No." :="Doc No.";
                        GenJnl."Posting Date":="Posting Date" ;
                        GenJnl."Account Type" := "Bal. Account Type";
                        GenJnl."Account No.":="Bal. Account No.";
                        GenJnl.Description := Description;
                        GenJnl."External Document No." :="Cheque No";
                        GenJnl."Currency Code":= "Currency Code";
                        GenJnl.Amount:= Amount;
                        GenJnl."Bal. Account Type":= "Account Type";
                        GenJnl."Bal. Account No.":="Account No.";
                        GenJnl."Amount (LCY)" := Amount;
                        GenJnl."Deposit Type":=GenJnl."Deposit Type"::"1";
                        GenJnl."Customer Code":="Customer Code";
                        GenJnl."Property Code":="Property Code";
                        GenJnl.INSERT;
                        //Post the Journal ----------------------------------
                        GenJnlPostLine.RunWithCheck(GenJnl,TempJnlLineDim);
                        GenJnl.SETRANGE(GenJnl."Journal Template Name",RecSet."Journal Template");
                        GenJnl.SETRANGE(GenJnl."Journal Batch Name",RecSet."Journal Batch");
                        GenJnl.DELETEALL;
                        
                        "Amount In Words" := NumberText[1] + NumberText[2];
                        Status := Status::Released;
                        MODIFY;
                        CurrPage.UPDATE(TRUE);
                        END;
                        END; */

                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;

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
                                RylCod.ReopenDoc(Rec);
                            end;
                        end;
                    end;
                }
                action("&Print Receipt")
                {
                    Caption = '&Print Receipt';

                    trigger OnAction()
                    begin
                        //IF NOT (Status = Status::Open) THEN BEGIN
                        lines.Copy(Rec);
                        lines.SetRecFilter;
                        REPORT.RunModal(50006, true, false, lines);
                        //END
                        //ELSE
                        //ERROR('Please Release Receipt %1 first',"Doc No.");
                    end;
                }
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';

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
        "Cheque DateEditable" := true;
        "Receiced FromEditable" := true;
        "Cheque NoEditable" := true;
        "Payment Method CodeEditable" := true;
        AmountEditable := true;
        DescriptionEditable := true;
        "Doc TypeEditable" := true;
        "Posting DateEditable" := true;
        "Doc No.Editable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ResSet.Get;
        "Doc Type" := "Doc Type"::Deposit;
        Description := Text004;


        "Account Type" := "Account Type"::"G/L Account";
        "Account No." := ResSet."Rent Deposit Ac";
        // "Bal. Account Type" := "Bal. Account Type"::"3";
        "Bal. Account No." := ResSet."Deposit Bank Ac";
        "Posting Date" := WorkDate;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        /*CheckReport.InitTextVariable;
        CheckAmount := Amount;
        
        CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code"); */
        OnActivateForm;

    end;

    var
        Cust: Record Customer;
        Name: Text[30];
        GenJnl: Record "Gen. Journal Line";
        Text001: Label 'Are you sure you want to Release the document?';
        RecSet: Record "Sales & Receivables Setup";
        LineNo: Integer;
        Text002: Label 'This receipt has already been released';
        text003: Label 'Please release the receipt before printing';
        RylCod: Codeunit "Property Management";
        Rent: Record "Rent Contract Header";
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
        ResSet: Record "Resources Setup";
        Text004: Label 'Deposit for';
        Res: Record Resource;
        CurrentJnlBatchName: Code[10];
        Text005: Label 'Please sign contract %1 before receiving a deposit';
        [InDataSet]
        "Doc No.Editable": Boolean;
        [InDataSet]
        "Posting DateEditable": Boolean;
        [InDataSet]
        "Doc TypeEditable": Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "Payment Method CodeEditable": Boolean;
        [InDataSet]
        NameEditable: Boolean;
        [InDataSet]
        "Cheque NoEditable": Boolean;
        [InDataSet]
        "Receiced FromEditable": Boolean;
        [InDataSet]
        "Cheque DateEditable": Boolean;

    local procedure AmountOnAfterValidate()
    begin
        /*CheckReport.InitTextVariable;
        CheckAmount := Amount;
        CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code");*/

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if Status = Status::Released then begin
            "Doc No.Editable" := false;
            "Posting DateEditable" := false;
            "Doc TypeEditable" := false;
            DescriptionEditable := false;
            //CurrForm."Account No.".EDITABLE := FALSE;
            //CurrForm."Currency Code".EDITABLE := FALSE;
            AmountEditable := false;
            "Payment Method CodeEditable" := false;
            NameEditable := false;
            //CurrForm."Amount In Words".EDITABLE := FALSE;
            "Cheque NoEditable" := false;
            //CurrForm."Bal. Account No.".EDITABLE := FALSE;
            //CurrForm."Account Type".EDITABLE := FALSE;
            //CurrForm."Bal. Account Type".EDITABLE := FALSE;
            //CurrForm."Bal. Account Name".EDITABLE := FALSE;
            //CurrForm."Applies-to Doc. No.".EDITABLE := FALSE;
            //CurrForm.Amount_paid_box.EDITABLE := FALSE;
            "Receiced FromEditable" := false;
            "Cheque DateEditable" := false;
        end
        else begin
            "Doc No.Editable" := true;
            "Posting DateEditable" := true;
            "Doc TypeEditable" := true;
            DescriptionEditable := true;
            //CurrForm."Account No.".EDITABLE := TRUE;
            //CurrForm."Currency Code".EDITABLE := TRUE;
            AmountEditable := true;
            "Payment Method CodeEditable" := true;
            //CurrForm.Name.EDITABLE := TRUE;
            //CurrForm."Amount In Words".EDITABLE := TRUE;
            "Cheque NoEditable" := true;
            //CurrForm."Bal. Account No.".EDITABLE := TRUE;
            //CurrForm."Account Type".EDITABLE := TRUE;
            //CurrForm."Bal. Account Type".EDITABLE := TRUE;
            //CurrForm."Bal. Account Type".EDITABLE := TRUE;
            //CurrForm."Applies-to Doc. No.".EDITABLE := TRUE;
            //CurrForm.Amount_paid_box.EDITABLE := TRUE;
            "Receiced FromEditable" := true;
            "Cheque DateEditable" := true;

        end;

        /*CheckReport.InitTextVariable;
        CheckAmount := Amount;
        
        CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code");     */

    end;

    local procedure OnActivateForm()
    begin
        /*CheckReport.InitTextVariable;
        CheckAmount := Amount;
        CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code");*/

    end;
}

