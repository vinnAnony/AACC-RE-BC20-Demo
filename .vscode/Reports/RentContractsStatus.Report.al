report 50013 "Rent Contracts -Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RentContractsStatus.rdlc';

    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            DataItemTableView = SORTING ("Contract No.");
            RequestFilterFields = "Contract No.", Status;
            column(Rent_Contract_Header__Contract_No__; "Contract No.")
            {
            }
            column(Rent_Contract_Header_Status; Status)
            {
            }
            column(Rent_Contract_Header_Name; Name)
            {
            }
            column(Rent_Contract_Header__Contract_No__Caption; FieldCaption("Contract No."))
            {
            }
            column(Rent_Contract_Header_StatusCaption; FieldCaption(Status))
            {
            }
            column(Rent_Contract_Line__Next_Invoice_Date_Caption; "Rent Contract Line".FieldCaption("Next Invoice Date"))
            {
            }
            column(Rent_Contract_Line__Last_Invoice_Date_Caption; "Rent Contract Line".FieldCaption("Last Invoice Date"))
            {
            }
            column(Rent_Contract_Line__Invoice_Period_Caption; "Rent Contract Line".FieldCaption("Invoice Period"))
            {
            }
            column(Rent_Contract_Line__Expiration_Date_Caption; "Rent Contract Line".FieldCaption("Expiration Date"))
            {
            }
            column(Rent_Contract_Line__Starting_Date_Caption; "Rent Contract Line".FieldCaption("Starting Date"))
            {
            }
            column(Rent_Contract_Line__Resource_Code_Caption; "Rent Contract Line".FieldCaption("Resource Code"))
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Rent_Contracts__StatusCaption; Rent_Contracts__StatusCaptionLbl)
            {
            }
            dataitem("Rent Contract Line"; "Rent Contract Line")
            {
                DataItemLink = "Contract No." = FIELD ("Contract No.");
                DataItemTableView = SORTING ("Contract No.", "Line No");
                column(Rent_Contract_Line__Resource_Code_; "Resource Code")
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
                column(Rent_Contract_Line__Last_Invoice_Date_; "Last Invoice Date")
                {
                }
                column(Rent_Contract_Line__Next_Invoice_Date_; "Next Invoice Date")
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

    var
        NameCaptionLbl: Label 'Name';
        Rent_Contracts__StatusCaptionLbl: Label 'Rent Contracts -Status';
}

