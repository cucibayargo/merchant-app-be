import express from 'express';
import {
    generateReport,
    getCustomersReport,
    getDashboardSummary,
    getFinanceReport,
    getServiceReport,
    getTransactionsReport,
    getTransactionsSummary,
} from './controller';
import { AuthenticatedRequest } from '../../middlewares';
import { differenceInDays, isValid, parseISO } from 'date-fns';
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Reports
 *   description: Report Download and Generation
 */

/**
 * @swagger
 * /report/download:
 *   get:
 *     summary: Retrieve a report of all transactions.
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: start_date
 *         schema:
 *           type: string
 *         required: true
 *         description: The start date for the report (YYYY-MM-DD).
 *       - in: query
 *         name: end_date
 *         schema:
 *           type: string
 *         required: true
 *         description: The end date for the report (YYYY-MM-DD).
 *     responses:
 *       200:
 *         description: Report of all transactions.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *       400:
 *         description: Invalid request parameters.
 *       500:
 *         description: Internal server error.
 */
router.get('/download', async (req: AuthenticatedRequest, res) => {
    try {
        const { start_date, end_date } = req.query;

        if (!start_date || !end_date) {
            return res.status(400).json({ message: "Tanggal mulai dan tanggal akhir wajib diisi." });
        }

        // Parse dates and validate range
        const startDate = parseISO(start_date as string);
        const endDate = parseISO(end_date as string);
        const dayDifference = differenceInDays(endDate, startDate);

        if (dayDifference < 0) {
            return res.status(400).json({ message: "Tanggal akhir harus setelah tanggal mulai." });
        }
        
        if (dayDifference > 31) {
            return res.status(400).json({ message: "Rentang tanggal tidak boleh lebih dari 31 hari." });
        }

        // Generate Excel report buffer
        const { filename, file } = await generateReport(start_date as string, end_date as string, req.userId as string);

        // Set response headers for downloading the file
        res.setHeader('Content-Disposition', `attachment; filename=${filename}.xlsx`);
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        // Send the Excel file
        res.send(file);
    } catch (error) {
        console.error("Kesalahan saat membuat laporan:", error);
        res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
});

router.get('/dashboard', async (req: AuthenticatedRequest, res) => {
    try {
        const data = await getDashboardSummary(req.userId as string);
        res.status(200).json(data);
    } catch (error) {
        console.error('Error fetching dashboard report:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server.' });
    }
});

router.get('/transactions/summary', async (req: AuthenticatedRequest, res) => {
    try {
        const { start_date, end_date } = req.query;
        if (!start_date || !end_date) {
            return res.status(400).json({ message: 'start_date dan end_date wajib diisi.' });
        }

        const startDate = parseISO(start_date as string);
        const endDate = parseISO(end_date as string);
        if (!isValid(startDate) || !isValid(endDate)) {
            return res.status(400).json({ message: 'Format tanggal tidak valid.' });
        }

        const data = await getTransactionsSummary(req.userId as string, start_date as string, end_date as string);
        res.status(200).json(data);
    } catch (error) {
        console.error('Error fetching transaction summary report:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server.' });
    }
});

router.get('/transactions', async (req: AuthenticatedRequest, res) => {
    try {
        const { start_date, end_date, page = '1', limit = '10' } = req.query;
        if (!start_date || !end_date) {
            return res.status(400).json({ message: 'start_date dan end_date wajib diisi.' });
        }

        const startDate = parseISO(start_date as string);
        const endDate = parseISO(end_date as string);
        if (!isValid(startDate) || !isValid(endDate)) {
            return res.status(400).json({ message: 'Format tanggal tidak valid.' });
        }

        const pageNumber = Number(page);
        const limitNumber = Number(limit);
        if (!Number.isInteger(pageNumber) || pageNumber <= 0 || !Number.isInteger(limitNumber) || limitNumber <= 0) {
            return res.status(400).json({ message: 'page dan limit harus bilangan bulat positif.' });
        }

        const data = await getTransactionsReport(
            req.userId as string,
            start_date as string,
            end_date as string,
            pageNumber,
            limitNumber
        );
        res.status(200).json(data);
    } catch (error) {
        console.error('Error fetching transactions report:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server.' });
    }
});

router.get('/service', async (req: AuthenticatedRequest, res) => {
    try {
        const { month, year } = req.query;
        const monthNumber = Number(month);
        const yearNumber = Number(year);

        if (!Number.isInteger(monthNumber) || monthNumber < 1 || monthNumber > 12) {
            return res.status(400).json({ message: 'month harus angka 1 sampai 12.' });
        }
        if (!Number.isInteger(yearNumber) || yearNumber < 1900) {
            return res.status(400).json({ message: 'year tidak valid.' });
        }

        const data = await getServiceReport(req.userId as string, monthNumber, yearNumber);
        res.status(200).json(data);
    } catch (error) {
        console.error('Error fetching service report:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server.' });
    }
});

router.get('/finance', async (req: AuthenticatedRequest, res) => {
    try {
        const { start_date, end_date } = req.query;
        if (!start_date || !end_date) {
            return res.status(400).json({ message: 'start_date dan end_date wajib diisi.' });
        }

        const startDate = parseISO(start_date as string);
        const endDate = parseISO(end_date as string);
        if (!isValid(startDate) || !isValid(endDate)) {
            return res.status(400).json({ message: 'Format tanggal tidak valid.' });
        }

        const data = await getFinanceReport(req.userId as string, start_date as string, end_date as string);
        res.status(200).json(data);
    } catch (error) {
        console.error('Error fetching finance report:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server.' });
    }
});

router.get('/customers', async (req: AuthenticatedRequest, res) => {
    try {
        const { month, year } = req.query;
        const monthNumber = Number(month);
        const yearNumber = Number(year);

        if (!Number.isInteger(monthNumber) || monthNumber < 1 || monthNumber > 12) {
            return res.status(400).json({ message: 'month harus angka 1 sampai 12.' });
        }
        if (!Number.isInteger(yearNumber) || yearNumber < 1900) {
            return res.status(400).json({ message: 'year tidak valid.' });
        }

        const data = await getCustomersReport(req.userId as string, monthNumber, yearNumber);
        res.status(200).json(data);
    } catch (error) {
        console.error('Error fetching customers report:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server.' });
    }
});

export default router;