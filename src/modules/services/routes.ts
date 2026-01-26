import express from 'express';
import { serviceSchema } from './types';
import { addService, deleteService, getAllServices, getServiceById, getServices, updateService } from './controller';
import { AuthenticatedRequest } from '../../middlewares';
import { formatJoiError } from '../../utils';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Services
 *   description: Service management APIs
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     ServiceAll:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: Unique identifier for the service
 *           example: "1"
 *         name:
 *           type: string
 *           description: Service name
 *           example: "Dry Cleaning"
 *     Duration:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: Duration ID
 *           example: "1"
 *         duration:
 *           type: number
 *           description: Duration in minutes
 *           example: 30
 *         duration_name:
 *           type: string
 *           description: Name of the duration
 *           example: "Half Hour"
 *         price:
 *           type: number
 *           description: Price for the duration
 *           example: 10000
 *     Service:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: Unique identifier for the service
 *           example: "1"
 *         name:
 *           type: string
 *           description: Service name
 *           example: "Dry Cleaning"
 *         unit:
 *           type: string
 *           description: Unit of measurement
 *           example: "kg"
 *         durations:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/Duration'
 *           example: [
 *             {
 *               id: "1",
 *               duration: 30,
 *               duration_name: "Half Hour",
 *               price: 10000
 *             },
 *             {
 *               id: "2",
 *               duration: 60,
 *               duration_name: "One Hour",
 *               price: 15000
 *             }
 *           ]
 *     ServiceRequestBody:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *           description: Service name
 *           example: "Dry Cleaning"
 *         unit:
 *           type: string
 *           description: Unit of measurement
 *           example: "kg"
 *         durations:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               duration:
 *                 type: string
 *                 description: UUID of the duration
 *                 example: "550e8400-e29b-41d4-a716-446655440000"
 *               price:
 *                 type: number
 *                 description: Price for the duration
 *                 example: 10000
 *           example: [
 *             {
 *               duration: "550e8400-e29b-41d4-a716-446655440000",
 *               price: 10000
 *             },
 *             {
 *               duration: "550e8400-e29b-41d4-a716-446655440001",
 *               price: 15000
 *             }
 *           ]
 *       required:
 *         - name
 *         - unit
 *         - durations
 *     ServiceResponse:
 *       type: object
 *       properties:
 *         status:
 *           type: string
 *           example: "success"
 *         message:
 *           type: string
 *           example: "Layanan berhasil dibuat"
 *         data:
 *           $ref: '#/components/schemas/Service'
 *       example:
 *         status: "success"
 *         message: "Layanan berhasil dibuat"
 *         data:
 *           id: "1"
 *           name: "Dry Cleaning"
 *           unit: "kg"
 *           durations: [
 *             {
 *               id: "550e8400-e29b-41d4-a716-446655440000",
 *               duration: 30,
 *               duration_name: "Half Hour",
 *               price: 10000
 *             },
 *             {
 *               id: "550e8400-e29b-41d4-a716-446655440001",
 *               duration: 60,
 *               duration_name: "One Hour",
 *               price: 15000
 *             }
 *           ]
 */

/**
 * @swagger
 * /service/all:
 *   get:
 *     summary: Retrieve all services
 *     description: Fetch a list of all services, optionally filtered by duration.
 *     tags: [Services]
 *     parameters:
 *       - in: query
 *         name: duration
 *         schema:
 *           type: string
 *         required: false
 *         description: Filter services by a specific duration ID.
 *       - in: query
 *         name: filter
 *         schema:
 *           type: string
 *         required: false
 *         description: Filter services by a specific service Name.
 *     responses:
 *       200:
 *         description: Successfully retrieved the list of services.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/ServiceAll'
 *       500:
 *         description: Internal server error.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Failed to retrieve services.
 */
router.get('/all', async (req: AuthenticatedRequest, res) => {
  const durationId = req.query.duration as string | null;
  const filter = req.query.filter as string | null;

  try {
    const services = await getAllServices(req.userId, durationId, filter);
    res.status(200).json(services);
  } catch (error) {
    console.error("Error retrieving services:", error);
    res.status(500).json({ message: 'Failed to retrieve services' });
  }
});

/**
 * @swagger
 * /service:
 *   get:
 *     summary: Get all services pagination
 *     description: Retrieve a list of all services
 *     tags: [Services]
 *     parameters:
 *       - in: query
 *         name: filter
 *         schema:
 *           type: string
 *         description: Filter data by name
 *       - in: query
 *         name: duration
 *         schema:
 *           type: string
 *         description: Filter data by duration
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
 *                 $ref: '#/components/schemas/ServiceAll'
 */
router.get('/', async (req: AuthenticatedRequest, res) => {
  // Extract query parameters from the request
  const filter = req.query.filter as string | null;
  const page = parseInt(req.query.page as string || "1", 10);
  const limit = parseInt(req.query.limit as string || "10", 10);
  
  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }
  
  try {
    const { services, totalCount }= await getServices(filter, req.userId, page, limit);
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    res.json({
      services,
      totalCount,
      isFirstPage,
      isLastPage
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: 'Gagal mengambil layanan' });
  }
});

/**
 * @swagger
 * /service:
 *   post:
 *     summary: Create a new service
 *     description: Create a new service record
 *     tags: [Services]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/ServiceRequestBody'
 *     responses:
 *       201:
 *         description: Layanan berhasil dibuat
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ServiceResponse'
 *       400:
 *         description: Bad request, invalid input
 */
router.post('/', async (req: AuthenticatedRequest, res) => {
  const { error } = serviceSchema.validate(req.body);
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  try {
    await addService(req.body, req.userId);
    res.status(201).json({
      status: 'success',
      message: 'Layanan berhasil dibuat'
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: 'Gagal membuat layanan' });
  }
});

/**
 * @swagger
 * /service/{id}:
 *   put:
 *     summary: Update a service
 *     description: Update an existing service record
 *     tags: [Services]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/ServiceRequestBody'
 *     responses:
 *       200:
 *         description: Service updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ServiceResponse'
 *       400:
 *         description: Bad request, invalid input
 *       404:
 *         description: Layanan tidak ditemukan
 */
router.put('/:id', async (req, res) => {
  const { error } = serviceSchema.validate(req.body);
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  try {
    await updateService(req.params.id, req.body);
    res.json({
      status: 'success',
      message: 'Layanan berhasil diubah'
    });
  } catch (error) {
    res.status(404).json({ message: 'Layanan tidak ditemukan' });
  }
});

/**
 * @swagger
 * /service/{id}:
 *   delete:
 *     summary: Delete a service
 *     description: Delete an existing service record
 *     tags: [Services]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Service deleted successfully
 *       404:
 *         description: Layanan tidak ditemukan
 */
router.delete('/:id', async (req, res) => {
  try {
    await deleteService(req.params.id);
    res.status(200).json({
      status: 'success',
      message: 'Service deleted successfully'
    });
  } catch (error) {
    res.status(404).json({ message: 'Layanan tidak ditemukan' });
  }
});

/**
 * @swagger
 * /service/{id}:
 *   get:
 *     summary: Get a service by ID
 *     description: Retrieve a service by its ID
 *     tags: [Services]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the service to retrieve
 *     responses:
 *       200:
 *         description: Successful retrieval
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Service'
 *       404:
 *         description: Layanan tidak ditemukan
 */
router.get('/:id', async (req, res) => {
  const serciveId = req.params.id;

  try {
    const duration = await getServiceById(serciveId);
    if (!duration) {
      return res.status(404).json({ message: 'Layanan tidak ditemukan' });
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
