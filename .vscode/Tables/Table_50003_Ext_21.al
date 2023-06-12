tableextension 50003 CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50003; "Payroll Code Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",BasicSalary,Allowance,Benefit,Overtime,GrossPay,Loan,Deduction,Contribution,TaxablePay,Pension,"N.H.I.F",PAYE,TaxRelief,NetPay,Gratuity,WorkersCompensation,InsuranceRelief,HOSP,MortgageRelief,TaxExemption,PensionRelief,Others,Advance,AdvanceRepayment;
        }
    }

}