import express, { Request, Response } from "express";
import { transactionSchema } from "./types";
import {
  addTransaction,
  getInvoiceById,
  getTransactionById,
  getTransactions,
  softDeleteTransactionById,
  updateTransaction,
} from "./controller";
import { AuthenticatedRequest, requirePermission, resolveOutletId } from "../../middlewares";
import { formatJoiError } from "../../utils";

const router = express.Router();



router.get("/", requirePermission("transaction.read"), async (req: AuthenticatedRequest, res: Response) => {
    const requestedOutletId = (req.query.outlet_id as string) || undefined;
    const outletId = resolveOutletId(req, requestedOutletId);

  try {
    const {
      status,
      filter,
      date_from,
      date_to,
      page = "1",
      limit = "10",
    } = req.query;

    // Convert page and limit to numbers
    const pageNumber = parseInt(page as string, 10);
    const limitNumber = parseInt(limit as string, 10);

    // Ensure valid numbers for page and limit
    if (
      isNaN(pageNumber) ||
      pageNumber < 1 ||
      isNaN(limitNumber) ||
      limitNumber < 1
    ) {
      return res.status(400).json({ message: "Invalid page or limit values" });
    }

    // Call your transaction fetching logic with pagination
    const { transactions, totalCount } = await getTransactions(
      (status as string) || null,
      (filter as string) || null,
      (date_from as string) || null,
      (date_to as string) || null,
      req.userId,
      outletId,
      pageNumber,
      limitNumber
    );

    const isFirstPage = pageNumber === 1;
    const isLastPage = pageNumber * limitNumber >= totalCount;
    res.json({
      transactions,
      totalCount,
      isFirstPage,
      isLastPage,
    });
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

router.post("/", requirePermission("transaction.create"), async (req: AuthenticatedRequest, res) => {
  const { error } = transactionSchema.validate(req.body);
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  try {
    const outletId = resolveOutletId(req, req.body?.outlet_id);
    const newTransaction = await addTransaction(req.body, req.userId, outletId);
    res.status(201).json({
      status: "success",
      message: "Transaksi berhasil dibuat",
      data: newTransaction,
    });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ status: "error", message: "Transaksi gagal dibuat" });
  }
});

router.delete("/:id", requirePermission("transaction.delete"), async (req: AuthenticatedRequest, res) => {
  const { id } = req.params;

  try {
    const deletedTransaction = await softDeleteTransactionById(id);
    if (!deletedTransaction) {
      return res.status(404).json({
        status: "error",
        message: "Transaksi tidak ditemukan",
      });
    }

    res.status(200).json({
      status: "success",
      message: "Transaksi berhasil dihapus",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "Gagal menghapus transaksi",
    });
  }
});

router.put("/:invoiceId", requirePermission("transaction.update"), async (req, res) => {
  if (!req.body || typeof req.body.status !== "string") {
    return res
      .status(400)
      .json({ message: 'Invalid request. "status" field is required.' });
  }

  try {
    const invoiceId = req.params.invoiceId;
    const updatedTransaction = await updateTransaction(
      req.body.status,
      req.body.note,
      invoiceId
    );

    if (updatedTransaction) {
      res.status(200).json({
        status: "success",
        message: "Transaction status updated successfully",
        data: updatedTransaction,
      });
    } else {
      res.status(404).json({
        status: "error",
        message: "Transaksi tidak ditemukan",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Gagal membuat layanan" });
  }
});

router.get("/:invoiceId", requirePermission("transaction.read"), async (req: Request, res: Response) => {
  try {
    const invoiceId = req.params.invoiceId;
    const transaction = await getTransactionById(invoiceId);

    if (transaction) {
      res.status(200).json(transaction);
    } else {
      res
        .status(404)
        .json({ status: "error", message: "Transaksi tidak ditemukan" });
    }
  } catch (error) {
    res.status(500).json({ message: "Gagal membuat layanan" });
  }
});

router.get("/invoice/:invoiceId", requirePermission("transaction.read"), async (req: Request, res: Response) => {
  try {
    const invoiceId = req.params.invoiceId;
    const transaction = await getInvoiceById(invoiceId);

    if (transaction) {
      res.status(200).json(transaction);
    } else {
      res
        .status(404)
        .json({ status: "error", message: "Transaksi tidak ditemukan" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Gagal membuat layanan" });
  }
});

export default router;
