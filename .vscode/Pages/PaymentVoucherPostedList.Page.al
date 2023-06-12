page 50033 "Payment Voucher Posted List"
{
    CardPageID = "Payment Voucher Posted";
    Editable = false;
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Voucher Posted List';
    UsageCategory = Tasks;
    SourceTable = "Payment Voucher Header";
    SourceTableView = SORTING("PV No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("PV No."; "PV No.")
                {
                }
                field(Date; Date)
                {
                }
                field(Type; Type)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Payment Mode"; "Payment Mode")
                {
                    Editable = false;
                }
                field("Cheque No."; "Cheque No.")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Bank Code"; "Bank Code")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Supplier No."; "Supplier No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Amount Calculated"; "Amount Calculated")
                {
                }
                field("Transaction Name"; "Transaction Name")
                {
                }
                field(Status; Status)
                {
                    Editable = true;
                }
                field("Prepared By"; "Prepared By")
                {
                }
                field("Prepared Date"; "Prepared Date")
                {
                }
                field("Programme Officer"; "Programme Officer")
                {
                }
                field("Programme Officer App Date"; "Programme Officer App Date")
                {
                }
                field("Finance Officer"; "Finance Officer")
                {
                }
                field("Finance Officer App Date"; "Finance Officer App Date")
                {
                }
                field("Supplier Name"; "Supplier Name")
                {

                    trigger OnValidate()
                    begin
                        PaymentLine.Reset;
                        PaymentLine.SetRange("PV No.", "PV No.");
                        if PaymentLine.Find('-') then begin
                            "Supplier Name" := PaymentLine."Vendor Name";
                        end;
                    end;
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Reviewed By"; "Reviewed By")
                {
                }
                field("Reviewed Date"; "Reviewed Date")
                {
                }
                field("First Signatory"; "First Signatory")
                {
                }
                field("First Signatory Date"; "First Signatory Date")
                {
                }
                field("Second Signatory"; "Second Signatory")
                {
                }
                field("Second Signatory Date"; "Second Signatory Date")
                {
                }
                field("Cheque/Cash Recieved By"; "Cheque/Cash Recieved By")
                {
                }
                field("Cheque/Cash Recieved Date"; "Cheque/Cash Recieved Date")
                {
                }
                field("ID No./Passport No."; "ID No./Passport No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test Report")
            {
                Caption = 'Test Report';
                Image = TestReport;

                trigger OnAction()
                begin

                    Reset;
                    SetFilter("PV No.", "PV No.");
                    REPORT.Run(50024, true, true, Rec);
                    Reset;
                end;
            }
            action("PV Remittance Advice")
            {
                Caption = 'PV Remittance Advice';

                trigger OnAction()
                begin

                    Reset;
                    SetFilter("PV No.", "PV No.");
                    REPORT.Run(50028, true, true, Rec);
                    Reset;
                end;
            }
            action(SendCustomAttachment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send Notification';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin

                    begin

                        PaymentVoucherHeader.Reset;
                        PaymentVoucherHeader.SetRange("PV No.", Rec."PV No.");
                        if PaymentVoucherHeader.FindFirst then
                            // SMTPMailSetup.Get;

                            //Get Vendor Details
                            VendorRec.Reset;
                        if VendorRec.Get("Supplier No.") then;
                        //Get mail details.
                        CompanyInformation.Get;
                        SenderName := CompanyInformation.Name;
                        // SenderAddress := SMTPMailSetup."User ID";
                        RecepientAddress := VendorRec."E-Mail";
                        ReceipentName := Rec."Supplier Name";
                        PaymentMethod.Reset;
                        PaymentMethod.SetRange(Code, "Payment Mode");
                        if PaymentMethod.Find('-') then begin
                            "Payment Mode" := PaymentMethod.Description;
                        end;
                        MailSubject := CompanyInformation.Name + ' ' + '' + Format(Rec."Payment Mode");

                        //create mail text
                        // smtpmail.CreateMessage(SenderName, SenderAddress, RecepientAddress, MailSubject, '', true);


                        // smtpmail.AppendBody('Dear Sir/Madam');
                        // smtpmail.AppendBody('<br><br>');

                        if "Currency Code" = '' then
                            "Currency Code" := 'KSH'
                        else
                            "Currency Code" := "Currency Code";

                        // smtpmail.AppendBody(SenderName + '  ');
                        // smtpmail.AppendBody('have successfully made a Payment of  ' + '' + Format(Rec."Payment Mode") + '  ' + Format("Cheque No.") + '  ' + Format("Currency Code") + '  ' + Format(Rec.Amount) + '  ' + '.<br>This is in respect of goods supplied/services offered.');
                        // smtpmail.AppendBody('<br>');
                        // smtpmail.AppendBody('Please acknowledge on receipt of funds.');
                        // smtpmail.AppendBody('<br><br>');
                        // smtpmail.AppendBody('Thankyou');
                        // smtpmail.AppendBody('<br><br>');
                        // smtpmail.AppendBody('Best Regards,');
                        // smtpmail.AppendBody('<br><br>');
                        // smtpmail.AppendBody('Accounts<br>All Africa Conference Of Churches (AACC)<br>P.O. Box 14205 - 00800<br>Nairobi, Kenya<br>Telephone: (254-20) 4441483, 4441338/9<br>website:www.aacc-ceta.org<br><br>');
                        // smtpmail.AppendBody('All Africa Conference of Churches<br>');
                        // smtpmail.AppendBody('"The Spiritual Pulse of the African Continent"<br>');
                        // smtpmail.AppendBody('Founded in 1963, the All Africa Conference of Churches is an ecumenical fellowship representing more than 140 million Christians in 42 African countries working to make a difference in the lives of<br>');
                        // smtpmail.AppendBody('the people of Africa through ministries of advocacy and presence on the continental, regional and local levels<br>');

                        if Confirm('This will send and Email. Proceed?', false) = true then begin
                            if (SenderAddress <> '') and (SenderName <> '') and (RecepientAddress <> '') then begin

                                // smtpmail.Send;
                                Message('Email Sent succesfully');
                            end
                            else
                                Error('Some Details are missing');
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PaymentLine.Reset;
        PaymentLine.SetRange("PV No.", "PV No.");
        if PaymentLine.Find('-') then begin
            PaymentVoucher."Account Type" := PaymentLine."Account Type"::Supplier;
            "Supplier No." := PaymentLine."Account No.";

        end;
    end;

    var
        PaymentVoucher: Record "Payment Voucher Header";
        IsPostedPaymentVoucherEmpty: Boolean;
        // smtpmail: Codeunit "SMTP Mail";
        // PaymentVoucherReport: Report "Payment Voucher Report";
        SenderAddress: Text[100];
        SenderName: Text[100];
        ReceipentName: Text[100];
        RecepientAddress: Text[100];
        SaveFile: Boolean;
        FileName: Text[100];
        VendorRec: Record Vendor;
        MailSubject: Text[100];
        Text0001: Label '%1 - Payment %2';
        MailBody: Text[200];
        CompanyInformation: Record "Company Information";
        // SMTPMailSetup: Record "SMTP Mail Setup";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        Paymode: Text;
        Amount: Text[100];
        PaymentLine: Record "Payment Voucher Line";
        PaymentMethod: Record "Payment Method";
}

