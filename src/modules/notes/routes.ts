import express from "express";
import { noteSchema } from "./types";
import { addNote, GetNote, updateNote } from "./controller";
import { AuthenticatedRequest, resolveOutletId } from "../../middlewares";
import { formatJoiError } from "../../utils";

const router = express.Router();



router.get("/", async (req: AuthenticatedRequest, res) => {
  try {
    const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    const data = await GetNote(req.userId, outletId); // Ensure GetNote() returns a single note object
    if (Array.isArray(data)) {
      // If GetNote() returns an array, handle it appropriately, e.g., return the first item
      res.json(data[0] || null);
    } else {
      res.json(data);
    }
  } catch (error) {
    const err = error as Error; // Type assertion
    res.status(500).json({ message: err.message });
  }
});

router.put("/", async (req: AuthenticatedRequest, res) => {
  if (!req.body || typeof req.body !== "object") {
    return res.status(400).json({
      errors: [
        {
          type: "body",
          msg: "Isi permintaan hilang atau tidak valid",
        },
      ],
    });
  }

  const { error, value } = noteSchema.validate(req.body, { abortEarly: false });
  if (error) {
    const message = formatJoiError(error);
    return res.status(400).json({ message: message });
  }

  const { notes } = req.body;

  try {
    const outletId = resolveOutletId(req, req.body?.outlet_id || (req.query.outlet_id as string | undefined));
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    // Attempt to get the latest note
    const latestNote = await GetNote(req.userId, outletId);

    if (latestNote) {
      // Update the latest note
      const updatedNote = await updateNote(latestNote.id, { notes }, req.userId, outletId);
      res.status(200).json({
        status: "success",
        message: "Catatan berhasil diubah",
        data: updatedNote,
      });
    } else {
      // Create a new note
      await addNote({ notes }, req.userId, outletId);
      res.status(201).json({
        status: "success",
        message: "Catatan berhasil dibuat"
      });
    }
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

export default router;
