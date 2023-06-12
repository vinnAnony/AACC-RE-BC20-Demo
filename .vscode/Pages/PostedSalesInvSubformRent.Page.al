page 50012 "Posted Sales Inv Subform(Rent)"
{
    AutoSplitKey = true;
    Caption = 'Posted Sales Inv Subform(Serv)';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                // field("No. of Units"; "No. of Units")
                // {
                // }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;
                }
                // field("No of months"; "No of months")
                // {
                // }
                // field("Total Amount"; "Total Amount")
                // {
                // }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50012. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #50012. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.FORM.*/
                        _ShowItemTrackingLines;

                    end;
                }
            }
        }
    }

    [Scope('Internal')]
    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;

    [Scope('Internal')]
    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;
}

