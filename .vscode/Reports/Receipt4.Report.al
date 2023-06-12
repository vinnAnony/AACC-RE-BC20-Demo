report 50032 Receipt4
{
    DefaultLayout = RDLC;
    RDLCLayout = './Receipt4.rdlc';

    dataset
    {
        dataitem("Reciept - Payment Lines"; "Reciept - Payment Lines")
        {
            DataItemTableView = SORTING("Doc No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Doc No.";
            column(Reciept___Payment_Lines__Doc_No__; "Doc No.")
            {
            }
            column(Reciept___Payment_Lines_Amount; Amount)
            {
            }
            column(Reciept___Payment_Lines__Reciept___Payment_Lines___Currency_Code_; "Reciept - Payment Lines"."Currency Code")
            {
            }
            column(Reciept___Payment_Lines__Cheque_No_; "Cheque No")
            {
            }
            column(Reciept___Payment_Lines_Description; Description)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(TIME; Time)
            {
            }
            column(Reciept___Payment_Lines__Payment_Method_Code_; "Payment Method Code")
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(NumberText_2_; NumberText[2])
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(Reciept___Payment_Lines__Receiced_From_; "Receiced From")
            {
            }
            column(Receipt_NoCaption; Receipt_NoCaptionLbl)
            {
            }
            column(Check_No_Caption; Check_No_CaptionLbl)
            {
            }
            column(Received_From_Caption; Received_From_CaptionLbl)
            {
            }
            column(The_sum_of_____Caption; The_sum_of_____CaptionLbl)
            {
            }
            column(Being_Payment_of____Caption; Being_Payment_of____CaptionLbl)
            {
            }
            column(With_ThanksCaption; With_ThanksCaptionLbl)
            {
            }
            column(Payment_MethodCaption; Payment_MethodCaptionLbl)
            {
            }
            column(For_Finance_Manager_Caption; For_Finance_Manager_CaptionLbl)
            {
            }
            // dataitem("Integer"; "Integer")
            // {
            //     DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            // }

            trigger OnAfterGetRecord()
            begin
                if "No. Printed" > 1 then
                    CopyText := StrSubstNo('Copy No. %1', "No. Printed");
                if "Currency Code" <> '' then
                    CurrCode := "Currency Code"
                else begin
                    CurrCode := GLSetup."LCY Code";
                end;

                // CheckReport.InitTextVariable;
                CheckAmount := Amount;
                // CheckReport.FormatNoText(NumberText, CheckAmount, GenJnlLine."Currency Code");
            end;

            trigger OnPostDataItem()
            begin
                if not CurrReport.Preview then begin
                    "No. Printed" := "No. Printed" + 1;
                    Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
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

        //CompanyInfo.GET;
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);//
    end;

    var
        ReceiptLine: Record "Reciept - Payment Lines";
        GenJnl: Record "Gen. Journal Line";
        RecSet: Record "Reciept - Payment Lines";
        LineNo: Integer;
        Text002: Label 'Receipt has already been released';
        Text001: Label 'Release and Print the receipt?';
        RoyaltyCodeUnit: Codeunit "Property Management";
        AccTypevar: Text[30];
        AccNamevar: Text[30];
        AccNovar: Text[30];
        BalAccTypevar: Text[30];
        BalAccNamevar: Text[30];
        BalAccNovar: Text[30];
        CompInfo: Record "Company Information";
        CompanyInfo: Record "Company Information";
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        CopyText: Text[50];
        CurrCode: Code[20];
        GLSetup: Record "General Ledger Setup";
        CompanyInfo1: Record "Company Information";
        Text004: Label 'Receipt %1';
        Text005: Label 'Page %1';
        // CheckReport: Report "Check - Receipt Requirement";
        CheckAmount: Decimal;
        NumberText: array[2] of Text[80];
        GenJnlLine: Record "Gen. Journal Line";
        Receipt_NoCaptionLbl: Label 'Receipt No';
        Check_No_CaptionLbl: Label 'Check No.';
        Received_From_CaptionLbl: Label 'Received From:';
        The_sum_of_____CaptionLbl: Label 'The sum of.... ';
        Being_Payment_of____CaptionLbl: Label 'Being Payment of ...';
        With_ThanksCaptionLbl: Label 'With Thanks';
        Payment_MethodCaptionLbl: Label 'Payment Method';
        For_Finance_Manager_CaptionLbl: Label 'For Finance Manager.';
}

