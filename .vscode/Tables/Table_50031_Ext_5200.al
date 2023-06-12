tableextension 50031 EmployeeExt extends Employee
{
    fields
    {
        field(50000; "Leave Days Taken"; Decimal)
        {
            CalcFormula = Sum("Employee Absence"."Company Leave Qty" WHERE("Employee No." = FIELD("No."),
                                                                            "Company Leave" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Leave Days per Year"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Single," Married"," Widow"," Widower"," Divorced"," Celibate";
        }
        field(50005; "Hosp. Ins. Fund"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "PIN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Nationality; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; Salutation; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Send PaySlip Via Email"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'added by KTM 28/11/19';
        }
    }

}