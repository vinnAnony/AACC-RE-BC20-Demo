tableextension 50023 GenJournalBatchExt extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; Narration; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Doc No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
    }

}