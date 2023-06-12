tableextension 50021 ResLedgerEntryExt extends "Res. Ledger Entry"
{
    fields
    {
        field(50000; "Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "No. Of Months"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

}