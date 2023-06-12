page 50014 "Property List"
{
    CardPageID = "Properties Card";
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'Property List';
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = Resource;
    SourceTableView = SORTING("No.")
                      WHERE(Type = CONST(Property));

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
                field("Property Types"; "Property Types")
                {
                }
                field("Resource Group No."; "Resource Group No.")
                {
                    Caption = 'Property Block';
                }
                field("Contract Code"; "Contract Code")
                {
                }
                field("Under Contract"; "Under Contract")
                {
                    Editable = false;
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Service Charge"; "Service Charge")
                {
                }
                field("Rental Space"; "Rental Space")
                {
                }
                field("Current Tenant"; "Current Tenant")
                {
                }
                field("Floor No."; "Floor No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Property Unit")
            {
                Caption = 'Property Unit';
                action("Property Card")
                {
                    Caption = 'Property Card';
                    RunObject = Page "Properties Card";
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

