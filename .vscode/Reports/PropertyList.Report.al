report 50014 "Property - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PropertyList.rdlc';
    Caption = 'Resource - List';

    dataset
    {
        dataitem(Resource; Resource)
        {
            DataItemTableView = SORTING ("No.") WHERE (Type = CONST (Property));
            RequestFilterFields = Type;
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
            column(Resource_TABLECAPTION__________ResFilter; Resource.TableCaption + ': ' + ResFilter)
            {
            }
            column(Resource__No__; "No.")
            {
            }
            column(Resource_Name; Name)
            {
            }
            column(Resource__Resource_Group_No__; "Resource Group No.")
            {
            }
            column(Resource__Last_Departure_Date_; "Last Departure Date")
            {
            }
            column(Resource__Contract_Code_; "Contract Code")
            {
            }
            column(Resource___ListCaption; Resource___ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Resource__No__Caption; FieldCaption("No."))
            {
            }
            column(Resource_NameCaption; FieldCaption(Name))
            {
            }
            column(Property_BlockCaption; Property_BlockCaptionLbl)
            {
            }
            column(Resource__Last_Departure_Date_Caption; FieldCaption("Last Departure Date"))
            {
            }
            column(Resource__Contract_Code_Caption; FieldCaption("Contract Code"))
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

    trigger OnPreReport()
    begin
        ResFilter := Resource.GetFilters;
    end;

    var
        ResFilter: Text[250];
        Resource___ListCaptionLbl: Label 'Resource - List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Property_BlockCaptionLbl: Label 'Property Block';
}

