report 50011 "Tenant Contract Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TenantContractDetails.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = WHERE ("Customer Types" = CONST (Tenants));
            PrintOnlyIfDetail = true;
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            dataitem("Rent Contract Line"; "Rent Contract Line")
            {
                DataItemLink = "Customer No." = FIELD ("No.");
                column(Rent_Contract_Line__Contract_No__; "Contract No.")
                {
                }
                column(Rent_Contract_Line__Starting_Date_; "Starting Date")
                {
                }
                column(Rent_Contract_Line__Expiration_Date_; "Expiration Date")
                {
                }
                column(Rent_Contract_Line__Resource_Price_; "Resource Price")
                {
                }
                column(Rent_Contract_Line_Description; Description)
                {
                }
                column(Rent_Contract_Line_Line_No; "Line No")
                {
                }
                column(Rent_Contract_Line_Customer_No_; "Customer No.")
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
}

