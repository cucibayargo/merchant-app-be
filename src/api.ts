import express from "express";
import cors, { CorsOptions } from "cors";
import cookieParser from "cookie-parser";
import compression from "compression";
import session from "express-session";
import passport from "./modules/auth/passportConfig";
import routes from "./routes";

const app = express();

// Validate environment variables
if (!process.env.SESSION_SECRET || !process.env.API_URL) {
  console.error("Critical environment variables are missing.");
  process.exit(1);
}

const corsOptions: CorsOptions = {
  origin: (origin, callback) => {
    // Allow any origin dynamically
    callback(null, true);
  },
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization", "invoice-token"],
  credentials: true,
};

app.use(cors(corsOptions));
app.use(cookieParser());
app.use(express.json());
app.use(compression());

// Session configuration
app.use(
  session({
    secret: process.env.SESSION_SECRET!,
    resave: false,
    saveUninitialized: false,
  })
);

// Initialize Passport
app.use(passport.initialize());
app.use(passport.session());

// Use centralized routes
app.use("/api/", routes);

export default app;
