tableextension 50024 PaymentMethodExt extends "Payment Method"
{
    fields
    {
        field(50000; "Payment Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Cash,Cheque,"Direct Banking";
        }
    }

}