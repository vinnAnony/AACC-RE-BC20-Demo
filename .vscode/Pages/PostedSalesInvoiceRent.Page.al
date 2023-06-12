page 50011 "Posted Sales Invoice (Rent)"
{
    Caption = 'Posted Sales Invoice (Rent)';
    InsertAllowed = false;
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    SourceTableView = WHERE("Rent Invoice" = CONST(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    Editable = false;
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    Editable = false;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code/City';
                    Editable = false;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    Editable = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                }
                field("Order No."; "Order No.")
                {
                    Editable = false;
                }
                field("Pre-Assigned No."; "Pre-Assigned No.")
                {
                    Editable = false;
                }
                field("External Document No."; "External Document No.")
                {
                    Editable = false;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Editable = false;
                }
                // field("Parking Slots"; "Parking Slots")
                // {
                // }
                field("No. Printed"; "No. Printed")
                {
                    Editable = false;
                }
            }
            part(SalesInvLines; "Posted Sales Invoice Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Editable = false;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                    Editable = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    Editable = false;
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    Editable = false;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    Editable = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code/City';
                    Editable = false;
                }
                field("Bill-to City"; "Bill-to City")
                {
                    Editable = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Editable = false;
                }
                field("Due Date"; "Due Date")
                {
                    Editable = false;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    Editable = false;
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    Editable = false;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Editable = false;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; "Ship-to Code")
                {
                    Editable = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    Editable = false;
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                    Editable = false;
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                    Editable = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code/City';
                    Editable = false;
                }
                field("Ship-to City"; "Ship-to City")
                {
                    Editable = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    Editable = false;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Invoice Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.PrintRecords(TRUE);*/
                    Reset;
                    SetFilter("No.", xRec."No.");
                    REPORT.Run(50026, true, true, Rec);

                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    var
        SalesInvHeader: Record "Sales Invoice Header";
}

