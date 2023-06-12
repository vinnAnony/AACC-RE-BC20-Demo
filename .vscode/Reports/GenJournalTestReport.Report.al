report 50008 "Gen. Journal Test Report"
{
    // AACC.D001.01
    // added parameter Document no to function LoadNarration
    DefaultLayout = RDLC;
    RDLCLayout = './GenJournalTestReport.rdlc';


    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(BatchName; "Gen. Journal Line"."Journal Batch Name")
            {
            }
            column(DocumentNo; "Gen. Journal Line"."Document No.")
            {
            }
            column(DocumentDate; "Gen. Journal Line"."Document Date")
            {
            }
            column(AccountType; "Gen. Journal Line"."Account Type")
            {
            }
            column(AccountNo; "Gen. Journal Line"."Account No.")
            {
            }
            column(AccountName; "Gen. Journal Line"."Account Name")
            {
            }
            column(Description; "Gen. Journal Line".Description)
            {
            }
            column(ExternalDocNo; "Gen. Journal Line"."External Document No.")
            {
            }
            column(DebitAmount; "Gen. Journal Line"."Debit Amount")
            {
            }
            column(CreditAmount; "Gen. Journal Line"."Credit Amount")
            {
            }
            column(BalAccountType; "Gen. Journal Line"."Bal. Account Type")
            {
            }
            column(BalAccountNo; "Gen. Journal Line"."Bal. Account No.")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Address; CompanyInfo.Address)
            {
            }
            column(City; CompanyInfo.City)
            {
            }
            column(Email; CompanyInfo."E-Mail")
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(NumberText1; NumberText[1])
            {
            }
            column(NumberText2; NumberText[2])
            {
            }
            column(Balance; Balance)
            {
            }
            column(BalanceLCY; BalanceLCY)
            {
            }
            column(UserID; "Gen. Journal Line"."User ID")
            {
            }
            column(Dimension2Code; "Gen. Journal Line"."Shortcut Dimension 2 Code")
            {
            }
            column(Currency; "Gen. Journal Line"."Currency Code")
            {
            }
            column(Narration; Narration)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LoadFooterBalance;
                i += 1;
                LoadNarration(i, "Journal Template Name", "Journal Batch Name", "Document No.");
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        FormatAddr.Company(CompanyAddr, CompanyInfo);
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text;
        FormatAddr: Codeunit "Format Address";
        // CheckReport: Report "Check - Receipt Requirement";
        CheckAmount: Decimal;
        NumberText: array[2] of Text[80];
        Balance: Decimal;
        BalanceLCY: Decimal;
        GenJnlBatch: Record "Gen. Journal Batch";
        Narration: Text[100];
        i: Integer;

    local procedure CalculateTotalBalanceLCY(GenJournalLine: Record "Gen. Journal Line"): Decimal
    var
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine2.SetFilter("Amount (LCY)", '>%1', 0);
        GenJournalLine2.CalcSums("Amount (LCY)");
        exit(GenJournalLine2."Amount (LCY)");
    end;

    local procedure CalculateTotalBalance(GenJournalLine: Record "Gen. Journal Line"): Decimal
    var
        GenJournalLine2: Record "Gen. Journal Line";
        TotalDebits: Decimal;
        TotalCredits: Decimal;
    begin
        GenJournalLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine2.CalcSums("Debit Amount");
        //TotalDebits:=GenJournalLine2."Debit Amount";

        /*GenJournalLine2.RESET;
        GenJournalLine2.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        GenJournalLine2.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        GenJournalLine2.CALCSUMS("Credit Amount");
        TotalCredits:=GenJournalLine2."Credit Amount";*/

        //EXIT(TotalDebits-TotalCredits);
        exit(GenJournalLine2."Debit Amount");

    end;

    local procedure LoadFooterBalance()
    begin
        Balance := CalculateTotalBalance("Gen. Journal Line");
        BalanceLCY := CalculateTotalBalanceLCY("Gen. Journal Line");

        // CheckReport.InitTextVariable;
        CheckAmount := BalanceLCY;
        // CheckReport.FormatNoText(NumberText, CheckAmount, "Gen. Journal Line"."Currency Code");
    end;

    local procedure LoadNarration(i: Integer; JournalTemplate: Code[20]; JournalBatch: Code[20]; DocNo: Code[50])
    begin
        //RMM
        // if i <= 1 then
        //     Narration := GenJnlBatch.GetNarration(JournalTemplate, JournalBatch, DocNo);
        //RMM Ends
    end;
}

