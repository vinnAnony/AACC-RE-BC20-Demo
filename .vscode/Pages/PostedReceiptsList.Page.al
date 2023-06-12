page 50034 "Posted Receipts List"
{
    CardPageID = "Receipt Card Posted";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Reciept - Payment Lines";
    SourceTableView = SORTING ("Doc No.")
                      ORDER(Ascending)
                      WHERE (Status = CONST (Released));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Doc No."; "Doc No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field(Description; Description)
                {
                }
                field(Name; Name)
                {
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                }
                field("Bal. Account Name"; "Bal. Account Name")
                {
                }
                field("Receiced From"; "Receiced From")
                {
                    Visible = true;
                }
                field("Account No."; "Account No.")
                {
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Entered By"; "Entered By")
                {
                }
            }
        }
    }

    actions
    {
    }
}

