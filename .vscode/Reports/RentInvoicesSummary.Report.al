report 50012 "Rent Invoices Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RentInvoicesSummary.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Rent Invoices Summary';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") WHERE("Customer Types" = CONST(Tenants));
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.");
                RequestFilterFields = "Customer No.", "Document No.", "Document Type";
                column(CustomerNo_CustLedgerEntry; "Customer No.")
                {
                }
                column(PostingDate_CustLedgerEntry; "Posting Date")
                {
                }
                column(DocumentNo_CustLedgerEntry; "Document No.")
                {
                }
                column(DocumentType_CustLedgerEntry; "Document Type")
                {
                    OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                }
                column(FilterText; FilterText)
                {
                }
                column(Totalexclvat__; TotalExclVAT)
                {
                }
                column(Amount_DetailedCustLedgEntry; AmountCLE)
                {
                }
                dataitem("Sales Invoice Header"; "Sales Invoice Header")
                {
                    DataItemLink = "No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No.");
                    column(PropertyNo_SalesInvoiceHeader; "Sales Invoice Header"."Property No")
                    {
                    }
                    column(Amount_SalesInvoiceHeader; "Sales Invoice Header".Amount)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    "Cust. Ledger Entry".CalcFields(Amount);
                    AmountCLE := "Cust. Ledger Entry".Amount;

                    VATEnrty.SetRange("Document No.", "Document No.");
                    VATEnrty.SetFilter("Document Type", '%1', "Document Type");
                    if VATEnrty.Find('-') then
                        TotalExclVAT := -(VATEnrty.Base);
                end;

                trigger OnPreDataItem()
                begin

                    if DocumentType <> DocumentType::" " then
                        SetFilter("Document Type", '%1', DocumentType)
                    else
                        SetFilter("Document Type", '%1|%2', "Document Type"::"Credit Memo", "Document Type"::Invoice);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control100000002)
                {
                    ShowCaption = false;
                }
                field(DocTYpe; DocTYpe)
                {
                    Caption = 'Document Type';

                    trigger OnValidate()
                    begin
                        if DocTYpe = DocTYpe::" " then begin
                            DocumentType := DocumentType::" ";
                        end else
                            if DocTYpe = DocTYpe::"Credit Memo" then begin
                                DocumentType := DocumentType::"Credit Memo";
                            end else
                                DocumentType := DocumentType::Invoice;
                    end;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DocTYpe = DocTYpe::" " then begin
                DocumentType := DocumentType::" ";
            end else
                if DocTYpe = DocTYpe::"Credit Memo" then begin
                    DocumentType := DocumentType::"Credit Memo";
                end else
                    DocumentType := DocumentType::Invoice;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CompInfo.Get;
    end;

    trigger OnPreReport()
    begin
        FilterText := "Cust. Ledger Entry".GetFilters + ' ' + Format(DocumentType);
        FilterText := Cust.GetFilters + '' + Format(CustType);
    end;

    var
        Cust: Record Customer;
        CustName: Text[50];
        CompInfo: Record "Company Information";
        FilterText: Text[150];
        Rent_Invoices_SummaryCaptionLbl: Label 'Rent Invoices Summary';
        PageCaptionLbl: Label 'Page';
        Datefilter: Date;
        tenantfilter: Code[10];
        propertyblock: Code[20];
        salescrmemoheader: Record "Sales Cr.Memo Header";
        Customernumber: Code[10];
        postingdate: Date;
        "DocumentNo.": Code[10];
        custL: Record "Cust. Ledger Entry";
        custLD: Record "Detailed Cust. Ledg. Entry";
        Propertyno: Code[10];
        ResourceG: Record "Resource Group";
        DocTYpe: Option " ",Invoice,"Credit Memo";
        DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        VATEnrty: Record "VAT Entry";
        TotalExclVAT: Decimal;
        AmountCLE: Decimal;
        CustType: Option " ","AACC Members",Tenants,Guests;
}

