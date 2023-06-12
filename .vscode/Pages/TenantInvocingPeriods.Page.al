page 50022 "Tenant Invocing Periods"
{
    PageType = List;
    SourceTable = "Tenant Invoicing Periods";
    ApplicationArea = Basic, Suite;
    Caption = 'Tenant Invocing Periods';
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Starting Date"; "Starting Date")
                {
                }
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Create Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Create Period';
                Ellipsis = true;
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                // RunObject = Report "Create Invoice Periods";
                ToolTip = 'Open a new tenant invoicing periods.';
            }
        }
    }
}

