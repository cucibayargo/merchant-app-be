import express from 'express';
import { generateReport } from './controller';
import { AuthenticatedRequest } from '../../middlewares';
import { differenceInDays, parseISO } from 'date-fns';
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

export default router;