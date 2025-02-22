import express, { Request, Response, NextFunction, Router } from "express";
import swaggerJsdoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";
import cors, { CorsOptions } from 'cors';
import cookieParser from 'cookie-parser';
import compression from 'compression';
import session from "express-session";
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
import passport from "./modules/auth/passportConfig";
import authMiddleware from "./middlewares";

const app = express();
const environment = process.env.NODE_ENV || 'development';
const PORT = 3000;

// Validate environment variables
if (!process.env.SESSION_SECRET || !process.env.API_URL) {
  console.error("Critical environment variables are missing.");
  process.exit(1);
}

// CORS configuration
const allowedOrigins = environment === 'production'
  ? ['https://store.cucibayargo.com', 'https://cucibayargo.com']
  : ['https://stg-store.cucibayargo.com', 'https://stg.cucibayargo.com', 'http://localhost:3000'];

const corsOptions: CorsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
};

app.use(cors(corsOptions));
app.use(cookieParser());
app.use(express.json());
app.use(compression());

// Session configuration
app.use(session({
  secret: process.env.SESSION_SECRET!,
  resave: false,
  saveUninitialized: false,
}));

// Initialize Passport
app.use(passport.initialize());
app.use(passport.session());

// Middleware for debugging
app.use((req: Request, res: Response, next: NextFunction) => {
  next();
});

// Swagger configuration
const swaggerServerUrl = environment === 'production'
  ? process.env.API_URL || 'https://api.cucibayargo.com'
  : 'http://localhost:3000/v1';

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Kasir Laundry Pro",
      version: "1.0.0",
      description: "API Routes and schema details of Kasir Laundry Pro Services",
    },
    servers: [{ url: swaggerServerUrl }],
  },
  apis: ["./src/modules/**/*.ts"],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
const routerV1 = Router();

routerV1.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));
routerV1.use("/docs-json", (req: Request, res: Response) => {
  res.json(swaggerSpec);
});

// Routes setup
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
  console.log(`Server running in ${environment} mode on http://localhost:${PORT}`);
});

export default app;
