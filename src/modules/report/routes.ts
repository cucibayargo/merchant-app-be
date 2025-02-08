import express from 'express';
import { generateReport } from './controller';
import { AuthenticatedRequest } from '../../middlewares';
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
            return res.status(400).json({ error: "start_date and end_date are required." });
        }

        // Generate Excel report buffer
        const reportBuffer = await generateReport(start_date as string, end_date as string,req.userId as string);

        // Set response headers for downloading the file
        res.setHeader('Content-Disposition', 'attachment; filename=report.xlsx');
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        // Send the Excel file
        res.send(reportBuffer);
    } catch (error) {
        console.error("Error generating report:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});
export default router;