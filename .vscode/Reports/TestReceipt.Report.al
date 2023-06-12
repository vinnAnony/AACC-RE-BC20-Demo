report 50006 "Test Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TestReceipt.rdlc';

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
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(CompanyAddr_2_; CompanyAddr[2])
            {
            }
            column(CompanyAddr_3_; CompanyAddr[3])
            {
            }
            column(CompanyAddr_4_; CompanyAddr[4])
            {
            }
            column(CompanyAddr_5_; CompanyAddr[5])
            {
            }
            column(CompanyAddr_6_; CompanyAddr[6])
            {
            }
            column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
            {
            }
            column(AccName; AccName)
            {
            }
            column(Reciept___Payment_Lines__Currency_Code_; "Currency Code")
            {
            }
            column(Reciept___Payment_Lines_Amount; Amount)
            {
            }
            column(Reciept___Payment_Lines__Amount_In_Words_; "Amount In Words")
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
            column(TEST_RECEIPTCaption; TEST_RECEIPTCaptionLbl)
            {
            }
            column(Receipt_NoCaption; Receipt_NoCaptionLbl)
            {
            }
            column(CompanyInfo__Phone_No__Caption; CompanyInfo__Phone_No__CaptionLbl)
            {
            }
            column(NoCaption; NoCaptionLbl)
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
            // dataitem("Integer"; "Integer")
            // {
            //     DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
            // }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                // FormatAddr.Company(CompanyAddr, CompanyInfo);

                Cust.Get("Reciept - Payment Lines"."Bal. Account No.");
                AccName := Cust.Name;
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
        // FormatAddr: Codeunit "Format Address";
        Cust: Record Customer;
        AccName: Text[30];
        TEST_RECEIPTCaptionLbl: Label 'TEST RECEIPT';
        Receipt_NoCaptionLbl: Label 'Receipt No';
        CompanyInfo__Phone_No__CaptionLbl: Label 'Phone No.';
        NoCaptionLbl: Label 'No';
        Received_From_CaptionLbl: Label 'Received From:';
        The_sum_of_____CaptionLbl: Label 'The sum of.... ';
        Being_Payment_of____CaptionLbl: Label 'Being Payment of ...';
        With_ThanksCaptionLbl: Label 'With Thanks';
        Payment_MethodCaptionLbl: Label 'Payment Method';
}

