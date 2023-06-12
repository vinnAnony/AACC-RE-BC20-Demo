page 50004 "Property Groups"
{
    Caption = 'Resource Groups';
    PageType = List;
    SourceTable = "Resource Group";
    SourceTableView = SORTING ("No.")
                      WHERE (Type = CONST (Property));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Type; Type)
                {
                }
                field(Capacity; Capacity)
                {
                }
                field("Property Types"; "Property Types")
                {
                }
                field("Rental Space"; "Rental Space")
                {
                }
                field("Occupied Space"; "Occupied Space")
                {
                }
                field("Remaining Units"; "Remaining Units")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Res. &Group")
            {
                Caption = 'Res. &Group';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Res. Gr. Statistics";
                    RunPageLink = "No." = FIELD ("No."),
                                  "Date Filter" = FIELD ("Date Filter"),
                                  "Unit of Measure Filter" = FIELD ("Unit of Measure Filter"),
                                  "Chargeable Filter" = FIELD ("Chargeable Filter");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST ("Resource Group"),
                                  "No." = FIELD ("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST (152),
                                      "No." = FIELD ("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            ResGr: Record "Resource Group";
                        begin
                            /*CurrPage.SETSELECTIONFILTER(ResGr);
                            DefaultDimMultiple.SetMultiResGr(ResGr);
                            DefaultDimMultiple.RUNMODAL;  */

                        end;
                    }
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                action(Costs)
                {
                    Caption = 'Costs';
                    Image = ResourceCosts;
                    RunObject = Page "Resource Costs";
                    RunPageLink = Type = CONST ("Group(Resource)"),
                                  Code = FIELD ("No.");
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Resource Prices";
                    RunPageLink = Type = CONST ("Group(Resource)"),
                                  Code = FIELD ("No.");
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                action("Res. Group &Capacity")
                {
                    Caption = 'Res. Group &Capacity';
                    RunObject = Page "Res. Group Capacity";
                }
                action("Res. Group All&ocated per Job")
                {
                    Caption = 'Res. Group All&ocated per Job';
                    RunObject = Page "Res. Gr. Allocated per Job";
                    RunPageLink = "Resource Gr. Filter" = FIELD ("No.");
                }
                action("Res. Group Allocated per Service &Order")
                {
                    Caption = 'Res. Group Allocated per Service &Order';
                    RunObject = Page "Res. Gr. Alloc. per Serv Order";
                    // RunPageLink = Field157 = FIELD ("No.");
                }
                action("Res. Group Availa&bility")
                {
                    Caption = 'Res. Group Availa&bility';
                    RunObject = Page "Res. Group Availability";
                    RunPageLink = "No." = FIELD ("No."),
                                  "Unit of Measure Filter" = FIELD ("Unit of Measure Filter"),
                                  "Chargeable Filter" = FIELD ("Chargeable Filter");
                }
                separator(Action9)
                {
                }
                action("Job Budget")
                {
                    Caption = 'Job Budget';
                    // RunObject = Page Page212;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Type := Type::Property;
    end;
}

