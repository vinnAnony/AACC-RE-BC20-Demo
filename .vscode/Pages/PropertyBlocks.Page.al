page 50009 "Property Blocks"
{
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Resource Group";
    SourceTableView = SORTING ("No.")
                      WHERE (Type = CONST (Property));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field("L/R No."; "L/R No.")
                {
                }
            }
            group(Housing)
            {
                Caption = 'Housing';
                field("Rental Space"; "Rental Space")
                {

                    trigger OnValidate()
                    begin
                        //ktm
                        //TESTFIELD("Gen. Prod. Posting Group")
                        Modify;
                        //ktm end
                    end;
                }
                field("Subdivided Space"; "Subdivided Space")
                {
                    Editable = false;
                }
                field("Occupied Space"; "Occupied Space")
                {
                    Caption = 'Occupied Space';
                }
                field("Remaining Space"; "Rental Space" - "Occupied Space")
                {
                }
                field("Parking Space"; "Parking Space")
                {

                    trigger OnValidate()
                    begin
                        //ktm
                        Modify;
                        //ktm end
                    end;
                }
                field("Subdivided Parking"; "Subdivided Parking")
                {
                    Editable = false;
                }
                field("Occupied Parking"; "Occupied Parking")
                {
                }
                field("Remaining Parking"; "Parking Space" - "Occupied Parking")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Property &Block")
            {
                Caption = 'Property &Block';
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
                            CurrPage.SetSelectionFilter(ResGr);
                            /*DefaultDimMultiple.SetMultiResGr(ResGr);
                            DefaultDimMultiple.RUNMODAL;          */

                        end;
                    }
                }
                separator("=")
                {
                    Caption = '=';
                }
                action("Property Units")
                {
                    Caption = 'Property Units';
                    RunObject = Page Property;
                    RunPageLink = "Resource Group No." = FIELD ("No.");
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
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        TestField("Occupied Space", 0);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::Property;
    end;
}

