tableextension 50033 EmployeeAbsenceExt extends "Employee Absence"
{
    fields
    {
        field(50000; "Company Leave"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Company Leave Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
    }

}