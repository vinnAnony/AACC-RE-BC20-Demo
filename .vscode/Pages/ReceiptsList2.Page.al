page 50040 "Receipts List 2"
{
    // 
    // removed received from since there is field description

    CardPageID = "Receipt Header 2";
    Editable = false;
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'Receipts List';
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = "Reciept - Payment Header";
    SourceTableView = SORTING("Doc No.")
                      ORDER(Ascending)
                      WHERE("Posted Receipt" = CONST(false));

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

