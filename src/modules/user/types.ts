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
    token?: string;
    withReferralPoint?: boolean
  }
  

export interface updateInvoiceInput {
  invoice_id: string;
  status: string;
}

export interface verifyInvoiceResponse {
  name: string
  user_id: string
  invoice_id: string
  status: string
  amount: number
  plan: string
  valid: boolean
}

export interface getInvoiceResponse {
  invoice: string
  token: string
  user_id: string
  invoice_id: string
  amount: number
  plan_id: string
}

export interface CreateInvoiceResponse {
  invoice_id: string;
  status: string;
  end_date: string;
}

export type OfflineUser = {
  id: string;
  name: string;
  email: string;
  phone_number: string;
  device_id: string;
  device_model: string;
};