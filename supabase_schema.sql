-- ============================================================
-- TeaRound Pro — Supabase Database Schema
-- Run this entire script in: Supabase > SQL Editor > New Query
-- ============================================================

-- 1. USERS TABLE
create table if not exists public.users (
  id          text primary key,
  username    text not null unique,
  password    text not null,
  role        text not null default 'user',
  joined      text,
  avatar_color text default '#00c896',
  bio         text default '',
  theme       text default 'dark',
  created_at  timestamptz default now()
);

-- 2. SHOPS TABLE
create table if not exists public.shops (
  id          text primary key,
  name        text not null,
  address     text,
  creator_id  text references public.users(id) on delete set null,
  menu        jsonb not null default '[]',
  created_at  timestamptz default now()
);

-- 3. SESSIONS TABLE
create table if not exists public.sessions (
  id          text primary key,
  shop_id     text references public.shops(id) on delete set null,
  creator_id  text references public.users(id) on delete set null,
  location    text,
  locked      boolean default false,
  closed      boolean default false,
  created_at  timestamptz default now()
);

-- 4. ORDERS TABLE
create table if not exists public.orders (
  id          text primary key,
  session_id  text references public.sessions(id) on delete cascade,
  user_id     text references public.users(id) on delete set null,
  user_name   text,
  item_id     text,
  item_name   text,
  price       numeric(10,2),
  quantity    integer default 1,
  note        text default '',
  created_at  timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS) — Enable for all tables
-- ============================================================

alter table public.users    enable row level security;
alter table public.shops    enable row level security;
alter table public.sessions enable row level security;
alter table public.orders   enable row level security;

-- ============================================================
-- POLICIES — Allow full public access (app handles auth logic)
-- For production you can tighten these with real auth.
-- ============================================================

-- Users: allow all reads and inserts
create policy "users_select" on public.users for select using (true);
create policy "users_insert" on public.users for insert with check (true);
create policy "users_update" on public.users for update using (true);
create policy "users_delete" on public.users for delete using (true);

-- Shops: allow all
create policy "shops_select" on public.shops for select using (true);
create policy "shops_insert" on public.shops for insert with check (true);
create policy "shops_update" on public.shops for update using (true);
create policy "shops_delete" on public.shops for delete using (true);

-- Sessions: allow all
create policy "sessions_select" on public.sessions for select using (true);
create policy "sessions_insert" on public.sessions for insert with check (true);
create policy "sessions_update" on public.sessions for update using (true);
create policy "sessions_delete" on public.sessions for delete using (true);

-- Orders: allow all
create policy "orders_select" on public.orders for select using (true);
create policy "orders_insert" on public.orders for insert with check (true);
create policy "orders_update" on public.orders for update using (true);
create policy "orders_delete" on public.orders for delete using (true);

-- ============================================================
-- DONE! Your TeaRound Pro database is ready.
-- ============================================================
