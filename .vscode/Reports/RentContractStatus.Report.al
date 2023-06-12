report 50021 "Rent Contract Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RentContractStatus.rdlc';

    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            column(ContractNo; "Rent Contract Header"."Contract No.")
            {
            }
            column(resourcesubtype; RentContractLine."Resource Sub Type")
            {
            }
            column(PropertyNo; "Rent Contract Header"."Property No")
            {
            }
            column(PropertyDescription; "Rent Contract Header"."Property Desc")
            {
            }
            column(TenantNo; "Rent Contract Header"."Customer No.")
            {
            }
            column(TenantName; Cust.Name)
            {
            }
            column(Status; "Rent Contract Header".Status)
            {
                OptionMembers = "< ",Signed,Amended,"Terminated>";
            }
            column(SignDate; "Rent Contract Header"."Sign Date")
            {
            }
            column(StartDate; "Rent Contract Header"."Starting Date")
            {
            }
            column(EndDate; "Rent Contract Header"."Expiration Date")
            {
            }
            column(ContractDuration; ContractDuration)
            {
            }
            column(RemainingPeriod; RemainingPeriod)
            {
            }
            column(Last__Invoiced_Date; "Rent Contract Header"."Last Invoice Date")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CustName := '';
                PropertDesc := '';
                ContractDuration := 0;
                RemainingPeriod := 0;
                // //MJ
                Resourcegrp.SetRange("No.");
                if Resourcegrp.Find('-') then begin
                    PropertDesc := Resourcegrp.Name;
                    // "Rent Contract Header".SETRANGE("Contract No.", "Contract No.");
                    // IF "Rent Contract Header".FIND('-') THEN BEGIN
                    //  PropertDesc :="Rent Contract Header"."Property Desc"
                end;
                //  //MJ end
                if Cust.Get("Customer No.") then
                    CustName := Cust.Name;

                if ("Starting Date" <> 0D) and ("Expiration Date" <> 0D) then begin
                    ContractDuration := "Expiration Date" - "Starting Date";

                    if "Expiration Date" > Today then
                        RemainingPeriod := "Expiration Date" - Today;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //MJ
                "Rent Contract Header".CalcFields("Property Desc");
                //MJ end
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CustName: Text[50];
        PropertDesc: Text[50];
        Cust: Record Customer;
        Prop: Record "Resource Group";
        ContractDuration: Integer;
        RemainingPeriod: Integer;
        RentContractLine: Record "Rent Contract Line";
        Resourcegrp: Record "Resource Group";
}

