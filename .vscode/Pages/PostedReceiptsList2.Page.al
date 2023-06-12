page 50043 "Posted Receipts List 2"
{
    // 
    // removed received from since there is field description

    CardPageID = "Posted Receipt Header 2";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Receipts List';
    UsageCategory = Tasks;
    SourceTable = "Reciept - Payment Header";
    SourceTableView = SORTING("Doc No.")
                      ORDER(Ascending)
                      WHERE("Posted Receipt" = CONST(true));

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
                field("Receiced From"; "Receiced From")
                {
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

