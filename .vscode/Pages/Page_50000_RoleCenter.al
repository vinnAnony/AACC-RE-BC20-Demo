pageextension 50000 RoleCenter extends "Business Manager Role Center"
{
    actions
    {
        addlast(sections)
        {
            group("Real Estate")
            {
                group("Property & Contracts")
                {
                    action("Tenants List")
                    {
                        ApplicationArea = All;
                        RunObject = page "Tenants List";
                    }
                    action("Property List")
                    {
                        ApplicationArea = All;
                        RunObject = page "Property List";
                    }
                    action("Rent Contracts List")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rent Contracts List";
                    }
                    action("Rent Contracts Terminated List")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rent Contracts Terminated List";
                    }
                }
                group("Order Processing")
                {
                    action("Rent Invoice List")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rent Invoice List";
                    }
                }
                group("Reporting")
                {
                    action("Tenants -List")
                    {
                        ApplicationArea = All;
                        RunObject = report "Tenants -List";
                    }
                    action("Customer - Summary Aging")
                    {
                        ApplicationArea = All;
                        RunObject = report "Customer - Summary Aging";
                    }
                    action("Tenants Contracts")
                    {
                        ApplicationArea = All;
                        RunObject = report "Tenants Contracts";
                    }
                    action("Rent Invoices Summary")
                    {
                        ApplicationArea = All;
                        RunObject = report "Rent Invoices Summary";
                    }
                    action("Occupancy Rate")
                    {
                        ApplicationArea = All;
                        RunObject = report "Occupancy Rate";
                    }
                }
                group("RE -Setup")
                {
                    action("Real Estate Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Resources Setup";
                    }
                    action("Prices")
                    {
                        ApplicationArea = All;
                        RunObject = page "Resource Prices";
                    }
                    action("Tenant Invocing Periods")
                    {
                        ApplicationArea = All;
                        RunObject = page "Tenant Invocing Periods";
                    }
                }
            }
            group("Payroll")
            {
                action("Payroll Journal")
                {
                    ApplicationArea = All;
                    RunObject = page "General Journal";
                }
            }
        }

        addlast("Cash Management")
        {
            group("Payment Voucher")
            {
                action("Payment Voucher List")
                {
                    ApplicationArea = All;
                    RunObject = page "Payment Voucher List";
                }
                action("Payment Voucher Posting List")
                {
                    ApplicationArea = All;
                    RunObject = page "Payment Voucher Posting List";
                }
                action("Payment Voucher Posted List")
                {
                    ApplicationArea = All;
                    RunObject = page "Payment Voucher Posted List";
                }
            }
            group("Receipts")
            {
                action("Receipts List")
                {
                    ApplicationArea = All;
                    RunObject = page "Receipts List 2";
                }
                action("Posted Receipts List")
                {
                    ApplicationArea = All;
                    RunObject = page "Posted Receipts List 2";
                }
            }
            group("ITax Teports")
            {
                action("VAT iTax")
                {
                    ApplicationArea = All;
                    RunObject = report "VAT ITax";
                }
                action("Withholding VAT iTax Report")
                {
                    ApplicationArea = All;
                    RunObject = report "WVAT ITax";
                }
                action("Withholding Tax iTax")
                {
                    ApplicationArea = All;
                    RunObject = report "WTax ITax";
                }
            }
        }
    }
}