report 50007 "Property/Propert Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PropertyPropertUnits.rdlc';

    dataset
    {
        dataitem("Resource Group"; "Resource Group")
        {
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(Resource_Group__No__; "No.")
            {
            }
            column(No_ResourceGroup; "Resource Group"."No.")
            {
            }
            column(Resource_Group_Name; Name)
            {
            }
            column(Resource_Group__L_R_No__; "L/R No.")
            {
            }
            column(Resource_Group__Rental_Space_; "Rental Space")
            {
            }
            column(Resource_Group__L_R_No___Control1000000008; "L/R No.")
            {
            }
            column(Resource_Group__Service_Charge_; "Service Charge")
            {
            }
            column(Property_NoCaption; Property_NoCaptionLbl)
            {
            }
            column(Resource_Group_NameCaption; FieldCaption(Name))
            {
            }
            column(Resource_Group__L_R_No__Caption; FieldCaption("L/R No."))
            {
            }
            column(Resource_Group__Rental_Space_Caption; FieldCaption("Rental Space"))
            {
            }
            column(Resource_Group__L_R_No___Control1000000008Caption; FieldCaption("L/R No."))
            {
            }
            column(Resource_Group__Service_Charge_Caption; FieldCaption("Service Charge"))
            {
            }
            column(Unit_PriceCaption; Unit_PriceCaptionLbl)
            {
            }
            column(Property_Blocks_Units_DistributionCaption; Property_Blocks_Units_DistributionCaptionLbl)
            {
            }
            column(Contract_CodeCaption; Contract_CodeCaptionLbl)
            {
            }
            dataitem(Resource; Resource)
            {
                DataItemLink = "Resource Group No." = FIELD ("No.");
                column(Resource__No__; "No.")
                {
                }
                column(Resource_Name; Name)
                {
                }
                column(Resource__Contract_Code_; "Contract Code")
                {
                }
                column(Resource__Rental_Space_; "Rental Space")
                {
                }
                column(Resource__Service_Charge_; "Service Charge")
                {
                }
                column(Resource__Unit_Price_; "Unit Price")
                {
                }
                column(ResourceGroupNo_Resource; Resource."Resource Group No.")
                {
                }
                column(CurrentTenant_Resource; Resource."Current Tenant")
                {
                }
                column(PropertyTypes_Resource; Resource."Property Types")
                {
                }
                column(Resource_Sub_type; "Resource Sub Type")
                {
                }
                column(PropertyNo; RentContractLine."Property No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    propertytypesInt := propertytypesInt;
                    if propertytypesInt <> 3 then
                        SetRange("Property Types", propertytypesInt);

                    ResourceSubtypeInt := ResourceSubtypeInt;
                    if ResourceSubtypeInt <> 3 then
                        SetRange("Resource Sub Type", ResourceSubtypeInt);
                end;

                trigger OnPreDataItem()
                begin
                    // //MJ sets the filter
                    //
                    //
                    // ResourceSubtypeText := FORMAT(Resourcesubtype,0,2);
                    // EVALUATE(ResourceSubtypeInt, ResourceSubtypeText);
                    // ResourceSubtypeInt := ResourceSubtypeInt;
                    //
                    // //SETFILTER("Resource Group No.",PropertyBlock);
                    // SETRANGE("Resource Sub Type", ResourceSubtypeInt);
                    //
                    // //MJ end
                end;
            }

            trigger OnPreDataItem()
            begin
                if PropertyBlock <> '' then
                    SetFilter("No.", PropertyBlock);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Property Types"; propertytypes2)
                {
                    Editable = false;
                    Enabled = false;
                    OptionCaption = ' ,Rental Space,Parking,Room';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if Resourcesubtype = Resourcesubtype::Parking then begin
                            ResourceSubtypeInt := 0;
                        end else
                            if propertytypes2 = Resourcesubtype::"Rental Space" then begin
                                ResourceSubtypeInt := 1;
                            end else
                                if propertytypes2 = Resourcesubtype::"Service Charge" then begin
                                    ResourceSubtypeInt := 2;
                                end else
                                    ResourceSubtypeInt := 3;
                    end;
                }
                field("Property Block"; PropertyBlock)
                {
                    Editable = false;
                    Enabled = false;
                    TableRelation = "Resource Group";
                    Visible = false;
                }
                field("Resource Sub Type"; Resourcesubtype)
                {
                    Editable = false;
                    Enabled = false;
                    OptionCaption = ' ,Rental Space,Parking,Service Charge';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if propertytypes2 = propertytypes2::Parking then begin
                            propertytypesInt := 0;//propertytypes::Parking;
                        end else
                            if propertytypes2 = propertytypes2::"Rental Space" then begin
                                propertytypesInt := 1;//propertytypes::"Rental Space";
                            end else
                                if propertytypes2 = propertytypes2::Room then begin
                                    propertytypesInt := 2;//propertytypes::Room;
                                end else
                                    propertytypesInt := 3;
                    end;
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            propertytypesInt := 3;
            ResourceSubtypeInt := 3;
        end;
    }

    labels
    {
    }

    var
        Property_NoCaptionLbl: Label 'Property No';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Property_Blocks_Units_DistributionCaptionLbl: Label 'Property Blocks/Units Distribution';
        Contract_CodeCaptionLbl: Label 'Contract Code';
        Resourcesubtype: Option " ","Rental Space",Parking,"Service Charge";
        propertytypes: Option "Rental Space",Parking,Room;
        propertytypes2: Option " ","Rental Space",Parking,Room;
        RentContractLine: Record "Rent Contract Line";
        PropertyBlock: Code[250];
        ResourceSubtypeInt: Integer;
        ResourceSubtypeText: Text;
        propertytypesInt: Integer;
        propertytypesText: Text;
}

