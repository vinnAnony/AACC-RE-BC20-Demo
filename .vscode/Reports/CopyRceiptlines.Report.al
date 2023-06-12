report 50041 "Copy Rceipt lines"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CopyRceiptlines.rdlc';

    dataset
    {
        dataitem("Reciept - Payment Header"; "Reciept - Payment Header")
        {
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
        // CodeAssign.Run();
    end;

    var
        Receiptline: Record "Reciept - Payment Lines";
        ReceiptHeader: Record "Reciept - Payment Header";
        CountRec: Integer;
        LastDocNo: Code[50];
    // CodeAssign: Codeunit "Assign Values";

    [Scope('Internal')]
    procedure InitializeValue()
    begin

        /*
        WITH Receiptline DO BEGIN
        
          IF FINDFIRST THEN BEGIN
            REPEAT
              CountRec += 1;
                  ReceiptHeader.INIT;
                    //ERROR('Doc No %1', "Doc No.");
                    //EXIT;
                    IF ReceiptHeader.INSERT THEN
                      MESSAGE('Doc No %1 is already in', ReceiptHeader."Doc No.");
        
                    ReceiptHeader.VALIDATE("Doc No.", "Doc No.");
                    {
                    ReceiptHeader."Posting Date":= "Posting Date";
                    ReceiptHeader.Description:= Description;
                    ReceiptHeader."Account No." := "Account No.";
                    ReceiptHeader."Currency Code" := "Currency Code";
                    ReceiptHeader.Amount := Amount;
                    ReceiptHeader."Payment Method Code" := "Payment Method Code";
                    ReceiptHeader."No. Series" := "No. Series";
                    ReceiptHeader.Status := Status;
                    ReceiptHeader."Amount In Words" := "Amount In Words";
                    ReceiptHeader."Cheque No" := "Cheque No";
                    ReceiptHeader."Account Type" := "Account Type";
                    ReceiptHeader."Amount (LCY)" := "Amount (LCY)";
                    ReceiptHeader."Applies-to Doc. No." := "Applies-to Doc. No.";
                    ReceiptHeader."Applies-to ID" := "Applies-to ID";
                    ReceiptHeader."Receiced From" := "Receiced From";
                    ReceiptHeader."Cheque Date" := "Cheque Date";
                    ReceiptHeader.Amount_Paid := Amount_Paid;
                    ReceiptHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    ReceiptHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    ReceiptHeader."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                    ReceiptHeader."Currency Factor" := "Currency Factor";
                    IF Status = Status::Released THEN
                      ReceiptHeader."Posted Receipt" := TRUE
                    ELSE
                      ReceiptHeader."Posted Receipt" := FALSE;
                      }
                   //END;
                   //LastDocNo := ReceiptHeader."Doc No.";
                   ReceiptHeader.INSERT(TRUE);
        
        
            UNTIL NEXT=0;
          END;
        END;
        */

    end;
}

