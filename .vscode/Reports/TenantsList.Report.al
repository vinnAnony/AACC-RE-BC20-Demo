report 50004 "Tenants -List"
{
    // //mjk
    // i replaced the email field with contract No
    // i replaced the primary contact No. with Resource Grp. Occupied
    // //mjk end
    ApplicationArea = Basic, Suite;
    Caption = 'Tenants -List';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './TenantsList.rdlc';


    dataset
    {
        dataitem(Tenant; Customer)
        {
            DataItemTableView = SORTING("No.") WHERE("Customer Types" = CONST(Tenants));
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Tenant__No__; "No.")
            {
            }
            column(Tenant_Name; Name)
            {
            }
            column(ContractNO; Rentcontractline."Contract Type")
            {
            }
            column(CustomerPostingGroup_Tenant; Rentcontractline."Resource Sub Type")
            {
            }
            column(Tenant_Tenant_Balance; Tenant.Balance)
            {
            }
            column(CustomerCaption; CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Tenant__No__Caption; FieldCaption("No."))
            {
            }
            column(Tenant_NameCaption; FieldCaption(Name))
            {
            }
            column(Tenant__E_Mail_Caption; FieldCaption("E-Mail"))
            {
            }
            column(Tenant__Primary_Contact_No__Caption; FieldCaption("Primary Contact No."))
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Cn; rentcontractheader."Contract No.")
            {
            }
            column(ContractNo_Tenant; Tenant."Contract No.")
            {
            }
            column(ContractStatus_Tenant; Tenant."Contract Status")
            {
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

    var
        CustomerCaptionLbl: Label 'Customer';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        BalanceCaptionLbl: Label 'Balance';
        Rentcontractline: Record "Rent Contract Line";
        rentcontractheader: Record "Rent Contract Header";
        Res: Record Resource;
}

