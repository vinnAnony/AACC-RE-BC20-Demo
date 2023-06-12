tableextension 50012 GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Deposit Type"; Option)
        {
            OptionCaption = ' ,Deposit,Refund';
            OptionMembers = " ",Deposit,Refund;
        }
        field(50001; "Property Code"; Code[10])
        {
        }
        field(50002; "Customer Code"; Code[10])
        {
            TableRelation = Customer WHERE("Customer Types" = CONST(Tenants));
        }
        field(50003; "Shortcut Dimension 3 Code"; Code[20])
        {
        }
        field(50031; "Catering Levy Amount"; Decimal)
        {
            Editable = false;
        }
        field(50032; "Payroll Code Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,BasicSalary,Allowance,Benefit,Overtime,GrossPay,Loan,Deduction,Contribution,TaxablePay,Pension,"N.H.I.F",PAYE,TaxRelief,NetPay,Gratuity,WorkersCompensation,InsuranceRelief,HOSP,MortgageRelief,TaxExemption,PensionRelief,Advance,AdvanceRepayment,NSSF,PensionExcess,"Housing Fund",Others;
        }
        field(50033; "Withholding Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingTax));
        }
        field(50034; "Withholding Tax Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50035; "Withholding Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50036; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50037; "Withholding VAT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Codes".Code WHERE("Tariff Type" = CONST(WithholdingVAT));
        }
        field(50038; "Withholding VAT Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50039; "Withholding VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50040; "ITax Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,BasicPay,HouseAllowance,Transport,LeavePay,OverTime,DirectorsFee,LumpSumPay,OtherAllowances,PAYE';
            OptionMembers = " ",BasicPay,HouseAllowance,Transport,LeavePay,OverTime,DirectorsFee,LumpSumPay,OtherAllowances,PAYE;
        }
        field(50041; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Account Name"; Code[200])
        {
            Editable = false;
        }
        field(50043; "Description 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

}