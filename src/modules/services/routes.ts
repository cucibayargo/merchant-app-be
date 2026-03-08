import express from 'express';
import { serviceSchema } from './types';
import { addService, deleteService, getAllServices, getServiceById, getServices, updateService } from './controller';
import { AuthenticatedRequest } from '../../middlewares';
import { formatJoiError } from '../../utils';

const router = express.Router();



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
