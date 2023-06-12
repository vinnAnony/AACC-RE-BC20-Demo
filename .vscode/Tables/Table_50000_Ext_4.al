tableextension 50000 CurrencyExt extends Currency
{
    fields
    {
        field(50000; "Payroll Rounding Precision"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 0.01;
            NotBlank = true;
        }
        field(50001; "Payroll Rounding Direction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Nearest,Up,Down;
        }
    }

}