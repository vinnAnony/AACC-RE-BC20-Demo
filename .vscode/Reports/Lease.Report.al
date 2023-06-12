report 50010 Lease
{
    DefaultLayout = RDLC;
    RDLCLayout = './Lease.rdlc';

    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            RequestFilterFields = "Contract No.", Status;
            column(Rent_Contract_Header__Customer_No__; "Customer No.")
            {
            }
            column(Rent_Contract_Header_Name; Name)
            {
            }
            column(Rent_Contract_Header_Address; Address)
            {
            }
            column(Rent_Contract_Header__Post_Code_; "Post Code")
            {
            }
            column(Rent_Contract_Header_City; City)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(CompInfo__Post_Code_; CompInfo."Post Code")
            {
            }
            column(CompInfo_City; CompInfo.City)
            {
            }
            column(CompInfo__Address_2_; CompInfo."Address 2")
            {
            }
            column(CompInfo_Address; CompInfo.Address)
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(Rent_Contract_Header__Contract_No__; "Contract No.")
            {
            }
            column(Rent_Contract_Header_Status; Status)
            {
            }
            column(Rent_Contract_Header__Sign_Date_; "Sign Date")
            {
            }
            column(CompInfo__Phone_No__; CompInfo."Phone No.")
            {
            }
            column(Tenant_No_Caption; Tenant_No_CaptionLbl)
            {
            }
            column(Rent_Contract_Header_NameCaption; FieldCaption(Name))
            {
            }
            column(Rent_Contract_Header_AddressCaption; FieldCaption(Address))
            {
            }
            column(Rent_Contract_Header__Post_Code_Caption; FieldCaption("Post Code"))
            {
            }
            column(Rent_Contract_Header_CityCaption; FieldCaption(City))
            {
            }
            column(Lease_AgreementCaption; Lease_AgreementCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(Rent_Contract_Header__Contract_No__Caption; FieldCaption("Contract No."))
            {
            }
            column(Rent_Contract_Header_StatusCaption; FieldCaption(Status))
            {
            }
            column(Rent_Contract_Header__Sign_Date_Caption; FieldCaption("Sign Date"))
            {
            }
            column(Phone_No_Caption; Phone_No_CaptionLbl)
            {
            }
            dataitem("Rent Contract Line"; "Rent Contract Line")
            {
                DataItemLink = "Contract No." = FIELD ("Contract No.");
                DataItemTableView = SORTING ("Contract No.", "Contract Type");
                column(Rent_Contract_Line__Resource_Code_; "Resource Code")
                {
                }
                column(Rent_Contract_Line_Description; Description)
                {
                }
                column(Rent_Contract_Line__Starting_Date_; "Starting Date")
                {
                }
                column(Rent_Contract_Line__Expiration_Date_; "Expiration Date")
                {
                }
                column(Rent_Contract_Line__Invoice_Period_; "Invoice Period")
                {
                }
                column(Rent_Contract_Line__Amount_per_Period_; "Amount per Period")
                {
                }
                column(Rent_Contract_Line__Resource_Price_; "Resource Price")
                {
                }
                column(Rent_Contract_Line__Service_Charge_; "Service Charge")
                {
                }
                column(Rent_Contract_Line__No_of_Units_; "No of Units")
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
                column(Rent_Contract_Line__Expiration_Date_Caption; FieldCaption("Expiration Date"))
                {
                }
                column(Rent_Contract_Line__Invoice_Period_Caption; FieldCaption("Invoice Period"))
                {
                }
                column(Rent_Contract_Line__Amount_per_Period_Caption; FieldCaption("Amount per Period"))
                {
                }
                column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                {
                }
                column(Rent_Contract_Line__Service_Charge_Caption; FieldCaption("Service Charge"))
                {
                }
                column(Rent_Contract_Line__No_of_Units_Caption; FieldCaption("No of Units"))
                {
                }
                column(Rent_Contract_Line_Contract_No_; "Contract No.")
                {
                }
                column(Rent_Contract_Line_Line_No; "Line No")
                {
                }
            }
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

    trigger OnPreReport()
    begin
        CompInfo.Get;
    end;

    var
        CompInfo: Record "Company Information";
        Tenant_No_CaptionLbl: Label 'Tenant No.';
        Lease_AgreementCaptionLbl: Label 'Lease Agreement';
        PageCaptionLbl: Label 'Page';
        Phone_No_CaptionLbl: Label 'Phone No.';
        Unit_PriceCaptionLbl: Label 'Unit Price';
}

