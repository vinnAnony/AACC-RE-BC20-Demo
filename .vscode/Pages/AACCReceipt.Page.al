page 50024 "AACC Receipt"
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
                      WHERE(Posted = CONST(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                label("Applied to Doc. No.")
                {
                    CaptionClass = Text19036871;
                }
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

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Doc Type"; "Doc Type")
                {
                    Editable = "Doc TypeEditable";
                }
                field(Description; Description)
                {
                    Editable = DescriptionEditable;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    Editable = "Bal. Account TypeEditable";
                    OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Author';

                    trigger OnValidate()
                    begin
                        "Bal. Account No." := '';
                    end;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    Editable = "Bal. Account No.Editable";
                }
                field("Bal. Account Name"; "Bal. Account Name")
                {
                    Editable = "Bal. Account NameEditable";
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = "Currency CodeEditable";
                }
                field(Amount; Amount)
                {
                    Editable = AmountEditable;

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
                field("Account Type"; "Account Type")
                {
                    Editable = "Account TypeEditable";
                    OptionCaption = ',Customer';

                    trigger OnValidate()
                    begin
                        "Account No." := '';
                    end;
                }
                field("Account No."; "Account No.")
                {
                    Editable = "Account No.Editable";

                    trigger OnValidate()
                    begin
                        AccountNoOnAfterValidate;
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
                        "Payment Method".SetRange(Code, "Payment Method Code");
                        "Payment Method".SetRange("Payment Method", "Payment Method"."Payment Method"::Cheque);

                        if "Payment Method".FindFirst then
                            "Cheque NoEditable" := true
                        else
                            "Cheque NoEditable" := false;
                    end;
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
                field(Posted; Posted)
                {
                    Editable = false;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Caption = 'Payment Method Date';
                    Editable = "Cheque DateEditable";
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
                                RoyaltyCodeUnit.ReleaseDoc(Rec);  //simply changes the status of the Receipt

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
                                GenJnl.Validate("Currency Code", "Currency Code");
                                GenJnl.Amount := Amount;
                                GenJnl."Bal. Account Type" := "Account Type";
                                GenJnl."Bal. Account No." := "Account No.";
                                GenJnl."Amount (LCY)" := Amount;
                                GenJnl.Insert;


                                "Amount In Words" := NumberText[1] + NumberText[2];
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

                    trigger OnAction()
                    begin
                        //Simply Removes the lines from the Journal and Reopens the Receipt
                        //Cannot Reopen if lines not there

                        if Status <> Status::Open then begin
                            RecSet.Get;
                            GenJnl.SetFilter(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SetFilter(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.SetFilter(GenJnl."Document No.", "Doc No.");
                            GenJnl.SetFilter(Amount, '<>%1', 0);

                            if not GenJnl.Find('-') then
                                Error('The Receipt lines are not present in the Journal. Cannot be Reopened');

                            if GenJnl.Find('-') then begin
                                GenJnl.DeleteAll;
                                RylCod.ReopenDoc(Rec);
                            end;
                        end;
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    var
                        ReceiptRec: Record "Reciept - Payment Lines";
                    begin
                        //ReceiptRec.COPY(Rec);
                        //ReceiptRec.SETRECFILTER;

                        //REPORT.RUNMODAL(50007,TRUE,FALSE,ReceiptRec);
                    end;
                }
                action("Post & Print")
                {
                    Caption = 'Post & Print';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Rooms: Record Resource;
                        Guests: Record Customer;
                    begin
                        if (Status <> Status::Open) and (Amount > 0) then begin
                            RecSet.Get;
                            GenJnl.SetFilter(GenJnl."Journal Template Name", RecSet."Journal Template");
                            GenJnl.SetFilter(GenJnl."Journal Batch Name", RecSet."Journal Batch");
                            GenJnl.SetFilter(GenJnl."Document No.", "Doc No.");
                            GenJnl.SetFilter(GenJnl.Amount, '>%1', 0);
                            if GenJnl.Find('-') then begin
                                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnl);
                                //Print Receipt
                                lines.Copy(Rec);
                                lines.SetRecFilter;
                                Posted := true;

                                if CompanyName = 'AACC BUSSINESS UNITS' then begin
                                    REPORT.Run(50016, false, true, lines)
                                end else begin
                                    REPORT.Run(50006, false, true, lines)
                                end;

                                //REPORT.RUN(50006,FALSE,TRUE,lines);
                                Modify;

                                //REPORT.RUN(50006,TRUE,FALSE,lines);
                                //End of Print Receipt
                            end;
                            GenJnl2.SetFilter("Journal Template Name", RecSet."Journal Template");
                            GenJnl2.SetFilter("Journal Batch Name", RecSet."Journal Batch");
                            GenJnl2.SetFilter("Document No.", "Doc No.");
                            GenJnl2.SetFilter(Amount, '>%1', 0);

                        end;
                    end;
                }
                separator(Action1000000031)
                {
                }
                action("Print Receipt")
                {
                    Caption = 'Print Receipt';

                    trigger OnAction()
                    var
                        ReceiptRec: Record "Reciept - Payment Lines";
                    begin
                        if Posted then begin
                            ReceiptRec.Copy(Rec);
                            ReceiptRec.SetRecFilter;
                            REPORT.RunModal(50006, true, false, ReceiptRec);
                        end;
                    end;
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
        Amount_paid_boxEditable := true;
        "Bal. Account NameEditable" := true;
        "Bal. Account TypeEditable" := true;
        "Bal. Account No.Editable" := true;
        "Cheque NoEditable" := true;
        "Payment Method CodeEditable" := true;
        AmountEditable := true;
        "Currency CodeEditable" := true;
        "Account No.Editable" := true;
        DescriptionEditable := true;
        "Doc TypeEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Validate("Doc No.", ' ');
        Validate("Account Type", "Account Type"::Customer);
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
        g_datDate: Date;
        [InDataSet]
        "Doc No.Editable": Boolean;
        [InDataSet]
        "Posting DateEditable": Boolean;
        [InDataSet]
        "Doc TypeEditable": Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "Payment Method CodeEditable": Boolean;
        [InDataSet]
        NameEditable: Boolean;
        [InDataSet]
        "Cheque NoEditable": Boolean;
        [InDataSet]
        "Bal. Account No.Editable": Boolean;
        [InDataSet]
        "Account TypeEditable": Boolean;
        [InDataSet]
        "Bal. Account TypeEditable": Boolean;
        [InDataSet]
        "Bal. Account NameEditable": Boolean;
        [InDataSet]
        "Applies-to Doc. No.Editable": Boolean;
        [InDataSet]
        Amount_paid_boxEditable: Boolean;
        [InDataSet]
        "Cheque DateEditable": Boolean;
        Text19036871: Label 'Applies to Doc No.';
    // l_frmDatePicker: Page Page50081;

    local procedure PostingDateOnAfterValidate()
    begin
        // InsertDocNo();
    end;

    local procedure AmountOnAfterValidate()
    begin
        /*CheckReport.InitTextVariable;
        CheckAmount := Amount;
        CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code");*/

    end;

    local procedure AccountNoOnAfterValidate()
    begin
        Validate("Sell To Cust.", "Account No.");
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if Status = Status::Released then begin
            "Doc No.Editable" := false;
            "Posting DateEditable" := false;
            "Doc TypeEditable" := false;
            DescriptionEditable := false;
            "Account No.Editable" := false;
            "Currency CodeEditable" := false;
            AmountEditable := false;
            "Payment Method CodeEditable" := false;
            NameEditable := false;
            //CurrForm."Amount In Words".EDITABLE := FALSE;
            "Cheque NoEditable" := false;
            "Bal. Account No.Editable" := false;
            "Account TypeEditable" := false;
            "Bal. Account TypeEditable" := false;
            "Bal. Account NameEditable" := false;
            "Applies-to Doc. No.Editable" := false;
            Amount_paid_boxEditable := false;
            //CurrForm."Receiced From".EDITABLE := FALSE;
            "Cheque DateEditable" := false;
        end
        else begin
            //CurrForm."Doc No.".EDITABLE := TRUE;
            "Posting DateEditable" := true;
            "Doc TypeEditable" := true;
            DescriptionEditable := true;
            "Account No.Editable" := true;
            "Currency CodeEditable" := true;
            AmountEditable := true;
            "Payment Method CodeEditable" := true;
            NameEditable := true;
            //CurrForm."Amount In Words".EDITABLE := TRUE;
            "Cheque NoEditable" := true;
            "Bal. Account No.Editable" := true;
            "Account TypeEditable" := true;
            "Bal. Account TypeEditable" := true;
            "Bal. Account TypeEditable" := true;
            "Applies-to Doc. No.Editable" := true;
            Amount_paid_boxEditable := true;
            //CurrForm."Receiced From".EDITABLE := TRUE;
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
        CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code");  */

    end;
}

