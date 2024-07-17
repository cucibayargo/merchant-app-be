import express from 'express';
import { LaundryEntry, LaundryStatus } from './types';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Laundry
 *   description: Laundry management APIs
 */

/**
 * @swagger
 * /v1/laundry/get:
 *   get:
 *     summary: Get laundry details
 *     description: Retrieve details of the laundry with optional status filter
 *     parameters:
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum:
 *             - Diproses
 *             - Selesai
 *             - Siap Diambil
 *         description: Filter by laundry status
 *     responses:
 *       200:
 *         description: Successful retrieval
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 customer:
 *                   type: string
 *                 duration:
 *                   type: string
 *                 qty:
 *                   type: number
 *                 service:
 *                   type: string
 *                 status:
 *                   type: string
 *                   enum:
 *                     - Diproses
 *                     - Selesai
 *                     - Siap Diambil
 */
router.get('/get', (req, res) => {
  const statusFilter = req.query.status as LaundryStatus | undefined;

  // Sample laundry data
  const sampleLaundry: LaundryEntry[] = [
    { customer: 'uuid-123', duration: 'uuid-456', qty: 5, service: 'uuid-789', status: LaundryStatus.DiProses },
    { customer: 'uuid-124', duration: 'uuid-457', qty: 3, service: 'uuid-790', status: LaundryStatus.Selesai },
    { customer: 'uuid-125', duration: 'uuid-458', qty: 7, service: 'uuid-791', status: LaundryStatus.SiapDiambil }
  ];

  const filteredLaundry = statusFilter ? sampleLaundry.filter(entry => entry.status === statusFilter) : sampleLaundry;

  res.json(filteredLaundry);
});

/**
 * @swagger
 * /v1/laundry/create:
 *   post:
 *     summary: Create a new laundry entry
 *     description: Create a new laundry entry with items
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               customer:
 *                 type: string
 *               duration:
 *                 type: string
 *               qty:
 *                 type: number
 *               service:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum:
 *                   - Diproses
 *     responses:
 *       201:
 *         description: Laundry entry created
 */
router.post('/create', (req, res) => {
  const { customer, duration, qty, service, status }: LaundryEntry = req.body;
  if (status !== LaundryStatus.DiProses) {
    return res.status(400).send('Invalid status for new entry');
  }
  res.status(201).send('Laundry entry created');
});

/**
 * @swagger
 * /v1/laundry/edit:
 *   put:
 *     summary: Edit laundry details
 *     description: Edit existing laundry entry details
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               customer:
 *                 type: string
 *               duration:
 *                 type: string
 *               qty:
 *                 type: number
 *               service:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum:
 *                   - Diproses
 *                   - Selesai
 *                   - Siap Diambil
 *     responses:
 *       200:
 *         description: Laundry entry updated
 */
router.put('/edit', (req, res) => {
  const { customer, duration, qty, service, status }: LaundryEntry = req.body;
  if (!Object.values(LaundryStatus).includes(status)) {
    return res.status(400).send('Invalid status');
  }
  res.send('Laundry entry updated');
});

export default router;
