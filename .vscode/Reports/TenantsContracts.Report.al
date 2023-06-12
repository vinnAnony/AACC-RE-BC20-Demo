report 50002 "Tenants Contracts"
{
    // //MJ 20191025
    // set property no. filters for active contracts
    DefaultLayout = RDLC;
    RDLCLayout = './TenantsContracts.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Tenants Contracts';
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = true;

    dataset
    {
        dataitem("Rent Contract Line"; "Rent Contract Line")
        {
            RequestFilterHeading = '';
            column(Rent_Contract_Line__Customer_No__; "Customer No.")
            {
            }
            column(CustName; CustName)
            {
            }
            column(Rent_Contract_Line__Contract_No__; "Contract No.")
            {
            }
            column(Rent_Contract_Line__Resource_Code_; "Resource Code")
            {
            }
            column(Rent_Contract_Line_Description; Description)
            {
            }
            column(startdate; StartingDate)
            {
            }
            column(lastinvoicedate; LastInvDate)
            {
            }
            column(Rent_Contract_Line__Invoice_Period_; "Invoice Period")
            {
                OptionCaption = ' Quarter,Month,Two Months,Half Year,Year,None';
                OptionMembers = Quarter,Month,"Two Months","Half Year",Year,"None";
            }
            column(Rent_Contract_Line__Amount_per_Period_; "Amount per Period")
            {
            }
            column(Rent_Contract_Line__No_of_Units_; "No of Units")
            {
            }
            column(Rent_Contract_Line__Resource_Price_; "Resource Price")
            {
            }
            column(Rent_Contract_Line__Service_Charge_; "Service Charge")
            {
            }
            column(expirationdate; ExpirationDate)
            {
            }
            column(AmountperPeriod_RentContractLine; "Rent Contract Line"."Amount per Period")
            {
            }
            column(Rent_Contract_Line__Resource_Code_Caption; FieldCaption("Resource Code"))
            {
            }
            column(Rent_Contract_Line_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Rent_Contract_Line__Starting_Date_Caption; FieldCaption("Starting Date"))
            {
            }
            column(Rent_Contract_Line__Invoice_Period_Caption; FieldCaption("Invoice Period"))
            {
            }
            column(Rent_Contract_Line__Amount_per_Period_Caption; FieldCaption("Amount per Period"))
            {
            }
            column(Rent_Contract_Line__No_of_Units_Caption; FieldCaption("No of Units"))
            {
            }
            column(Rent_Contract_Line__Resource_Price_Caption; FieldCaption("Resource Price"))
            {
            }
            column(Rent_Contract_Line__Service_Charge_Caption; FieldCaption("Service Charge"))
            {
            }
            column(Rent_Contract_Line_Line_No; "Line No")
            {
            }
            column(StartingDate_RentContractLine; "Rent Contract Line"."Starting Date")
            {
            }
            column(ResourceSubType; "Rent Contract Line"."Resource Sub Type")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("Rent Contract Line"."Customer No.") then
                    CustName := Cust.Name;


                //MJ 10/23/19
                Rentcontractheader.SetRange("Contract No.", "Contract No.");
                if Rentcontractheader.Find('-') then begin
                    StartingDate := Rentcontractheader."Starting Date";
                    LastInvDate := Rentcontractheader."Last Invoice Date";
                    ExpirationDate := Rentcontractheader."Expiration Date";
                end;
                //MJ end
            end;

            trigger OnPreDataItem()
            begin
                //MJ
                "Rent Contract Line".CalcFields("Property No.", Status);
                "Rent Contract Line".SetFilter("Property No.", PropertyBlock);
                "Rent Contract Line".SetFilter(Status, '<>%1', Status::Terminated);
                //MJ end
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        ShowFilter = true;

        layout
        {
            area(content)
            {
                group("main group")
                {
                    Enabled = false;
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    Visible = false;
                }
                field("Property Block"; PropertyBlock)
                {
                    TableRelation = "Resource Group";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Cust: Record Customer;
        CustName: Text[30];
        Rentcontractheader: Record "Rent Contract Header";
        PropertyBlock: Code[250];
        resgroup: Record "Resource Group";
        StartingDate: Date;
        LastInvDate: Date;
        ExpirationDate: Date;
}

