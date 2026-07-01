/**
 * sync-scheduler.ts
 *
 * Runs the old->v2 sync on a cron schedule using node-cron, with a mutex so a
 * slow run never overlaps the next tick. Intended to run as its own process
 * (separate from the API), e.g. a small always-on worker.
 *
 * Env:
 *   SYNC_CRON   cron expression, default '*\/5 * * * *' (every 5 minutes)
 */

import cron from "node-cron";
import * as dotenv from "dotenv";
import { runSyncOnce } from "./sync-old-to-v2";

dotenv.config();

const SCHEDULE = process.env.SYNC_CRON || "*/5 * * * *";

let running = false;

async function tick() {
  if (running) {
    console.log("[scheduler] previous run still in progress, skipping tick");
    return;
  }
  running = true;
  try {
    await runSyncOnce();
  } catch (err) {
    console.error("[scheduler] sync run failed", err);
  } finally {
    running = false;
  }
}

if (!cron.validate(SCHEDULE)) {
  console.error(`[scheduler] invalid SYNC_CRON: ${SCHEDULE}`);
  process.exit(1);
}

console.log(`[scheduler] starting, schedule='${SCHEDULE}'`);
cron.schedule(SCHEDULE, tick);

// Kick off one run immediately on boot so we don't wait a full interval.
tick();
