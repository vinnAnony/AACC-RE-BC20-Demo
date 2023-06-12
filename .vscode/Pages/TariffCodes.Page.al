page 50020 "Tariff Codes"
{
    PageType = Card;
    SourceTable = "Tariff Codes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Tariff Rate"; "Tariff Rate")
                {
                }
                field("G/L Account"; "G/L Account")
                {
                }
                field("Tariff Type"; "Tariff Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}

