import express, { Request, Response } from "express";
import { getPaymentByInvoiceId, updatePayment } from "./controller";

const router = express.Router();



router.put('/:invoiceId', async (req: Request, res: Response) => {
  const { invoiceId } = req.params;
  const { payment_received, change_given, payment_method } = req.body;

  if (!payment_received || change_given < 0 || !payment_method) {
    return res.status(400).json({
      message: 'Input tidak valid, payment_received dan change_given diperlukan.'
    });
  }

  try {
    const updatedPayment = await updatePayment(invoiceId, { payment_received, change_given, payment_method });
    res.json({
      status: 'sukses',
      message: 'Pembayaran berhasil diperbarui.',
      data: updatedPayment
    });
  } catch (error) {
    console.log(error);
    res.status(404).json({ message: 'Pembayaran tidak ditemukan.' });
  }
});

router.get('/:invoiceId', async (req: Request, res: Response) => {
  const { invoiceId } = req.params;

  if (!invoiceId) {
    return res.status(400).json({
      message: 'Input tidak valid, ID faktur diperlukan.'
    });
  }

  try {
    const paymentDetails = await getPaymentByInvoiceId(invoiceId);
    if (!paymentDetails) {
      return res.status(404).json({ message: 'Pembayaran tidak ditemukan.' });
    }
    
    res.json({
      status: 'sukses',
      message: 'Detail pembayaran berhasil diambil.',
      data: paymentDetails
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan server.' });
  }
});


export default router;
