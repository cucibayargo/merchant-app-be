import { Workbook } from 'exceljs';
import { ReportData, ServiceData } from './types';
import pool from '../../database/postgres';
import axios from 'axios';

export async function generateReport(start_date: string, end_date: string, merchant_id: string): Promise<Buffer> {
    const workbook = new Workbook();
    const worksheet = workbook.addWorksheet('Report', {
        properties: { tabColor: { argb: '1E90FF' } }
    });
    worksheet.views = [{ showGridLines: false }];

    // Add logo
    const imageResponse = await axios.get('https://sbuysfjktbupqjyoujht.supabase.co/storage/v1/object/sign/asset/logo-B3sUIac6.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhc3NldC9sb2dvLUIzc1VJYWM2LnBuZyIsImlhdCI6MTczMjM3Nzk1NSwiZXhwIjozMzA5MTc3OTU1fQ.81ldrpdW5_BYGJglW6bwmMk6Dmi0x1vNBwy44dmZfGM&t=2024-11-23T16%3A05%3A55.422Z', { responseType: 'arraybuffer' });
    const imageId = workbook.addImage({ buffer: imageResponse.data, extension: 'png' });
    worksheet.addImage(imageId, 'A1:B4');
    worksheet.addRow([]);

    // Add title
    worksheet.mergeCells('A6:F6');
    const titleCell = worksheet.getCell('A6');
    titleCell.value = `Laporan dari tanggal ${start_date} sampai ${end_date}`;
    titleCell.font = { bold: true, size: 16 };
    titleCell.alignment = { vertical: 'middle', horizontal: 'left' };

    worksheet.addRow([]);
    worksheet.addRow([]);

    // Get services
    const serviceList = await getServiceList(start_date, end_date, merchant_id);
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
         ) || 0), Number(data.total_transactions),Number(data.total_revenue)];
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
    return Buffer.from(buffer);
}

async function getReportData(start_date: string, end_date: string, merchantId: string): Promise<ReportData[]> {
    const client = await pool.connect();
    try {
        // Get the list of unique services dynamically
        const services = await getServiceList(start_date, end_date,merchantId);

        // Generate dynamic CASE WHEN statements for each service
        const serviceColumns = services.map(service => `
            SUM(CASE WHEN ti.service_id = '${service.service_id}' THEN 1 ELSE 0 END) AS "${service.service_id}"
        `).join(',');

        // Build the final SQL query dynamically
        const query = `
            SELECT 
                TO_CHAR(DATE(t.created_at), 'DD-MM-YYYY') AS date,
                COUNT(ti.id) AS total_transactions,
                SUM(ti.qty * ti.price) AS total_revenue,
                ${serviceColumns}
            FROM transaction_item ti
            LEFT JOIN transaction t ON ti.transaction_id = t.id
            WHERE DATE(t.created_at) BETWEEN $1 AND $2
            AND t.status = 'Selesai' AND t.merchant_id = $3
            GROUP BY DATE(t.created_at)
            ORDER BY DATE(t.created_at);
        `;

        console.log(query);
        
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