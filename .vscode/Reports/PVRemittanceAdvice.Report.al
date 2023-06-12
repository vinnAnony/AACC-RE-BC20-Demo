report 50028 "PV Remittance Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PVRemittanceAdvice.rdlc';

    dataset
    {
        dataitem("Payment Voucher Header"; "Payment Voucher Header")
        {
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Bank_Name_; "Payment Voucher Header"."Bank Name")
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Pay_Mode_; "Payment Voucher Header"."Payment Mode")
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Cheque_No__; "Payment Voucher Header"."Cheque No.")
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Cheque_Date_; "Payment Voucher Header"."Cheque Date")
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Bank_Code_; "Payment Voucher Header"."Bank Code")
            {
            }
            column(Payment_Voucher_Header__PV_No__; "PV No.")
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___PV_Payee_; "Payment Voucher Header"."PV Payee")
            {
            }
            column(Bank_NameCaption; Bank_NameCaptionLbl)
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Pay_Mode_Caption; FieldCaption("Pay Mode"))
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Cheque_No__Caption; FieldCaption("Cheque No."))
            {
            }
            column(Payment_Voucher_Header__Payment_Voucher_Header___Cheque_Date_Caption; FieldCaption("Cheque Date"))
            {
            }
            column(Paying_BankCaption; Paying_BankCaptionLbl)
            {
            }
            column(ALL_AFRICA_CONFERENCE_OF_CHURCHESCaption; ALL_AFRICA_CONFERENCE_OF_CHURCHESCaptionLbl)
            {
            }
            column(PAYMENT_VOUCHERCaption; PAYMENT_VOUCHERCaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Currency_CodeCaption; Currency_CodeCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(Payment_Voucher_Line__Account_Type_Caption; "Payment Voucher Line".FieldCaption("Account Type"))
            {
            }
            column(Payment_Voucher_Line__Global_Dimension_2_Caption; "Payment Voucher Line".FieldCaption("Global Dimension 2"))
            {
            }
            column(Payment_Voucher_Line__Global_Dimension_1_Caption; "Payment Voucher Line".FieldCaption("Global Dimension 1"))
            {
            }
            column(V00800_Nairobi__WestlandsCaption; V00800_Nairobi__WestlandsCaptionLbl)
            {
            }
            column(Payment_Voucher_Line__Account_No__Caption; "Payment Voucher Line".FieldCaption("Account No."))
            {
            }
            column(PayeeCaption; PayeeCaptionLbl)
            {
            }
            dataitem("Payment Voucher Line"; "Payment Voucher Line")
            {
                DataItemLink = "PV No." = FIELD ("PV No.");
                DataItemTableView = SORTING ("PV No.", "Line No.");
                column(Payment_Voucher_Header__Date; "Payment Voucher Header".Date)
                {
                }
                column(Payment_Voucher_Line_Description; Description)
                {
                }
                column(Payment_Voucher_Line__Currency_Code_; "Currency Code")
                {
                }
                column(Payment_Voucher_Line_Amount; Amount)
                {
                }
                column(Payment_Voucher_Line__Account_Type_; "Account Type")
                {
                }
                column(Payment_Voucher_Line__Global_Dimension_1_; "Global Dimension 1")
                {
                }
                column(Payment_Voucher_Line__Global_Dimension_2_; "Global Dimension 2")
                {
                }
                column(Payment_Voucher_Line__Account_No__; "Account No.")
                {
                }
                column(Payment_Voucher_Line__Account_Type__Control1000000021; "Account Type")
                {
                }
                column(AccountName; AccountName)
                {
                }
                column(Payment_Voucher_Header___Amount_Calculated_; CalculatedAmt)
                {
                }
                column(Payment_Voucher_Header___Prepared_Date_; "Payment Voucher Header"."Prepared Date")
                {
                }
                column(Payment_Voucher_Header___Reviewed_Date_; "Payment Voucher Header"."Reviewed Date")
                {
                }
                column(Payment_Voucher_Header___First_Signatory_Date_; "Payment Voucher Header"."First Signatory Date")
                {
                }
                column(Payment_Voucher_Header___Second_Signatory_Date_; "Payment Voucher Header"."Second Signatory Date")
                {
                }
                column(Payment_Voucher_Header___Prepared_By_; "Payment Voucher Header"."Prepared By")
                {
                }
                column(Payment_Voucher_Header___Reviewed_By_; "Payment Voucher Header"."Reviewed By")
                {
                }
                column(Payment_Voucher_Header___First_Signatory_; "Payment Voucher Header"."First Signatory")
                {
                }
                column(Payment_Voucher_Header___Second_Signatory_; "Payment Voucher Header"."Second Signatory")
                {
                }
                column(Payment_Voucher_Header___Cheque_Cash_Recieved_Date_; "Payment Voucher Header"."Cheque/Cash Recieved Date")
                {
                }
                column(Payment_Voucher_Header___Cheque_Cash_Recieved_By_; "Payment Voucher Header"."Cheque/Cash Recieved By")
                {
                }
                column(Payment_Voucher_Header___ID_No__Passport_No__; "Payment Voucher Header"."ID No./Passport No.")
                {
                }
                column(Total_AmountCaption; Total_AmountCaptionLbl)
                {
                }
                column(Signature____________________________________Caption; Signature____________________________________CaptionLbl)
                {
                }
                column(Signature____________________________________Caption_Control1000000028; Signature____________________________________Caption_Control1000000028Lbl)
                {
                }
                column(Signature____________________________________Caption_Control1000000029; Signature____________________________________Caption_Control1000000029Lbl)
                {
                }
                column(Signature____________________________________Caption_Control1000000032; Signature____________________________________Caption_Control1000000032Lbl)
                {
                }
                column(FOR_OFFICIAL_USE_ONLYCaption; FOR_OFFICIAL_USE_ONLYCaptionLbl)
                {
                }
                column(DateCaption; DateCaptionLbl)
                {
                }
                column(DateCaption_Control1000000042; DateCaption_Control1000000042Lbl)
                {
                }
                column(DateCaption_Control1000000043; DateCaption_Control1000000043Lbl)
                {
                }
                column(DateCaption_Control1000000044; DateCaption_Control1000000044Lbl)
                {
                }
                column(Payment_Voucher_Header___Second_Signatory_Caption; "Payment Voucher Header".FieldCaption("Second Signatory"))
                {
                }
                column(Payment_Voucher_Header___Reviewed_By_Caption; "Payment Voucher Header".FieldCaption("Reviewed By"))
                {
                }
                column(Payment_Voucher_Header___First_Signatory_Caption; "Payment Voucher Header".FieldCaption("First Signatory"))
                {
                }
                column(Payment_Voucher_Header___Prepared_By_Caption; "Payment Voucher Header".FieldCaption("Prepared By"))
                {
                }
                column(Signature____________________________________Caption_Control1000000033; Signature____________________________________Caption_Control1000000033Lbl)
                {
                }
                column(ACKNOWLEDGEMENT_OF_RECEIPTCaption; ACKNOWLEDGEMENT_OF_RECEIPTCaptionLbl)
                {
                }
                column(DateCaption_Control1000000045; DateCaption_Control1000000045Lbl)
                {
                }
                column(Payment_Voucher_Header___Cheque_Cash_Recieved_By_Caption; "Payment Voucher Header".FieldCaption("Cheque/Cash Recieved By"))
                {
                }
                column(Payment_Voucher_Header___ID_No__Passport_No__Caption; "Payment Voucher Header".FieldCaption("ID No./Passport No."))
                {
                }
                column(Payment_Voucher_Line_PV_No_; "PV No.")
                {
                }
                column(Payment_Voucher_Line_Line_No_; "Line No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalculatedAmt := 0;

                if "Payment Voucher Header"."Bank Code" <> '' then begin
                    BankAccount.Get("Bank Code");
                    "Payment Voucher Header"."Bank Name" := BankAccount.Name;
                end;

                CalculatedAmt := GetHeaderFCYAmount("PV No.");
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        AccountName: Text[30];
        GLAccount: Record "G/L Account";
        Vendoracc: Record Vendor;
        Customeracc: Record Customer;
        BankAccount: Record "Bank Account";
        Bank_NameCaptionLbl: Label 'Bank Name';
        Paying_BankCaptionLbl: Label 'Paying Bank';
        ALL_AFRICA_CONFERENCE_OF_CHURCHESCaptionLbl: Label 'ALL AFRICA CONFERENCE OF CHURCHES';
        PAYMENT_VOUCHERCaptionLbl: Label 'PAYMENT VOUCHER';
        Posting_DateCaptionLbl: Label 'Posting Date';
        DescriptionCaptionLbl: Label 'Description';
        Currency_CodeCaptionLbl: Label 'Currency Code';
        AmountCaptionLbl: Label 'Amount';
        V00800_Nairobi__WestlandsCaptionLbl: Label '00800 Nairobi, Westlands';
        PayeeCaptionLbl: Label 'Payee';
        Total_AmountCaptionLbl: Label 'Total Amount';
        Signature____________________________________CaptionLbl: Label 'Signature:...................................';
        Signature____________________________________Caption_Control1000000028Lbl: Label 'Signature:...................................';
        Signature____________________________________Caption_Control1000000029Lbl: Label 'Signature:...................................';
        Signature____________________________________Caption_Control1000000032Lbl: Label 'Signature:...................................';
        FOR_OFFICIAL_USE_ONLYCaptionLbl: Label 'FOR OFFICIAL USE ONLY';
        DateCaptionLbl: Label 'Date';
        DateCaption_Control1000000042Lbl: Label 'Date';
        DateCaption_Control1000000043Lbl: Label 'Date';
        DateCaption_Control1000000044Lbl: Label 'Date';
        Signature____________________________________Caption_Control1000000033Lbl: Label 'Signature:...................................';
        ACKNOWLEDGEMENT_OF_RECEIPTCaptionLbl: Label 'ACKNOWLEDGEMENT OF RECEIPT';
        DateCaption_Control1000000045Lbl: Label 'Date';
        CalculatedAmt: Decimal;
        PVHeader: Record "Payment Voucher Header";
        CurrExchRate: Record "Currency Exchange Rate";

    [Scope('Internal')]
    procedure GetHeaderFCYAmount(PVNo: Code[20]) CalcAmt: Decimal
    begin
        //RMM 04/10/2018
        with PVHeader do begin
            Reset;
            SetRange("PV No.", PVNo);
            if Find('-') then begin
                CalcFields("Amount Calculated (LCY)");
                if "Currency Code" = '' then
                    CalcAmt := "Amount Calculated (LCY)"
                else
                    CalcAmt := Round(CurrExchRate.ExchangeAmtLCYToFCY(
                             Date, "Currency Code",
                             "Amount Calculated (LCY)", "Currency Factor"));
            end;
        end;
    end;
}

