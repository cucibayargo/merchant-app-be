import express from 'express';
import { Duration, durationSchema, DurationType } from './types';
import { getDurations, getDurationById, addDuration, updateDuration, deleteDuration, getAllDurations } from './controller';
import { AuthenticatedRequest } from '../../middlewares';
import { formatJoiError } from '../../utils';

const router = express.Router();



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
    const { durations, totalCount } = await getDurations(filter, hasService, req.userId, page, limit);
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
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
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
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
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
