page 50036 "Rent Contracts List"
{
    CardPageID = "Rent Contracts";
    Editable = false;
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'Rent Contracts List';
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = "Rent Contract Header";
    SourceTableView = SORTING("Contract No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(<> Terminated));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract No."; "Contract No.")
                {
                }
                field("Contract Type"; "Contract Type")
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
                field("Contact Name"; "Contact Name")
                {
                }
                field("Property No."; "Property No.")
                {
                }
                field("Next Invoice Period"; "Next Invoice Period")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field(Comment; Comment)
                {
                }
                field("Sign Date"; "Sign Date")
                {
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                }
                field("Property No"; "Property No")
                {
                }
                field("Parking Slots"; "Parking Slots")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Expiration Date"; "Expiration Date")
                {
                }
                field("Last Invoice Date"; "Last Invoice Date")
                {
                }
                field("Contract Amount"; "Contract Amount")
                {
                }
                field("Next Invoice Date"; "Next Invoice Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

