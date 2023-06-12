tableextension 50001 GlEntryExt extends "G/L Entry"
{
    fields
    {
        field(50000; "Deposit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Deposit,Refund';
            OptionMembers = " ",Deposit,Refund;
        }
        field(50001; "Property Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Customer Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Payroll Code Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,BasicSalary,Allowance,Benefit,Overtime,GrossPay,Loan,Deduction,Contribution,TaxablePay,Pension,"N.H.I.F",PAYE,TaxRelief,NetPay,Gratuity,WorkersCompensation,InsuranceRelief,HOSP,MortgageRelief,TaxExemption,PensionRelief,Advance,AdvanceRepayment,Others;
        }
        field(50004; "ITax Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,BasicPay,HouseAllowance,Transport,LeavePay,OverTime,DirectorsFee,LumpSumPay,OtherAllowances,PAYE';
            OptionMembers = " ",BasicPay,HouseAllowance,Transport,LeavePay,OverTime,DirectorsFee,LumpSumPay,OtherAllowances,PAYE;
        }
        field(50005; "Withholding Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingTax));
        }
        field(50006; "Withholding VAT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingVAT));
        }
        field(50007; Description2; Text[100])
        {
            FieldClass = Normal;
        }
    }

}