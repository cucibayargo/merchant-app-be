export interface ReportData {   
    [key: string]: string |number;
    date: string;
    total_transactions: number;
    total_revenue: number;
}

export interface ServiceData {
    service_name: string;
    service_id: string;
}