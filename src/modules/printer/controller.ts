import pool from "../../database/postgres";
import { PrintedDevice } from "./types";

/**
 * Get all printed devices by user.
 * @param {string} user_id - ID user pemilik printer.
 * @returns {Promise<PrintedDevice[]>}
 */
export async function getAllPrintedDevices(
  user_id: string,
  outlet_id?: string | null
): Promise<PrintedDevice[]> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT *
      FROM printed_devices
      WHERE user_id = $1
        AND ($2::uuid IS NULL OR outlet_id = $2)
      ORDER BY is_active DESC NULLS LAST;
    `;
    const result = await client.query(query, [user_id, outlet_id || null]);
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
export async function getPrintedDeviceById(
  id: string,
  user_id: string,
  outlet_id?: string | null
): Promise<PrintedDevice | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
        SELECT *
        FROM printed_devices
        WHERE id = $1
          AND user_id = $2
          AND ($3::uuid IS NULL OR outlet_id = $3)
      `,
      [id, user_id, outlet_id || null]
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
    const { user_id, outlet_id, device_name, alias_name, device_id, is_active } = device;

    // jika device diset aktif, matikan device lain milik user ini
    if (is_active) {
      await client.query(`UPDATE printed_devices SET is_active = false WHERE user_id = $1`, [user_id]);
    }

    const query = `
      INSERT INTO printed_devices (user_id, outlet_id, device_name, alias_name, device_id, is_active, last_connected_at)
      VALUES ($1, $2, $3, $4, $5, $6, NOW())
      RETURNING *;
    `;
    const values = [user_id, outlet_id || null, device_name, alias_name, device_id, is_active];
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
export async function updatePrintedDevice(
  id: string,
  user_id: string,
  outlet_id: string | null,
  device: Partial<Omit<PrintedDevice, "id">>
): Promise<PrintedDevice> {
  const client = await pool.connect();
  try {
    const existing = await client.query(
      `
        SELECT *
        FROM printed_devices
        WHERE id = $1
          AND user_id = $2
          AND ($3::uuid IS NULL OR outlet_id = $3)
      `,
      [id, user_id, outlet_id || null]
    );
    if (existing.rowCount === 0) {
      throw new Error("Device not found");
    }

    const current = existing.rows[0];
    const {
      user_id: next_user_id,
      outlet_id: next_outlet_id,
      device_name,
      alias_name,
      device_id,
      is_active,
    } = device;

    const target_user_id = next_user_id ?? current.user_id;
    const target_outlet_id = next_outlet_id ?? current.outlet_id;
    const target_device_name = device_name ?? current.device_name;
    const target_alias_name = alias_name ?? current.alias_name;
    const target_device_id = device_id ?? current.device_id;
    const target_is_active = is_active ?? current.is_active;

    // hanya satu yang aktif per user
    if (target_is_active) {
      await client.query(`UPDATE printed_devices SET is_active = false WHERE user_id = $1`, [target_user_id]);
    }

    const query = `
      UPDATE printed_devices
      SET user_id = $1,
          outlet_id = $2,
          device_name = $3,
          alias_name = $4,
          device_id = $5,
          is_active = $6,
          last_connected_at = NOW()
      WHERE id = $7
      RETURNING *;
    `;
    const result = await client.query(query, [
      target_user_id,
      target_outlet_id || null,
      target_device_name,
      target_alias_name,
      target_device_id,
      target_is_active,
      id,
    ]);
    return result.rows[0];
  } finally {
    client.release();
  }
}

/**
 * Delete a printed device.
 * @param {string} id - UUID dari device yang ingin dihapus.
 */
export async function deletePrintedDevice(
  id: string,
  user_id: string,
  outlet_id: string | null
): Promise<void> {
  const client = await pool.connect();
  try {
    await client.query(
      `
        DELETE FROM printed_devices
        WHERE id = $1
          AND user_id = $2
          AND ($3::uuid IS NULL OR outlet_id = $3)
      `,
      [id, user_id, outlet_id || null]
    );
  } finally {
    client.release();
  }
}
