import { Router } from "express";

// Import middlewares
import authMiddleware from "../middlewares";

// Import all module routes
import authRoutes from "../modules/auth/routes";
import transactionRoutes from "../modules/transaction/routes";
import customerRoutes from "../modules/customer/routes";
import serviceRoutes from "../modules/services/routes";
import durationRoutes from "../modules/duration/routes";
import printerRoutes from "../modules/printer/routes";
import paymentRoutes from "../modules/payments/routes";
import emailSupportRoutes from "../modules/email-support/routes";
import notesRoutes from "../modules/notes/routes";
import userRoutes from "../modules/user/routes";
import reportRoutes from "../modules/report/routes";
import expanseRoutes from "../modules/expanse/routes";

const router = Router();

// Public routes
router.use("/auth", authRoutes);

// Protected routes
router.use(authMiddleware);
router.use("/transaction", transactionRoutes);
router.use("/user", userRoutes);
router.use("/customer", customerRoutes);
router.use("/note", notesRoutes);
router.use("/service", serviceRoutes);
router.use("/duration", durationRoutes);
router.use("/printer", printerRoutes);
router.use("/email-support", emailSupportRoutes);
router.use("/payment", paymentRoutes);
router.use("/report", reportRoutes);
router.use("/expanse", expanseRoutes);

export default router;
