import express from "express";
import { getPlanList } from "./controller";

const router = express.Router();

router.get("/", async (_req, res) => {
  try {
    const plans = await getPlanList();
    res.status(200).json({ plans });
  } catch (error) {
    console.error("Error fetching plan list:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

export default router;
