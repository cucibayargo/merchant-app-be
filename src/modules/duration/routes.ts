import express from 'express';
import { Duration, durationSchema, DurationType } from './types';
import { getDurations, getDurationById, addDuration, updateDuration, deleteDuration, getAllDurations } from './controller';
import { AuthenticatedRequest } from '../../middlewares';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Duration
 *   description: Duration management APIs
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     DurationAll:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: Unique identifier for the duration
 *           example: "1"
 *         name:
 *           type: string
 *           description: Name of the duration
 *           example: "One Day"
 *         duration:
 *           type: number
 *           description: Duration value
 *           example: 1
 *         type:
 *           type: string
 *           enum:
 *             - Hari
 *             - Jam
 *           description: Type of duration (Hari or Jam)
 *           example: "Hari"
 *     DurationRequestBody:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *           description: Name of the duration
 *           example: "One Day"
 *         duration:
 *           type: number
 *           description: Duration value
 *           example: 1
 *         type:
 *           type: string
 *           enum:
 *             - Hari
 *             - Jam
 *           description: Type of duration (Hari or Jam)
 *           example: "Hari"
 *     DurationResponse:
 *       type: object
 *       properties:
 *         status:
 *           type: string
 *           example: "success"
 *         message:
 *           type: string
 *           example: "Duration created successfully"
 *         data:
 *           $ref: '#/components/schemas/DurationAll'
 */

/**
 * @swagger
 * /duration:
 *   get:
 *     summary: Get all durations
 *     description: Retrieve a list of all durations
 *     tags: [Duration]
 *     parameters:
 *       - in: query
 *         name: filter
 *         schema:
 *            type: string
 *         description: Filter Data by name, duration, type
 *       - in: query
 *         name: hasService
 *         schema:
 *            type: string
 *         description: Filter Data by services availability
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: Page number for pagination (optional) *
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *         description: Number of items per page (optional) *
 *     responses:
 *       200:
 *         description: Successful retrieval
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/DurationAll'
 */
router.get('/', async (req: AuthenticatedRequest, res) => {
  // Extract query parameters from the request
  const filter = req.query.filter as string | null;
  const hasService = req.query.hasService == "true" ? true : false;
  const page = parseInt(req.query.page as string || "1", 10);
  const limit = parseInt(req.query.limit as string || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { durations, totalCount } = await getDurations(filter, hasService, req.userId);
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    res.json({
      durations,
      totalCount,
      isFirstPage,
      isLastPage
    });
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({ message: error.message });
    } else {
      res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
  }
});

/**
 * @swagger
 * /duration/all:
 *   get:
 *     summary: Get all durations
 *     description: Retrieve a list of all durations with optional filtering based on service availability.
 *     tags: [Duration]
 *     parameters:
 *       - in: query
 *         name: hasService
 *         schema:
 *           type: boolean
 *         description: Filter data by services availability. Use `true` to only include durations linked to services.
 *     responses:
 *       200:
 *         description: Successful retrieval of durations.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 durations:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/DurationAll'
 *                 totalCount:
 *                   type: integer
 *                   description: Total number of durations available.
 *       500:
 *         description: Internal server error.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
router.get('/all', async (req: AuthenticatedRequest, res) => {
  const hasService = req.query.hasService === "true"; // Simplified condition for boolean check

  try {
    const durations = await getAllDurations(hasService, req.userId);

    res.json(durations);
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Terjadi kesalahan server';
    res.status(500).json({ message: errorMessage });
  }
});


/**
 * @swagger
 * /duration:
 *   post:
 *     summary: Create a new duration
 *     description: Create a new duration record
 *     tags: [Duration]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/DurationRequestBody'
 *     responses:
 *       201:
 *         description: Duration created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/DurationResponse'
 *       400:
 *         description: Bad request, invalid input
 */
router.post('/', async (req: AuthenticatedRequest, res) => {
  if (!req.body || typeof req.body !== 'object') {
    return res.status(400).json({
      errors: [{
        type: 'body',
        msg: 'Isi permintaan hilang atau tidak valid',
      }],
    });
  }

  const { error, value } = durationSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({
      errors: error.details.map(err => ({
        type: 'field',
        msg: err.message,
        path: err.path[0],
        location: 'body'
      }))
    });
  }

  const { id, name, duration, type } = req.body;
  try {
    await addDuration({ name, duration, type }, req.userId);
    res.status(201).json({ status: 'success', message: 'Durasi berhasil' });
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({ message: error.message });
    } else {
      res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
  }
});

/**
 * @swagger
 * /duration/{id}:
 *   put:
 *     summary: Update a duration
 *     description: Update an existing duration record by ID
 *     tags: [Duration]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the duration to update
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/DurationRequestBody'
 *     responses:
 *       200:
 *         description: Durasi berhasil diperbarui
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/DurationResponse'
 *       400:
 *         description: Bad request, invalid input
 *       404:
 *         description: Durasi tidak ditemukan
 */
router.put('/:id', async (req, res) => {
  if (!req.body || typeof req.body !== 'object') {
    return res.status(400).json({
      errors: [{
        type: 'body',
        msg: 'Isi permintaan hilang atau tidak valid',
      }],
    });
  }

  const { error, value } = durationSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({
      errors: error.details.map(err => ({
        type: 'field',
        msg: err.message,
        path: err.path[0],
        location: 'body'
      }))
    });
  }

  const { id, name, duration, type } = req.body;
  const durationId = req.params.id;
  try {
    await updateDuration(durationId, { name, duration, type });
    res.json({ status: 'success', message: 'Durasi berhasil diperbarui'});
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.includes('not found')) {
        res.status(404).json({ message: 'Durasi tidak ditemukan' });
      } else {
        res.status(500).json({ message: error.message });
      }
    } else {
      res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
  }
});

/**
 * @swagger
 * /duration/{id}:
 *   delete:
 *     summary: Delete a duration
 *     description: Delete a duration record by ID
 *     tags: [Duration]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the duration to delete
 *     responses:
 *       200:
 *         description: Duration deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "success"
 *                 message:
 *                   type: string
 *                   example: "Duration deleted successfully"
 *       404:
 *         description: Durasi tidak ditemukan
 */
router.delete('/:id', async (req, res) => {
  const durationId = req.params.id;
  try {
    await deleteDuration(durationId);
    res.status(200).json({
      status: 'success',
      message: 'Durasi berhasil dihapus.'
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.includes('not found')) {
        res.status(404).json({ message: 'Durasi tidak ditemukan' });
      } else {
        res.status(500).json({ message: error.message });
      }
    } else {
      res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
  }
});

/**
 * @swagger
 * /duration/{id}:
 *   get:
 *     summary: Get a duration by ID
 *     description: Retrieve a duration by its ID
 *     tags: [Duration]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the duration to retrieve
 *     responses:
 *       200:
 *         description: Successful retrieval
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/DurationAll'
 *       404:
 *         description: Durasi tidak ditemukan
 */
router.get('/:id', async (req, res) => {
  const durationId = req.params.id;

  try {
    const duration = await getDurationById(durationId);
    if (!duration) {
      return res.status(404).json({ message: 'Durasi tidak ditemukan' });
    }
    res.json(duration);
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({ message: error.message });
    } else {
      res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
  }
});

export default router;
