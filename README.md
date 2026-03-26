# ☕ TeaRound Pro

> Effortless group tea & coffee orders — a Progressive Web App for office teams.

---

## 🚀 Deployment Guide

### Prerequisites
- A [GitHub](https://github.com) account
- A [Supabase](https://supabase.com) account (free tier works)
- A [Vercel](https://vercel.com) or [Netlify](https://netlify.com) account (free)

---

## STEP 1 — Set Up Supabase Database

1. Go to [https://supabase.com](https://supabase.com) → **New Project**
2. Fill in:
   - **Project name:** `tearound-pro`
   - **Database password:** *(save this somewhere)*
   - **Region:** Choose nearest to you (e.g., `ap-south-1` for India)
3. Wait ~2 minutes for the project to be ready
4. Go to **SQL Editor** → **New Query**
5. Copy the entire content of `supabase_schema.sql` and paste it → click **Run**
6. You should see: *"Success. No rows returned"*
7. Go to **Settings → API** and note:
   - **Project URL** (looks like `https://xxxx.supabase.co`)
   - **anon/public key** (long string starting with `eyJ...`)

---

## STEP 2 — Configure the App with Your Supabase Keys

Open `index.html` in a text editor and find this section near the top of the `<script>` tag:

```js
// ── SUPABASE CONFIG ──────────────────────────────────────────
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

Replace the values:
```js
const SUPABASE_URL = 'https://abcdefghij.supabase.co';   // your actual URL
const SUPABASE_ANON_KEY = 'eyJhbGci...';                  // your actual key
```

Save the file.

---

## STEP 3 — Push to GitHub

### Option A — GitHub Website (No terminal needed)

1. Go to [https://github.com/new](https://github.com/new)
2. Repository name: `tearound-pro`
3. Set to **Public** or **Private** → click **Create repository**
4. On the next page, click **uploading an existing file**
5. Drag and drop ALL files from this folder:
   - `index.html`
   - `manifest.json`
   - `sw.js`
   - `supabase_schema.sql`
   - `.gitignore`
   - `README.md`
6. Write commit message: `Initial commit` → click **Commit changes**

### Option B — Git CLI

```bash
cd tearound-pro

git init
git add .
git commit -m "Initial commit: TeaRound Pro"

# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/tearound-pro.git
git branch -M main
git push -u origin main
```

---

## STEP 4 — Deploy to Vercel (Recommended — Free)

1. Go to [https://vercel.com](https://vercel.com) → Sign in with GitHub
2. Click **Add New → Project**
3. Find and select your `tearound-pro` repo → click **Import**
4. Leave all settings as default (no build command needed)
5. Click **Deploy**
6. In ~30 seconds you'll get a live URL like: `https://tearound-pro.vercel.app` 🎉

### OR Deploy to Netlify

1. Go to [https://netlify.com](https://netlify.com) → Sign in with GitHub
2. Click **Add new site → Import an existing project**
3. Connect GitHub → select `tearound-pro`
4. Leave all settings default → click **Deploy site**
5. Live in ~1 minute!

---

## STEP 5 — Test Your Live App

1. Open your live URL
2. Register a new account (first user becomes admin)
3. Create a shop with a menu
4. Start a tea round session
5. Share the join code with teammates

---

## 📱 Install as Mobile App (PWA)

- **Android Chrome:** Tap the 3-dot menu → *Add to Home Screen*
- **iOS Safari:** Tap the Share icon → *Add to Home Screen*
- **Desktop Chrome:** Click the install icon in the address bar

---

## 🗂 File Structure

```
tearound-pro/
├── index.html          ← Main app (all-in-one)
├── manifest.json       ← PWA manifest
├── sw.js               ← Service worker (offline support)
├── supabase_schema.sql ← Run this in Supabase SQL Editor
├── .gitignore
└── README.md
```

---

## 🔧 Tech Stack

- **Frontend:** Vanilla HTML/CSS/JS (no framework, no build step)
- **Database:** Supabase (PostgreSQL)
- **Hosting:** Vercel / Netlify
- **PWA:** Service Worker + Web Manifest

---

## ❓ Troubleshooting

| Problem | Fix |
|--------|-----|
| Data not saving | Check Supabase URL and anon key in index.html |
| RLS policy error | Re-run `supabase_schema.sql` in SQL Editor |
| App not loading offline | Open app once online first to cache assets |
| Service worker not registering | Must be served over HTTPS (Vercel/Netlify both do this) |
