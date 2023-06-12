page 50046 "Send PaySlip Via Email"
{
    Caption = 'Employee List';
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SaveValues = true;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(FullName; FullName)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the employee.';
                    Visible = false;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                    NotBlank = true;
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                    ToolTip = 'Specifies the employee''s middle name.';
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                    NotBlank = true;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Private Email';
                    ToolTip = 'Specifies the employee''s private email address.';
                }
                field("Send PaySlip Via Email"; "Send PaySlip Via Email")
                {
                }
            }
            group(Control100000004)
            {
                ShowCaption = false;
                group("Payroll Period")
                {
                    Caption = 'Payroll Period';
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        Caption = 'Pay Period';
                        // TableRelation = Table50053.Field4;

                        trigger OnValidate()
                        begin
                            SelectedPeriod := SelectedPeriod;
                            CurrPage.Update(true);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action(SelectEmployee)
            {
                Caption = 'Select Employee for E-Payslip';
                Image = SelectEntries;
                Promoted = true;

                trigger OnAction()
                begin

                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindFirst then
                        repeat
                            Rec."Send PaySlip Via Email" := true;
                            Rec.Modify(true);
                        until Rec.Next = 0;
                end;
            }
            action(DeselectEmployee)
            {
                Caption = 'De-Select  Employee for E-Payslip';
                Image = SelectEntries;
                Promoted = true;

                trigger OnAction()
                begin

                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindFirst then
                        repeat
                            Rec."Send PaySlip Via Email" := false;
                            Rec.Modify(true);
                        until Rec.Next = 0;
                end;
            }
            action(SendPDF)
            {
                Caption = 'Send Email';
                Image = XMLFile;
                Promoted = true;

                trigger OnAction()
                var
                    "Count": Integer;
                begin
                    if SelectedPeriod = 0D then
                        Error(Text002);

                    //notification for employees without email
                    Rec.SetFilter("Send PaySlip Via Email", '%1', true);
                    if Rec.Find('-') then
                        repeat
                            if Rec."E-Mail" = '' then
                                if not Confirm(Text200, true, Rec."No.") then
                                    exit;
                        until Rec.Next = 0;


                    //Create PDF and send email
                    Rec.SetFilter("Send PaySlip Via Email", '%1', true);
                    Rec.SetFilter("E-Mail", '<>%1', '');
                    if Rec.Find('-') then begin
                        ProgressWindow.Open('Sending Payslip #1###################');
                        repeat
                            Count += 1;
                            // Payee.RESET;
                            // Payee.SETRANGE("Employee No.", Rec."No.");
                            // if Payee.FIND('-') then
                            //     SaveAsPDF.SaveMailWithPDF(Payee, SelectedPeriod);

                            //SLEEP(1000);
                            ProgressWindow.Update(1, Rec."No.");

                        until Rec.Next = 0;

                        ProgressWindow.Close;
                        Message(Text100);

                    end else
                        Error(Text001);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SelectedPeriod := SelectedPeriod;
    end;

    var
        SelectedPeriod: Date;
        Text001: Label 'You must first select a list of the employees you want to process';
        // SaveAsPDF: Codeunit Codeunit50046;
        // PayrollPeriod: Record Table50053;
        // Payee: Record Table50054;
        Text002: Label 'You Must select Payroll Period';
        ProgressWindow: Dialog;
        Text100: Label 'PaySlips Successfully Sent';
        Employee2: Record Employee;
        Text200: Label 'Employee %1 does not have an email address, do you want to continue?';
}

