# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Miami Music Week 2026 curated event directory — a single-file static site (vanilla HTML/CSS/JS) with Supabase backend, deployed on Vercel. 198 events, March 24–29.

- **Production** (Caleb's): https://mmw-2026-directory.vercel.app
- **Staging preview** (Adam's): https://mmw-2026-directory-azure.vercel.app
- **Repo**: https://github.com/calebgardnerdev/mmw-2026-directory

## Development Workflow

No build system or package manager. Open `index.html` in a browser to develop.

### Git Branching
- **`main`** — Caleb's production branch. Do NOT push here without explicit confirmation.
- **`staging`** — Adam's working branch for previews and testing.
- Always work on `staging`. Merge to `main` only when ready for production.

### Deploying Previews (Adam's Vercel)
```bash
vercel deploy                    # preview URL (auto-scoped to adamtdays-projects)
```

### Deploying to Production (Caleb's Vercel — two commands required)
```bash
vercel deploy --prod --yes
vercel alias [DEPLOYMENT_URL] mmw-2026-directory.vercel.app
```

### Syncing with Caleb's Changes
```bash
git fetch origin
git log --oneline origin/main --not main   # see what's new
git checkout staging && git merge main      # merge into staging
```

### OG Image Regeneration (external tooling)
Python + Playwright screenshots `og-generator.html` → saves as `og.jpeg`.

## Architecture

Everything lives in `index.html` (~1182 lines) — HTML structure, CSS, event data, Supabase integration, and JS logic.

### Data Layer (all in index.html)
- **`EVENTS` array** (~line 312–511): 198 event objects with 17 fields
- **`FEATURED_ARTISTS` array** (~line 523): Featured names with green all-caps styling
- **`LINKED_NAMES` object** (~line 524–546): Maps artist/brand names → Instagram handles
- **`CATEGORIES` / `CAT_COLORS`** (~line 544–548): 9 event categories with color mappings

### Event Schema (17 fields)
```
name, date, start, end, venue, artists, category, free,
ticketUrl, rsvpUrl, donateUrl, radiate, credit, hidden,
multi, dayOf, totalDays
```

### Supabase Backend
- **Project**: `ipncdjcqgxbkprhcekfb` (config at ~line 554–558)
- **Tables**: `going_lists` (user attendance), `submitted_events` (user submissions), `event_attendance` (view: counts)
- **Schema**: `supabase-schema.sql` — run in Supabase SQL Editor to set up tables, indexes, and RLS policies
- **Auth**: Anonymous via client-side `device_id` (UUID in localStorage), no user accounts
- **Fallback**: All features degrade to localStorage if Supabase is unavailable

### State (6 globals)
- `activeDay` — selected day tab (ISO date or `'all'`)
- `activeCategories` — `Set` of selected category filters
- `searchQuery` — current search input text
- `goingList` — `Set` of event IDs the user is "going" to
- `customEvents` — array of user-submitted events
- `attendanceCounts` — object mapping event IDs → going counts from Supabase

### Key Features
- **Going list**: Users toggle attendance per event, synced to Supabase + localStorage. Shareable via URL. Attendance counts displayed on cards.
- **Live-now detection**: `isLiveNow()` compares event times in **Eastern Time (ET)**, refreshes every 60s. Red pulsing badge + border.
- **Time-aware UI**: Auto-selects today's tab, greys out past events, shows "Next Up" indicator.
- **Clickable venues**: All venues link to Google Maps with Miami geolocation.
- **Promo codes**: Copyable promo code badges with clipboard feedback.
- **User event submissions**: Modal form saves to localStorage + Supabase for review.
- **Search**: Case-insensitive substring match across name, artists, venue, category, hidden, credit. Capped at 100 chars.
- **Multi-day series**: Events with `multi`/`dayOf`/`totalDays` display series labels.
- **Instagram linking**: `highlightFeatured()` wraps LINKED_NAMES matches with `<a>` tags to Instagram profiles.
- **Radiate integration**: Orange gradient badges linking to Radiate festival app.

### Design System
- Dark theme: `#050505` background, `#CCFF00` lime accent
- 9 category colors via CSS custom properties (`--cat-*`)
- Responsive grid: 1 col → 2 col (640px) → 3 col (960px)
- Font: Inter (Google Fonts)

### Rendering Pipeline
`renderEvents()` is the main function — merges EVENTS + customEvents, filters by day → categories → search, builds HTML card grid. `renderTabs()` (includes "Going" tab) and `renderFilters()` generate navigation. All re-run on state change. `renderGoingTab()` handles the dedicated going list view.

## Editing Events

Add/modify entries in the `EVENTS` array (17-field schema above). To add Instagram links, also add entries to `LINKED_NAMES`. To feature an artist with green styling, add their name to `FEATURED_ARTISTS`.

## Collaboration

- **Caleb Gardner** (`calebgardnerdev`) — repo owner, production deployer
- **Adam Day** (`adamtday`) — collaborator with write access, uses `staging` branch
- Adam has a separate Vercel project (`adamtdays-projects`) for preview deployments
- Caleb's Vercel is not connected to GitHub auto-deploy; he deploys manually via CLI

## Hooks & Safety

Project-level hooks are configured in `.claude/settings.json`:
- **PreToolUse**: Warns before any `git push` to `main` (production safety guard)
- **PostToolUse**: Prints Vercel preview URL after `vercel deploy`

## Analytics

GoatCounter (privacy-focused, no cookies) — dashboard at `mmw2026.goatcounter.com`.

<!-- VERCEL BEST PRACTICES START -->
## Best practices for developing on Vercel

These defaults are optimized for AI coding agents (and humans) working on apps that deploy to Vercel.

- Treat Vercel Functions as stateless + ephemeral (no durable RAM/FS, no background daemons), use Blob or marketplace integrations for preserving state
- Edge Functions (standalone) are deprecated; prefer Vercel Functions
- Don't start new projects on Vercel KV/Postgres (both discontinued); use Marketplace Redis/Postgres instead
- Store secrets in Vercel Env Variables; not in git or `NEXT_PUBLIC_*`
- Provision Marketplace native integrations with `vercel integration add` (CI/agent-friendly)
- Sync env + project settings with `vercel env pull` / `vercel pull` when you need local/offline parity
- Use `waitUntil` for post-response work; avoid the deprecated Function `context` parameter
- Set Function regions near your primary data source; avoid cross-region DB/service roundtrips
- Tune Fluid Compute knobs (e.g., `maxDuration`, memory/CPU) for long I/O-heavy calls (LLMs, APIs)
- Use Runtime Cache for fast **regional** caching + tag invalidation (don't treat it as global KV)
- Use Cron Jobs for schedules; cron runs in UTC and triggers your production URL via HTTP GET
- Use Vercel Blob for uploads/media; Use Edge Config for small, globally-read config
- If Enable Deployment Protection is enabled, use a bypass secret to directly access them
- Add OpenTelemetry via `@vercel/otel` on Node; don't expect OTEL support on the Edge runtime
- Enable Web Analytics + Speed Insights early
- Use AI Gateway for model routing, set AI_GATEWAY_API_KEY, using a model string (e.g. 'anthropic/claude-sonnet-4.6'), Gateway is already default in AI SDK
  needed. Always curl https://ai-gateway.vercel.sh/v1/models first; never trust model IDs from memory
- For durable agent loops or untrusted code: use Workflow (pause/resume/state) + Sandbox; use Vercel MCP for secure infra access
<!-- VERCEL BEST PRACTICES END -->
