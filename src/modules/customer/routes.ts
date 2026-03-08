import express, { Request, Response } from "express";
import { addCustomer, GetCustomers, updateCustomer, getCustomerById, deleteCustomer } from "./controller";
import { customerSchema } from "./types";
import { AuthenticatedRequest } from "../../middlewares";
import { formatJoiError } from "../../utils";

const router = express.Router();





router.get("/", async (req: AuthenticatedRequest, res) => {
  const filter = req.query.filter as string | null;
  const page = parseInt(req.query.page as string || "1", 10);
  const limit = parseInt(req.query.limit as string || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { customers, totalCount } = await GetCustomers(filter, req.userId ?? "empty", page, limit);
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    res.json({
      customers,
      totalCount,
      isFirstPage,
      isLastPage
    });
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

router.post("/", (req: AuthenticatedRequest, res: Response) => {
  if (!req.body || typeof req.body !== 'object') {
    return res.status(400).json({
      errors: [{
        type: 'body',
        msg: 'Isi permintaan hilang atau tidak valid',
      }],
    });
  }

  const { error, value } = customerSchema.validate(req.body, { abortEarly: false });
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const { name, phone_number, email, address, gender } = req.body;

  addCustomer({ name, phone_number, email, address, gender }, req.userId ?? "")
    .then(() =>
      res.status(201).json({
        status: "success",
        message: "Customer created successfully"
      })
    )
    .catch((error) => {
      const err = error as Error;
      res.status(500).json({ message: err.message });
    });
});

router.get("/:id", async (req: Request, res: Response) => {
  const { id } = req.params;
  try {
    const customer = await getCustomerById(id);
    if (customer) {
      res.json(customer);
    } else {
      res.status(404).json({ message: "Customer not found" });
    }
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

router.put("/:id", (req: Request, res: Response) => {
  const { error, value } = customerSchema.validate(req.body, { abortEarly: false });
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const { id } = req.params;
  const { name, phone_number, email, address, gender } = req.body;

  updateCustomer(id, { name, phone_number, email, address, gender })
    .then(() =>
      res.status(200).json({
        status: "success",
        message: "Customer updated successfully"
      })
    )
    .catch((error) => {
      const err = error as Error;
      res.status(500).json({ message: err.message });
    });
});

router.delete("/:id", async (req: Request, res: Response) => {
  const { id } = req.params;
  try {
    const result = await deleteCustomer(id);
    if (result) {
      res.status(200).json({ status: "success", message: "Customer deleted successfully" });
    } else {
      res.status(404).json({ message: "Customer not found" });
    }
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

export default router;
