import express from 'express';
import { Duration, durationSchema, DurationType } from './types';
import { getDurations, getDurationById, addDuration, updateDuration, deleteDuration, getAllDurations } from './controller';
import { AuthenticatedRequest, requirePermission, resolveOutletId } from '../../middlewares';
import { formatJoiError } from '../../utils';

const router = express.Router();



router.get('/', requirePermission('duration.read'), async (req: AuthenticatedRequest, res) => {
  // Extract query parameters from the request
  const filter = req.query.filter as string | null;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
  const hasService = req.query.hasService == "true" ? true : false;
  const page = parseInt(req.query.page as string || "1", 10);
  const limit = parseInt(req.query.limit as string || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { durations, totalCount } = await getDurations(filter, hasService, req.userId, outletId, page, limit);
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

router.get('/all', requirePermission('duration.read'), async (req: AuthenticatedRequest, res) => {
  const hasService = req.query.hasService === "true"; // Simplified condition for boolean check
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);

  try {
    const durations = await getAllDurations(hasService, req.userId, outletId);

    res.json(durations);
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Terjadi kesalahan server';
    res.status(500).json({ message: errorMessage });
  }
});


router.post('/', requirePermission('duration.create'), async (req: AuthenticatedRequest, res) => {
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
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const outletId = resolveOutletId(req, req.body?.outlet_id);
  if (!outletId) {
    return res.status(400).json({ message: 'Outlet wajib dipilih.' });
  }

  const { id, name, duration, type } = req.body;
  try {
    await addDuration({ name, duration, type }, req.userId, outletId);
    res.status(201).json({ status: 'success', message: 'Durasi berhasil' });
  } catch (error) {
    if (error instanceof Error) {
      res.status(500).json({ message: error.message });
    } else {
      res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
  }
});

router.put('/:id', requirePermission('duration.update'), async (req: AuthenticatedRequest, res) => {
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
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const outletId = resolveOutletId(req, req.body?.outlet_id || (req.query.outlet_id as string | undefined));
  if (!outletId) {
    return res.status(400).json({ message: 'Outlet wajib dipilih.' });
  }

  const { id, name, duration, type } = req.body;
  const durationId = req.params.id;
  try {
    await updateDuration(durationId, { name, duration, type }, req.userId, outletId);
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

router.delete('/:id', requirePermission('duration.delete'), async (req: AuthenticatedRequest, res) => {
  const durationId = req.params.id;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
  if (!outletId) {
    return res.status(400).json({ message: 'Outlet wajib dipilih.' });
  }

  try {
    await deleteDuration(durationId, req.userId, outletId);
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

router.get('/:id', requirePermission('duration.read'), async (req: AuthenticatedRequest, res) => {
  const durationId = req.params.id;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);

  try {
    const duration = await getDurationById(durationId, req.userId, outletId);
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
