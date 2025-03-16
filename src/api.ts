import express, { Router } from "express";
import cors, { CorsOptions } from "cors";
import compression from "compression";
import authRoutes from "./modules/auth/routes";
import TransactionRoutes from "./modules/transaction/routes";
import customerRoutes from "./modules/customer/routes";
import serviceRoutes from "./modules/services/routes";
import durationRoutes from "./modules/duration/routes";
import paymentRoutes from "./modules/payments/routes";
import emailSupport from "./modules/email-support/routes";
import notesRoutes from "./modules/notes/routes";
import users from "./modules/user/routes";
import reportRoutes from "./modules/report/routes";
import authMiddleware from "./middlewares";
import cookieParser from "cookie-parser";

const app = express();
const environment = process.env.NODE_ENV || "development";
const PORT = 3000;

// Validate environment variables
if (!process.env.API_URL) {
  console.error("Critical environment variables are missing.");
  process.exit(1);
}

// CORS configuration
const allowedOrigins = [
  "https://store.cucibayargo.com",
  "https://cucibayargo.com",
];

const corsOptions: CorsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.log(`Blocked by CORS: ${origin}`);
    }
  },
  credentials: true,
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(compression());
app.use(cookieParser());

// Routes setup
const routerV1 = Router();
routerV1.use("/auth", authRoutes);
routerV1.use(authMiddleware);
routerV1.use("/transaction", TransactionRoutes);
routerV1.use("/user", users);
routerV1.use("/customer", customerRoutes);
routerV1.use("/note", notesRoutes);
routerV1.use("/service", serviceRoutes);
routerV1.use("/duration", durationRoutes);
routerV1.use("/email-support", emailSupport);
routerV1.use("/payment", paymentRoutes);
routerV1.use("/report", reportRoutes);

app.use("/v1/", routerV1);

// Start HTTP server
app.listen(PORT, () => {
  console.log(
    `Server running in ${environment} mode on http://localhost:${PORT}`
  );
});

export default app;
