page 50013 Property
{
    DataCaptionFields = "Resource Group No.", Name;
    PageType = List;
    SourceTable = Resource;
    SourceTableView = SORTING ("No.")
                      WHERE (Type = CONST (Property));

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
                field("Sub Type"; "Resource Sub Type")
                {
                }
                field(Name; Name)
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field("Rental Space"; "Rental Space")
                {
                }
                field("Under Contract"; "Under Contract")
                {
                    Editable = false;
                }
                field("Contract Code"; "Contract Code")
                {
                    Editable = false;
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Total Price"; "Total Price")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Floor No."; "Floor No.")
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
        area(navigation)
        {
            group("Property Unit")
            {
                Caption = 'Property Unit';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Properties Card";
                    RunPageLink = "No." = FIELD ("No.");
                }
                group(Contract)
                {
                    Caption = 'Contract';
                    action(Action1000000029)
                    {
                        Caption = 'Card';
                        Image = EditLines;
                        RunObject = Page "Sales Invoice (Rent)";
                        RunPageLink = "No." = FIELD ("No.");
                    }
                }
                action("Ledger Entries")
                {
                    Caption = 'Ledger Entries';
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "Resource No." = FIELD ("No.");
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        resGrp: Record "Resource Group";
    begin
        Type := Type::Property;


        "Resource Group No." := GetFilter("Resource Group No.");
        resGrp.Get("Resource Group No.");
        "Service Charge" := resGrp."Service Charge";
        "Base Unit of Measure" := resGrp."Base Unit of Measure";
        "Gen. Prod. Posting Group" := resGrp."Gen. Prod. Posting Group";
        "Global Dimension 1 Code" := resGrp."Global Dimension 1 Code";
        "Property Types" := resGrp."Property Types";
    end;

    var
        resgrp: Record "Resource Group";
        ResUom: Record "Resource Unit of Measure";
}

