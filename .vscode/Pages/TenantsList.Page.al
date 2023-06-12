page 50018 "Tenants List"
{
    CardPageID = "Tenants Card";
    ApplicationArea = Basic, Suite;
    Caption = 'Tenants List';
    UsageCategory = Tasks;
    Editable = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = SORTING("No.")
                      WHERE("Customer Types" = CONST(Tenants));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }
}

