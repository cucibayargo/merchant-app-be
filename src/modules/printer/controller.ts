import pool from "../../database/postgres";
import { PrintedDevice } from "./types";

/**
 * Get all printed devices by user.
 * @param {string} user_id - ID user pemilik printer.
 * @returns {Promise<PrintedDevice[]>}
 */
export async function getAllPrintedDevices(user_id: string): Promise<PrintedDevice[]> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT *
      FROM printed_devices
      WHERE user_id = $1
      ORDER BY is_active DESC NULLS LAST;
    `;
    const result = await client.query(query, [user_id]);
    return result.rows;
  } finally {
    client.release();
  }
}

/**
 * Get one printed device by ID.
 * @param {string} id - UUID dari device.
 * @returns {Promise<PrintedDevice | null>}
 */
export async function getPrintedDeviceById(id: string): Promise<PrintedDevice | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `SELECT * FROM printed_devices WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

/**
 * Add a new printed device.
 * @param device - Data device tanpa ID (auto-generate).
 * @returns {Promise<PrintedDevice>}
 */
export async function addPrintedDevice(device: Omit<PrintedDevice, "id" | "last_connected_at">): Promise<PrintedDevice> {
  const client = await pool.connect();
  try {
    const { user_id, device_name, alias_name, device_id, is_active } = device;

    // jika device diset aktif, matikan device lain milik user ini
    if (is_active) {
      await client.query(`UPDATE printed_devices SET is_active = false WHERE user_id = $1`, [user_id]);
    }

    const query = `
      INSERT INTO printed_devices (user_id, device_name, alias_name, device_id, is_active, last_connected_at)
      VALUES ($1, $2, $3, $4, $5, NOW())
      RETURNING *;
    `;
    const values = [user_id, device_name, alias_name, device_id, is_active];
    const result = await client.query(query, values);
    return result.rows[0];
  } catch (error: any) {
    // Tangani error PostgreSQL
    if (error.code === "23505") {
      throw new Error("Data yang Anda masukkan sudah ada.");
    }

    // Error lain
    console.error(error);
    throw new Error("Terjadi kesalahan pada server.");
  } finally {
    client.release();
  }
}

/**
 * Update an existing printed device.
 * @param {string} id - UUID dari device.
 * @param device - Data yang diupdate.
 * @returns {Promise<PrintedDevice>}
 */
export async function updatePrintedDevice(id: string, device: Partial<Omit<PrintedDevice, "id">>): Promise<PrintedDevice> {
  const client = await pool.connect();
  try {
    const existing = await client.query(`SELECT * FROM printed_devices WHERE id = $1`, [id]);
    if (existing.rowCount === 0) {
      throw new Error("Device not found");
    }

    const current = existing.rows[0];
    const {
      user_id = current.user_id,
      device_name = current.device_name,
      alias_name = current.alias_name,
      device_id = current.device_id,
      is_active = current.is_active,
    } = device;

    // hanya satu yang aktif per user
    if (is_active) {
      await client.query(`UPDATE printed_devices SET is_active = false WHERE user_id = $1`, [user_id]);
    }

    const query = `
      UPDATE printed_devices
      SET user_id = $1,
          device_name = $2,
          alias_name = $3,
          device_id = $4,
          is_active = $5,
          last_connected_at = NOW()
      WHERE id = $6
      RETURNING *;
    `;
    const result = await client.query(query, [user_id, device_name, alias_name, device_id, is_active, id]);
    return result.rows[0];
  } finally {
    client.release();
  }
}

/**
 * Delete a printed device.
 * @param {string} id - UUID dari device yang ingin dihapus.
 */
export async function deletePrintedDevice(id: string): Promise<void> {
  const client = await pool.connect();
  try {
    await client.query(`DELETE FROM printed_devices WHERE id = $1`, [id]);
  } finally {
    client.release();
  }
}
