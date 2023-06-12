tableextension 50011 GenJournalTemplateExt extends "Gen. Journal Template"
{
    fields
    {
        field(50000; "Journal Report ID"; Integer)
        {
            Caption = 'Journal Report ID';
            // TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
    }

}