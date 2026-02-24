import { Workbook } from 'exceljs';
import { ReportData, ServiceData } from './types';
import pool from '../../database/postgres';
import axios from 'axios';
import { getUserDetails } from '../user/controller';
import { format } from 'date-fns';
import { id } from 'date-fns/locale';

export async function generateReport(start_date: string, end_date: string, merchant_id: string): Promise<{filename: string, file: Buffer}> {
    const workbook = new Workbook();
    const worksheet = workbook.addWorksheet('Report', {
        properties: { tabColor: { argb: '1E90FF' } }
    });
    worksheet.views = [{ showGridLines: false }];

    const merchantDetail = await getUserDetails(merchant_id);
    const serviceList = await getServiceList(start_date, end_date, merchant_id);

  // Add logo
  if (merchantDetail?.logo) {
    const imageResponse = await axios.get(merchantDetail.logo, { responseType: 'arraybuffer' });
    const imageId = workbook.addImage({ buffer: imageResponse.data, extension: 'png' });
    worksheet.addImage(imageId, 'A1:B4');
    worksheet.addRow([]);
  }

    // Add title
    worksheet.mergeCells(`A6:${String.fromCharCode(65 + serviceList.length + 2)}6`);
    const titleCell = worksheet.getCell('A6');
    titleCell.value = `Laporan dari tanggal ${format(start_date, 'dd-MM-yyyy', { locale: id })} sampai ${format(end_date, 'dd-MM-yyyy', { locale: id })}`;;
    titleCell.font = { bold: true, size: 16 };
    titleCell.alignment = { vertical: 'middle', horizontal: 'center' };
    worksheet.mergeCells(`A7:${String.fromCharCode(65 + serviceList.length + 2)}7`);
    const merchantTitle = worksheet.getCell('A7');
    merchantTitle.value = merchantDetail?.name;
    merchantTitle.font = { bold: true, size: 16 };
    merchantTitle.alignment = { vertical: 'middle', horizontal: 'center' };

    worksheet.addRow([]);
    worksheet.addRow([]);

    // Get services
    const headers: string[] = ['Tanggal', ...serviceList.map(s => s.service_name), 'Total Transaksi', 'Total Uang Masuk'];

    // Add header row
    const headerRow = worksheet.addRow(headers);
    headerRow.eachCell(cell => {
        cell.font = { bold: true, color: { argb: 'FFFFFF' } };
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: '1E90FF' } };
        cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' } };
    });

    // Adjust column width
    worksheet.columns.forEach(column => {
        column.width = 14;
    });

    worksheet.getColumn(1).width = 13;
    worksheet.getColumn(serviceList.length + 3).width = 20;

    // Fetch report data
    const reportData = await getReportData(start_date, end_date, merchant_id);
    let totalRevenue = 0, totalTransactions = 0, totalDays = 0;
    const serviceTotals: number[] = new Array(serviceList.length).fill(0);

    reportData.forEach(data => {
        const rowValues: (string | number)[] = [data.date, ...serviceList.map(s => Number(data[s.service_id]
        ) || 0), Number(data.total_transactions), Number(data.total_revenue)];
        const row = worksheet.addRow(rowValues);

        row.getCell(serviceList.length + 3).numFmt = '"Rp"#,##0.00'; // Format Total Uang Masuk as currency
        row.getCell(serviceList.length + 2).numFmt = '#,##0'; // Format Total Transaksi as number

        totalRevenue += data.total_revenue;
        totalTransactions += Number(data.total_transactions);
        totalDays++;
        serviceList.forEach((s, i) => serviceTotals[i] += Number(data[s.service_id] || 0) as number);
    });

    // Add totals row
    const totalRowValues: (string | number)[] = [`${totalDays} Days`, ...serviceTotals, Number(totalTransactions), totalRevenue];
    const totalRow = worksheet.addRow(totalRowValues);
    totalRow.eachCell(cell => {
        cell.font = { bold: true, color: { argb: '1E90FF' } };
        cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' } };
    });

    totalRow.getCell(serviceList.length + 3).numFmt = '"Rp"#,##0.00'; // Format Total Uang Masuk as currency
    totalRow.getCell(serviceList.length + 2).numFmt = '#,##0'; // Format Total Transaksi as number

    const buffer = await workbook.xlsx.writeBuffer();

    const formattedStartDate = format(start_date, 'dd-MM-yyyy', { locale: id });
    const formattedEndDate = format(end_date, 'dd-MM-yyyy', { locale: id });
    return { filename: `${merchantDetail?.name?.replace(/\s+/g, '').toLowerCase() || 'report'}_${formattedStartDate}:${formattedEndDate}`, file: Buffer.from(buffer) };
}

async function getReportData(start_date: string, end_date: string, merchantId: string): Promise<ReportData[]> {
    const client = await pool.connect();
    try {
        // Get the list of unique services dynamically
        const services = await getServiceList(start_date, end_date, merchantId);

        // Generate dynamic CASE WHEN statements for each service
        const serviceColumns = services.map(service => `
            SUM(CASE WHEN ti.service_id = '${service.service_id}' THEN 1 ELSE 0 END) AS "${service.service_id}"
        `).join(',');

        // Build the final SQL query dynamically
        const query = `
            WITH date_series AS (
                    SELECT generate_series($1::DATE, $2::DATE, '1 day') AS date
            )
            SELECT 
                TO_CHAR(ds.date, 'DD-MM-YYYY') AS date,
                COALESCE(COUNT(ti.id), 0) AS total_transactions,
                COALESCE(SUM(ti.qty * ti.price), 0) AS total_revenue
                ${serviceColumns ? `, ${serviceColumns}` : ""}
            FROM date_series ds
            LEFT JOIN transaction t ON t.created_at::DATE = ds.date AND t.merchant_id = $3 AND t.status = 'Selesai'
            LEFT JOIN transaction_item ti ON ti.transaction_id = t.id
            WHERE t.deleted_at IS NULL
            GROUP BY ds.date
            ORDER BY ds.date;   
        `;
        
        const result = await client.query(query, [start_date, end_date, merchantId]);
        return result.rows;
    } catch (error) {
        console.error("Error fetching report data:", error);
        throw new Error("Failed to retrieve report data");
    } finally {
        client.release();
    }
}

async function getServiceList(start_date: string, end_date: string, merchant_id: string): Promise<ServiceData[]> {
    const client = await pool.connect();
    try {
        const query = `
            SELECT DISTINCT ti.service_name, ti.service_id
            FROM transaction_item ti
            LEFT JOIN transaction t ON ti.transaction_id = t.id
            WHERE ti.created_at BETWEEN $1 AND $2
            AND t.status = 'Selesai' AND t.merchant_id = $3
            ORDER BY ti.service_name;
        `;
        const result = await client.query(query, [start_date, end_date, merchant_id]);
        return result.rows;
    } catch (error) {
        console.error("Error fetching service list:", error);
        throw new Error("Failed to retrieve service list");
    } finally {
        client.release();
    }
}

export async function getDashboardSummary(merchant_id: string): Promise<{ today_revenue: number; total_transactions: number }> {
    const client = await pool.connect();
    try {
        const query = `
            SELECT
                COALESCE(SUM(ti.price * ti.qty), 0) AS today_revenue,
                COALESCE(COUNT(DISTINCT t.id), 0) AS total_transactions
            FROM transaction t
            LEFT JOIN transaction_item ti ON ti.transaction_id = t.id
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND t.created_at::date = CURRENT_DATE
        `;

        const result = await client.query(query, [merchant_id]);
        return {
            today_revenue: Number(result.rows?.[0]?.today_revenue || 0),
            total_transactions: Number(result.rows?.[0]?.total_transactions || 0),
        };
    } finally {
        client.release();
    }
}

export async function getTransactionsSummary(
    merchant_id: string,
    start_date: string,
    end_date: string
): Promise<{ new: number; completed: number; picked_up: number; cancelled: number }> {
    const client = await pool.connect();
    try {
        const query = `
            SELECT
                COUNT(*) FILTER (WHERE t.status = 'Diproses') AS new,
                COUNT(*) FILTER (WHERE t.status = 'Selesai') AS completed,
                COUNT(*) FILTER (WHERE t.status = 'Siap Diambil') AS picked_up,
                COUNT(*) FILTER (WHERE t.status = 'Dibatalkan') AS cancelled
            FROM transaction t
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND t.created_at::date BETWEEN $2::date AND $3::date
        `;

        const result = await client.query(query, [merchant_id, start_date, end_date]);
        return {
            new: Number(result.rows?.[0]?.new || 0),
            completed: Number(result.rows?.[0]?.completed || 0),
            picked_up: Number(result.rows?.[0]?.picked_up || 0),
            cancelled: Number(result.rows?.[0]?.cancelled || 0),
        };
    } finally {
        client.release();
    }
}

export async function getTransactionsReport(
    merchant_id: string,
    start_date: string,
    end_date: string,
    page: number,
    limit: number
): Promise<{
    data: Array<{
        id: string;
        customer_name: string;
        invoice: string;
        status: string;
        payment_status: string;
        date: string;
    }>;
}> {
    const client = await pool.connect();
    try {
        const offset = (page - 1) * limit;
        const query = `
            SELECT
                t.id,
                t.customer_name,
                p.invoice_id AS invoice,
                t.status,
                p.status AS payment_status,
                t.created_at AS date
            FROM transaction t
            LEFT JOIN payment p ON p.transaction_id = t.id
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND t.created_at::date BETWEEN $2::date AND $3::date
            ORDER BY t.created_at DESC
            LIMIT $4 OFFSET $5
        `;

        const result = await client.query(query, [merchant_id, start_date, end_date, limit, offset]);
        return {
            data: result.rows.map((row) => ({
                id: row.id,
                customer_name: row.customer_name,
                invoice: row.invoice,
                status: mapTransactionStatus(row.status),
                payment_status: mapPaymentStatus(row.payment_status),
                date: row.date,
            })),
        };
    } finally {
        client.release();
    }
}

export async function getServiceReport(
    merchant_id: string,
    month: number,
    year: number
): Promise<{
    summary: { total_services: number; total_duration_days: number };
    services: Array<{
        service_id: string;
        name: string;
        duration: string;
        total_pcs: number;
        total_orders: number;
        total_revenue: number;
    }>;
}> {
    const client = await pool.connect();
    try {
        const query = `
            SELECT
                ti.service_id,
                ti.service_name AS name,
                COALESCE(MAX(ti.duration_length)::text || ' ' || MAX(ti.duration_length_type), '-') AS duration,
                COALESCE(MAX(ti.duration_length), 0) AS duration_length,
                COALESCE(MAX(ti.duration_length_type), '') AS duration_type,
                COALESCE(SUM(ti.qty), 0) AS total_pcs,
                COALESCE(COUNT(DISTINCT t.id), 0) AS total_orders,
                COALESCE(SUM(ti.qty * ti.price), 0) AS total_revenue
            FROM transaction_item ti
            JOIN transaction t ON t.id = ti.transaction_id
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND t.status = 'Selesai'
              AND EXTRACT(MONTH FROM t.created_at) = $2
              AND EXTRACT(YEAR FROM t.created_at) = $3
            GROUP BY ti.service_id, ti.service_name
            ORDER BY total_revenue DESC
        `;

        const result = await client.query(query, [merchant_id, month, year]);
        const services = result.rows.map((row) => ({
            service_id: row.service_id,
            name: row.name,
            duration: row.duration,
            total_pcs: Number(row.total_pcs),
            total_orders: Number(row.total_orders),
            total_revenue: Number(row.total_revenue),
            _duration_length: Number(row.duration_length),
            _duration_type: row.duration_type,
        }));

        const total_duration_days = services.reduce((acc, item) => {
            if ((item as any)._duration_type === 'Hari') {
                return acc + Number((item as any)._duration_length || 0);
            }
            return acc;
        }, 0);

        return {
            summary: {
                total_services: services.length,
                total_duration_days,
            },
            services: services.map((item) => ({
                service_id: item.service_id,
                name: item.name,
                duration: item.duration,
                total_pcs: item.total_pcs,
                total_orders: item.total_orders,
                total_revenue: item.total_revenue,
            })),
        };
    } finally {
        client.release();
    }
}

export async function getFinanceReport(
    merchant_id: string,
    start_date: string,
    end_date: string
): Promise<{
    revenue: { total: number; by_service: Array<{ name: string; amount: number }> };
    income: { total: number; by_payment_method: Array<{ method: string; amount: number }> };
    expenses: { total: number; by_category: Array<{ category: string; amount: number }> };
}> {
    const client = await pool.connect();
    try {
        const revenueByServiceQuery = `
            SELECT
                ti.service_name AS name,
                COALESCE(SUM(ti.qty * ti.price), 0) AS amount
            FROM transaction_item ti
            JOIN transaction t ON t.id = ti.transaction_id
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND t.status = 'Selesai'
              AND t.created_at::date BETWEEN $2::date AND $3::date
            GROUP BY ti.service_name
            ORDER BY amount DESC
        `;

        const incomeByPaymentMethodQuery = `
            SELECT
                CASE
                    WHEN p.status = 'Lunas' THEN 'Paid'
                    WHEN p.status = 'Belum Dibayar' THEN 'Unpaid'
                    ELSE COALESCE(p.status, 'Unknown')
                END AS method,
                COALESCE(SUM(p.total_amount_due), 0) AS amount
            FROM payment p
            JOIN transaction t ON t.id = p.transaction_id
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND t.created_at::date BETWEEN $2::date AND $3::date
            GROUP BY method
            ORDER BY amount DESC
        `;

        const expensesByCategoryQuery = `
            SELECT
                e.description AS category,
                COALESCE(SUM(e.total), 0) AS amount
            FROM expenses e
            WHERE e.merchant_id = $1
              AND e.date BETWEEN $2::date AND $3::date
            GROUP BY e.description
            ORDER BY amount DESC
        `;

        const [revenueByServiceResult, incomeByPaymentMethodResult, expensesByCategoryResult] = await Promise.all([
            client.query(revenueByServiceQuery, [merchant_id, start_date, end_date]),
            client.query(incomeByPaymentMethodQuery, [merchant_id, start_date, end_date]),
            client.query(expensesByCategoryQuery, [merchant_id, start_date, end_date]),
        ]);

        const by_service = revenueByServiceResult.rows.map((row) => ({
            name: row.name,
            amount: Number(row.amount),
        }));
        const by_payment_method = incomeByPaymentMethodResult.rows.map((row) => ({
            method: row.method,
            amount: Number(row.amount),
        }));
        const by_category = expensesByCategoryResult.rows.map((row) => ({
            category: row.category,
            amount: Number(row.amount),
        }));

        return {
            revenue: {
                total: by_service.reduce((sum, item) => sum + item.amount, 0),
                by_service,
            },
            income: {
                total: by_payment_method.reduce((sum, item) => sum + item.amount, 0),
                by_payment_method,
            },
            expenses: {
                total: by_category.reduce((sum, item) => sum + item.amount, 0),
                by_category,
            },
        };
    } finally {
        client.release();
    }
}

export async function getCustomersReport(
    merchant_id: string,
    month: number,
    year: number
): Promise<{
    summary: { total_customers: number; male: number; female: number };
    top_customers: Array<{
        rank: number;
        name: string;
        phone: string;
        total_transactions: number;
        total_spent: number;
    }>;
}> {
    const client = await pool.connect();
    try {
        const summaryQuery = `
            SELECT
                COUNT(*) AS total_customers,
                COUNT(*) FILTER (
                    WHERE LOWER(COALESCE(c.gender, '')) IN ('male', 'laki-laki', 'laki laki', 'pria')
                ) AS male,
                COUNT(*) FILTER (
                    WHERE LOWER(COALESCE(c.gender, '')) IN ('female', 'perempuan', 'wanita')
                ) AS female
            FROM customer c
            WHERE c.merchant_id = $1
              AND EXTRACT(MONTH FROM c.created_at) = $2
              AND EXTRACT(YEAR FROM c.created_at) = $3
        `;

        const topCustomersQuery = `
            SELECT
                t.customer_name AS name,
                t.customer_phone_number AS phone,
                COUNT(DISTINCT t.id) AS total_transactions,
                COALESCE(SUM(ti.qty * ti.price), 0) AS total_spent
            FROM transaction t
            LEFT JOIN transaction_item ti ON ti.transaction_id = t.id
            WHERE t.merchant_id = $1
              AND t.deleted_at IS NULL
              AND EXTRACT(MONTH FROM t.created_at) = $2
              AND EXTRACT(YEAR FROM t.created_at) = $3
            GROUP BY t.customer_name, t.customer_phone_number
            ORDER BY total_spent DESC
            LIMIT 5
        `;

        const [summaryResult, topCustomersResult] = await Promise.all([
            client.query(summaryQuery, [merchant_id, month, year]),
            client.query(topCustomersQuery, [merchant_id, month, year]),
        ]);

        const summaryRow = summaryResult.rows?.[0] || {};
        const top_customers = topCustomersResult.rows.map((row, index) => ({
            rank: index + 1,
            name: row.name,
            phone: row.phone,
            total_transactions: Number(row.total_transactions),
            total_spent: Number(row.total_spent),
        }));

        return {
            summary: {
                total_customers: Number(summaryRow.total_customers || 0),
                male: Number(summaryRow.male || 0),
                female: Number(summaryRow.female || 0),
            },
            top_customers,
        };
    } finally {
        client.release();
    }
}

function mapTransactionStatus(status: string): string {
    const mapped: Record<string, string> = {
        Diproses: 'new',
        Selesai: 'completed',
        'Siap Diambil': 'picked_up',
        Dibatalkan: 'cancelled',
    };

    return mapped[status] || status;
}

function mapPaymentStatus(status: string): string {
    const mapped: Record<string, string> = {
        Lunas: 'paid',
        'Belum Dibayar': 'unpaid',
    };

    return mapped[status] || status;
}