report 50009 "Release Property"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReleaseProperty.rdlc';

    dataset
    {
        dataitem("Rent Contract Header"; "Rent Contract Header")
        {
            DataItemTableView = SORTING ("Contract No.");
            dataitem("Rent Contract Line"; "Rent Contract Line")
            {
                DataItemLink = "Contract No." = FIELD ("Contract No.");
                RequestFilterFields = "Resource Code";

                trigger OnAfterGetRecord()
                begin
                    if "Resource Code" = '' then
                        Error('Please Specify the Property to release');


                    Res.Get("Resource Code");
                    Res."Under Contract" := false;
                    Res."Contract Code" := '';
                    Res."Date Released" := Today;
                    Res."Released By" := UserId;
                    Res."Release Comments" := 'Released';
                    Res.Modify;
                end;
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
        Res: Record Resource;
        Propcod: Code[10];
}

