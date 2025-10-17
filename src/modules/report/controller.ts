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