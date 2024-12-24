export interface InvoiceDetails {
    user_id: string;
    amount: number;
    status: string;
    due_date: string;
    invoice_created_at: string;
    invoice_id: string;
    plan_name: string;
    plan_code: string;
    plan_duration: number;
    plan_price: number;
  }
  
  export interface setPlanInput {
    user_id: string;
    plan_code: string;
  }
  

export interface updateInvoiceInput {
  invoice_id: string;
  status: string;
}
