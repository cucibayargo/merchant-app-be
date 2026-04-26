import express from 'express';
import { serviceSchema } from './types';
import { addService, deleteService, getAllServices, getServiceById, getServices, updateService } from './controller';
import { AuthenticatedRequest, requirePermission, resolveOutletId } from '../../middlewares';
import { formatJoiError } from '../../utils';

const router = express.Router();



router.get('/all', async (req: AuthenticatedRequest, res) => {
  const durationId = req.query.duration as string | null;
  const filter = req.query.filter as string | null;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);

  try {
    const services = await getAllServices(req.userId, durationId, outletId, filter);
    res.status(200).json(services);
  } catch (error) {
    console.error("Error retrieving services:", error);
    res.status(500).json({ message: 'Failed to retrieve services' });
  }
});

router.get('/', async (req: AuthenticatedRequest, res) => {
  // Extract query parameters from the request
  const filter = req.query.filter as string | null;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
  const page = parseInt(req.query.page as string || "1", 10);
  const limit = parseInt(req.query.limit as string || "10", 10);
  
  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }
  
  try {
    const { services, totalCount }= await getServices(filter, req.userId, outletId, page, limit);
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

router.post('/', requirePermission('service.create'), async (req: AuthenticatedRequest, res) => {
  const { error } = serviceSchema.validate(req.body);
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const outletId = resolveOutletId(req, req.body?.outlet_id);
  if (!outletId) {
    return res.status(400).json({ message: 'Outlet wajib dipilih.' });
  }

  try {
    await addService(req.body, req.userId, outletId);
    res.status(201).json({
      status: 'success',
      message: 'Layanan berhasil dibuat'
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: 'Gagal membuat layanan' });
  }
});

router.put('/:id', requirePermission('service.update'), async (req: AuthenticatedRequest, res) => {
  const { error } = serviceSchema.validate(req.body);
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const outletId = resolveOutletId(req, req.body?.outlet_id || (req.query.outlet_id as string | undefined));
  if (!outletId) {
    return res.status(400).json({ message: 'Outlet wajib dipilih.' });
  }

  try {
    await updateService(req.params.id, req.body, req.userId, outletId);
    res.json({
      status: 'success',
      message: 'Layanan berhasil diubah'
    });
  } catch (error) {
    const err = error as Error;
    res.status(404).json({ message: err.message || 'Layanan tidak ditemukan' });
  }
});

router.delete('/:id', requirePermission('service.delete'), async (req: AuthenticatedRequest, res) => {
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
  if (!outletId) {
    return res.status(400).json({ message: 'Outlet wajib dipilih.' });
  }

  try {
    await deleteService(req.params.id, req.userId, outletId);
    res.status(200).json({
      status: 'success',
      message: 'Service deleted successfully'
    });
  } catch (error) {
    const err = error as Error;
    res.status(404).json({ message: err.message || 'Layanan tidak ditemukan' });
  }
});

router.get('/:id', requirePermission('service.read'), async (req: AuthenticatedRequest, res) => {
  const serciveId = req.params.id;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);

  try {
    const duration = await getServiceById(serciveId, req.userId, outletId);
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
