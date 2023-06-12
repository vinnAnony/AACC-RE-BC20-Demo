page 50006 "Rent Contracts Subform"
{
    // BV/20190415-AACC.D012-add no. of months to the contaract line.

    AutoSplitKey = true;
    Caption = 'Rent Contract Line';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Rent Contract Line";

    layout
    {
        area(content)
        {
            repeater(Control1102750000)
            {
                ShowCaption = false;
                field("Resource Code"; "Resource Code")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //RMM 29/09/2018
                        RentHdr.Reset;
                        RentHdr.SetRange(RentHdr."Contract No.", "Contract No.");
                        if RentHdr.Find('-') then begin
                            with Res do begin
                                Reset;
                                SetRange("Resource Group No.", RentHdr."Property No");
                                //  SETRANGE("Under Contract",FALSE);
                                if Find('-') then
                                    if PAGE.RunModal(0, Res) = ACTION::LookupOK then
                                        "Resource Code" := "No.";
                            end;
                        end;
                        if "Resource Code" <> '' then
                            Validate("Resource Code");

                        //ktm
                        CurrPage.Update
                    end;
                }
                field("Resource Sub Type"; "Resource Sub Type")
                {
                }
                field(Description; Description)
                {
                }
                field("Resource Price"; "Resource Price")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        "Amount per Month" := "No of Units" * "Resource Price" * "No. of Months";
                        "Amount per Period" := "No of Units" * "Resource Price";

                        //ktm
                        CurrPage.Update
                    end;
                }
                field("No of Units"; "No of Units")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        "Amount per Month" := "No of Units" * "No. of Months" * "Resource Price";
                        "Amount per Period" := "No of Units" * "Resource Price";


                        //ktm
                        CurrPage.Update
                    end;
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    Editable = true;
                }
                field("Amount per Period"; "Amount per Period")
                {
                    Caption = 'Amount per Month';

                    trigger OnValidate()
                    begin

                        //ktm
                        CurrPage.Update
                    end;
                }
                field("Floor No."; "Floor No.")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("No. of Months"; "No. of Months")
                {

                    trigger OnValidate()
                    begin

                        //ktm
                        CurrPage.Update
                    end;
                }
                field("Amount per Month"; "Amount per Month")
                {
                    Caption = 'Amount per Period';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //ktm
                        CurrPage.Update
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Prepaid := true;
    end;

    var
        RentHdr: Record "Rent Contract Header";
        Res: Record Resource;
}

