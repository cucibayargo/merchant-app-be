-- ============================================================
-- v17.sql — Cuci Karpet: layanan per-m² dan rincian ukuran per item
--
-- 1. service.is_carpet menandai layanan yang dihargai per meter persegi.
--    service_duration.price lalu dibaca sebagai "harga per m²" dan unit
--    dipaksa 'm²' oleh API. Default false agar layanan lama dan client
--    lama tidak berubah perilaku.
-- 2. transaction_item.dimensions menyimpan snapshot ukuran karpet yang
--    diukur merchant: [{"length":2.5,"width":1.2}, ...]. qty tetap berisi
--    luas yang ditagih (kolomnya sudah double precision), jadi perhitungan
--    uang tidak berubah. NULL untuk item non-karpet dan semua baris lama.
--
-- Idempotent dan aman dijalankan ulang.
-- ============================================================

BEGIN;

ALTER TABLE service
  ADD COLUMN IF NOT EXISTS is_carpet boolean NOT NULL DEFAULT false;

ALTER TABLE transaction_item
  ADD COLUMN IF NOT EXISTS dimensions jsonb;

-- Jaga bentuk data: NULL (non-karpet / legacy) atau sebuah JSON array.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'transaction_item_dimensions_is_array'
  ) THEN
    ALTER TABLE transaction_item
      ADD CONSTRAINT transaction_item_dimensions_is_array
      CHECK (dimensions IS NULL OR jsonb_typeof(dimensions) = 'array');
  END IF;
END $$;

-- Tidak ada backfill: layanan lama harus tampil apa adanya. Kalau nanti
-- diminta menandai layanan m² yang sudah ada, jalankan manual:
-- UPDATE service SET is_carpet = true
--  WHERE lower(trim(unit)) IN ('m2', 'm²', 'meter persegi');

COMMIT;
