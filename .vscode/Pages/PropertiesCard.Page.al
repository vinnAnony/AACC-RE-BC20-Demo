page 50001 "Properties Card"
{
    Caption = 'Properties Card';
    PageType = Card;
    SourceTable = Resource;
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

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Name)
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field("Property Types"; "Property Types")
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Resource Group No."; "Resource Group No.")
                {
                    Caption = 'Property Block';
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Unit Price"; "Unit Price")
                {
                }
                field("Service Charge"; "Service Charge")
                {
                }
                field("Under Contract"; "Under Contract")
                {
                }
                field("Contract Code"; "Contract Code")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
            }
            group(Housing)
            {
                Caption = 'Housing';
                field("Rental Space"; "Rental Space")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Property")
            {
                Caption = '&Property';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Statistics";
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
                    RunPageLink = "Table Name" = CONST (Resource),
                                  "No." = FIELD ("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST (156),
                                  "No." = FIELD ("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    RunObject = Page "Resource Picture";
                    RunPageLink = "No." = FIELD ("No.");
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "Resource No." = FIELD ("No.");
                    RunPageView = SORTING ("Resource No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("E&xtended Texts")
                {
                    Caption = 'E&xtended Texts';
                    RunObject = Page "Extended Text";
                    RunPageLink = "Table Name" = CONST (Resource),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                }
                separator(Action34)
                {
                    Caption = '';
                }
                action("Units of Measure")
                {
                    Caption = 'Units of Measure';
                    RunObject = Page "Resource Units of Measure";
                    RunPageLink = "Resource No." = FIELD ("No.");
                }
                action("Service &Zones")
                {
                    Caption = 'Service &Zones';
                    RunObject = Page "Resource Service Zones";
                    RunPageLink = "Resource No." = FIELD ("No.");
                    Visible = false;
                }
                action("S&kills")
                {
                    Caption = 'S&kills';
                    RunObject = Page "Resource Skills";
                    RunPageLink = Type = CONST (Resource),
                                  "No." = FIELD ("No.");
                    Visible = false;
                }
                action("Resource L&ocations")
                {
                    Caption = 'Resource L&ocations';
                    RunObject = Page "Resource Locations";
                    RunPageLink = "Resource No." = FIELD ("No.");
                    RunPageView = SORTING ("Resource No.");
                    Visible = false;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Type := Type::Property;
    end;
}

