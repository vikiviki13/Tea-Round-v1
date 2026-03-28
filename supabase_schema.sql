-- ============================================================
--  TeaRound Pro — Supabase Schema
--  Run this entire file in: Supabase → SQL Editor → New Query
-- ============================================================


-- ── 1. TABLES ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
  id           TEXT PRIMARY KEY,
  username     TEXT UNIQUE NOT NULL,   -- stored lowercase for unique constraint
  display_name TEXT,                   -- original casing shown in UI (e.g. "Viki")
  password     TEXT NOT NULL,
  role         TEXT NOT NULL DEFAULT 'user',   -- 'user' | 'admin'
  joined       TEXT,                   -- display string, e.g. "28/3/2026"
  avatar_color TEXT,                   -- hex colour used as fallback avatar bg
  avatar_url   TEXT,                   -- base64 data-URI or public URL
  bio          TEXT NOT NULL DEFAULT '',
  theme        TEXT NOT NULL DEFAULT 'dark'
    CHECK (theme IN ('dark','light','warm','neon','ocean','rose','forest'))
);

CREATE TABLE IF NOT EXISTS shops (
  id         TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  address    TEXT,
  creator_id TEXT NOT NULL,
  menu       JSONB NOT NULL DEFAULT '[]'::jsonb
);

CREATE TABLE IF NOT EXISTS sessions (
  id         TEXT PRIMARY KEY,
  shop_id    TEXT NOT NULL,
  creator_id TEXT NOT NULL,
  location   TEXT,
  locked     BOOLEAN NOT NULL DEFAULT FALSE,
  closed     BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS orders (
  id          TEXT PRIMARY KEY,
  session_id  TEXT NOT NULL,
  user_id     TEXT NOT NULL,
  user_name   TEXT NOT NULL,
  item_id     TEXT NOT NULL,
  item_name   TEXT NOT NULL,
  price       NUMERIC(10,2) NOT NULL DEFAULT 0,
  quantity    INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
  note        TEXT NOT NULL DEFAULT ''
);


-- ── 2. INDEXES (performance) ─────────────────────────────────
-- Plain indexes on the join columns (no FK constraints needed)

CREATE INDEX IF NOT EXISTS idx_shops_creator     ON shops(creator_id);
CREATE INDEX IF NOT EXISTS idx_sessions_shop     ON sessions(shop_id);
CREATE INDEX IF NOT EXISTS idx_sessions_creator  ON sessions(creator_id);
CREATE INDEX IF NOT EXISTS idx_orders_session    ON orders(session_id);
CREATE INDEX IF NOT EXISTS idx_orders_user       ON orders(user_id);


-- ── 3. ROW LEVEL SECURITY ────────────────────────────────────
--  The app uses the anon key for all operations, so we allow
--  everything through RLS rather than relying on auth.uid().
--  Tighten these policies later if you add Supabase Auth.

ALTER TABLE users    ENABLE ROW LEVEL SECURITY;
ALTER TABLE shops    ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders   ENABLE ROW LEVEL SECURITY;

-- Drop policies first so re-running this file is idempotent
DROP POLICY IF EXISTS "allow_all" ON users;
DROP POLICY IF EXISTS "allow_all" ON shops;
DROP POLICY IF EXISTS "allow_all" ON sessions;
DROP POLICY IF EXISTS "allow_all" ON orders;

CREATE POLICY "allow_all" ON users    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON shops    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON sessions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON orders   FOR ALL USING (true) WITH CHECK (true);


-- ── 4. REALTIME ──────────────────────────────────────────────
--  Enable Postgres realtime publication for all four tables
--  so the app's setupRealtime() subscriptions fire correctly.

-- Create the publication if it doesn't exist yet
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime'
  ) THEN
    CREATE PUBLICATION supabase_realtime;
  END IF;
END
$$;

ALTER PUBLICATION supabase_realtime ADD TABLE users;
ALTER PUBLICATION supabase_realtime ADD TABLE shops;
ALTER PUBLICATION supabase_realtime ADD TABLE sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE orders;


-- ── 5. HELPER: reset all data (dev use only) ─────────────────
--  Uncomment and run if you want to wipe everything cleanly:
--
-- TRUNCATE orders, sessions, shops, users RESTART IDENTITY CASCADE;


-- ── DONE ─────────────────────────────────────────────────────
--  Tables:     users · shops · sessions · orders
--  RLS:        enabled on all four (allow_all for anon key)
--  Realtime:   all four tables published
--  Indexes:    creator/session/user foreign keys indexed
-- ─────────────────────────────────────────────────────────────
