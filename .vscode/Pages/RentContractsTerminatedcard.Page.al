page 50038 "Rent Contracts Terminated card"
{
    // Rent.COPY(Rec);
    // Rent.SETRECFILTER;
    // REPORT.RUNMODAL(50000,TRUE,FALSE,Rent);

    PageType = Document;
    SourceTable = "Rent Contract Header";
    SourceTableView = SORTING("Contract No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Terminated));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Contract No."; "Contract No.")
                {
                    Editable = "Contract No.Editable";

                    trigger OnAssistEdit()
                    begin
                        // if AssistEdit(xRec) then
                        //     CurrPage.Update;
                    end;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(Description; Description)
                {
                    Editable = DescriptionEditable;
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    Caption = 'Post Code/City';
                }
                field(City; City)
                {
                }
                field("Property No"; "Property No")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Expiration Date"; "Expiration Date")
                {
                }
                field("Last Invoice Date"; "Last Invoice Date")
                {
                    Editable = false;
                }
                field("Next Invoice Date"; "Next Invoice Date")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                }
                field("Sign Date"; "Sign Date")
                {
                }
                field("Ammend Date"; "Ammend Date")
                {
                }
                field("No. of Unposted Invoices"; "No. of Unposted Invoices")
                {
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                }
                field("Change Status"; "Change Status")
                {
                }
                field("Contract Amount"; "Contract Amount")
                {
                }
            }
            part(RentContrLines; "Rent Contracts Subform")
            {
                SubPageLink = "Contract No." = FIELD("Contract No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Editable = "Bill-to Customer No.Editable";
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code/City';
                }
                field("Bill-to City"; "Bill-to City")
                {
                }
                field("Combine Invoices"; "Combine Invoices")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Editable = "Payment Terms CodeEditable";
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Sign Contract")
                {
                    Caption = 'Sign Contract';
                    Image = Signature;

                    trigger OnAction()
                    var
                        Rent: Record "Rent Contract Header";
                    begin
                        //Rent.COPY(Rec);
                        //Rent.SETRECFILTER;
                        PropMgmt.SignContract(Rec);
                    end;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action("Terminate Contract..")
                {
                    Caption = 'Terminate Contract..';

                    trigger OnAction()
                    begin
                        PropMgmt.TerminateContract(Rec, "Contract No.");
                    end;
                }
                separator(Action1000000055)
                {
                    Caption = '-';
                }
                action("Create Rent Invoice")
                {
                    Caption = 'Create Rent Invoice';

                    trigger OnAction()
                    var
                        Rent: Record "Rent Contract Header";
                    begin
                        /*Rent.COPY(Rec);
                        Rent.SETRECFILTER;
                        Rent.TESTFIELD(Status,Status::Signed);
                        Rent.TESTFIELD("Change Status","Change Status"::Locked);
                        REPORT.RUNMODAL(50000,TRUE,FALSE,Rent);*/
                        CalcFields("Contract Amount");
                        PropMgmt.CreateRentInvoice("Contract No.", "Next Invoice Date", false, "Contract Amount", "Starting Date");

                    end;
                }
                action("Release Property..")
                {
                    Caption = 'Release Property..';
                    Visible = false;

                    trigger OnAction()
                    var
                        Rent: Record "Rent Contract Header";
                    begin
                        Rent.Copy(Rec);
                        Rent.SetRecFilter;
                        // REPORT.RunModal(REPORT::"Release Property", true, false, Rent);
                    end;
                }
                separator("=")
                {
                    Caption = '=';
                }
                action("Lock Contract")
                {
                    Caption = 'Lock Contract';

                    trigger OnAction()
                    var
                        Rent: Record "Rent Contract Header";
                    begin
                        PropMgmt.Lock(Rec, "Contract No.");
                        CurrPage.Update;
                    end;
                }
                action("Open Contract")
                {
                    Caption = 'Open Contract';

                    trigger OnAction()
                    var
                        Rent: Record "Rent Contract Header";
                    begin
                        //RMM
                        with UserSetup do begin
                            if Get(UserId) then
                                if not "Allow Reopen Rent Contract" then
                                    Error(Text001)
                                else
                                    Error(Text001);
                        end;

                        PropMgmt.Open(Rec, "Contract No.");
                        CurrPage.Update;
                    end;
                }
            }
            action("&Print..")
            {
                Caption = '&Print..';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Rent: Record "Rent Contract Header";
                begin
                    Rent.Copy(Rec);
                    Rent.SetRecFilter;
                    REPORT.RunModal(50011, true, false, Rent);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Bill-to Customer No.Editable" := true;
        "Payment Terms CodeEditable" := true;
        ShortcutDimension1CodeEditable := true;
        "Customer No.Editable" := true;
        DescriptionEditable := true;
        "Contract No.Editable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        Resources: Record Resource;
        PropMgmt: Codeunit "Property Management";
        [InDataSet]
        "Contract No.Editable": Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        "Customer No.Editable": Boolean;
        [InDataSet]
        ShortcutDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment Terms CodeEditable": Boolean;
        [InDataSet]
        "Bill-to Customer No.Editable": Boolean;
        TestDate: Date;
        NoOfMnth: Integer;
        UserSetup: Record "User Setup";
        Text001: Label 'You are not allowed to open Rent Contracts. Please contact your System Administrator for permissions.';

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if "Change Status" = "Change Status"::Locked then begin
            "Contract No.Editable" := false;
            DescriptionEditable := false;
            "Customer No.Editable" := false;
            ShortcutDimension1CodeEditable := false;
            "Payment Terms CodeEditable" := false;
            "Bill-to Customer No.Editable" := false
        end
        else begin
            "Contract No.Editable" := true;
            DescriptionEditable := true;
            "Customer No.Editable" := true;
            ShortcutDimension1CodeEditable := true;
            "Payment Terms CodeEditable" := true;
            "Bill-to Customer No.Editable" := true;
        end;
    end;
}

