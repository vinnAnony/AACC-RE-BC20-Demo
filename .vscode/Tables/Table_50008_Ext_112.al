tableextension 50008 SalesInvoiceHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Rent Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Vega-NCM -To Identify documents created from Rent Contracts';
        }
        field(50001; "Member Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Guest Hse. Cat"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Room,Laundry,Conference,Restaurant;
        }
        field(50021; "Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Main,Extra;

            trigger OnValidate()
            begin

                // if "Bill Type" <> 0 then begin
                //     if "Bill Type" = "Bill Type"::Extra then begin
                //         if guest.Get("Sell-to Customer No.") then begin
                //             Package := Package::No;
                //             if guest."Extra Bills Account" <> '' then
                //                 Validate("Bill-to Customer No.", guest."Extra Bills Account")
                //             else
                //                 Error('Specify Customer Extra Account');
                //         end;
                //     end
                //     else begin
                // if "Sell-to Customer No." <> '' then begin
                //     if guest.Get("Sell-to Customer No.") then begin
                //         if guest."Bill-to Customer No." <> '' then begin

                //             Validate("Bill-to Customer No.", guest."Bill-to Customer No.");
                //             Commit;
                //         end
                //         else
                //             Error('Specify Customer MAIN Account');
                //     end
                //     else
                //         Error('Customer %1 does not exist', "Sell-to Customer No.");
                // end
                // else
                //     Error('Specify Sell to Customer Number');

                //     end;
                // end;
            end;
        }
        field(50022; "Order Receiver"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; Package; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;

            trigger OnValidate()
            var
                PAckageSetUp: Record "Resources Setup";
            begin
                if Package = Package::Yes then begin
                    if PAckageSetUp.Get then begin
                        Validate("Bill-to Customer No.", PAckageSetUp."Package Acc.");
                        "Bill Type" := "Bill Type"::Main;
                    end
                    else
                        Error('Please Specify the Package Account');
                end;
            end;
        }
        field(50024; "Served BY"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Meal Served"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Apply Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50031; "Catering Levy Amount"; Decimal)
        {
            // CalcFormula = Sum("Sales Line"."Catering Levy Amount" WHERE("Document Type" = FIELD("Document Type"),
            //                                                              "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Prices incl. VAT and Levy"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //When Levy always no VAT in prices
                // if SalesHeader."Prices incl. VAT and Levy" then
                //     SalesHeader."Prices Including VAT" := false;
                //ELSE
                //  SalesHeader."Prices Including VAT" := FALSE;
            end;
        }
        field(50033; "VAT Calc"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcFields("Amount Including VAT", Amount);
                // SalesHeader."VAT Calc" := SalesHeader."Amount Including VAT" - SalesHeader.Amount;
                Validate("Adjust Levy amount");
            end;
        }
        field(50034; "Total Entered"; Decimal)
        {
            // CalcFormula = Sum("Sales Line"."Total Line Entered" WHERE("Document Type" = FIELD("Document Type"),
            //                                                            "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50035; "Adjust Levy amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // CalcFields("Total Entered", "Amount Including VAT", Amount, "Catering Levy Amount");
                // if ("Total Entered" <> 0) and (Amount <> 0) then begin
                //     if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then begin
                //         "Adjust Levy amount" := "Total Entered" - "Amount Including VAT";
                //     end
                //     else begin
                //         "Adjust Levy amount" := "Total Entered" - Amount - "VAT Calc";
                //     end;
                // end
                // else
                //     "Adjust Levy amount" := 0;
                // SalesSetup.Get;

                // if (Abs("Catering Levy Amount" - "Adjust Levy amount") > SalesSetup."Acceptable adjust") and
                //    (Status = Status::Released)
                // then begin
                //     "Adjust Levy amount" := "Catering Levy Amount";
                // end;
            end;
        }
        field(50036; "Contract No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50037; "Property No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50038; "Invoice Period"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Tenant Invoicing Periods"."Starting Date";
        }
        field(50039; "General Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "No. of Months"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Amount Per Period"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Total Inclusive VAT"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Unit Price lcy" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50043; "Total Exclusive VAT"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Total Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "Period Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}