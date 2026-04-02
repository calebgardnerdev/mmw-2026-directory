# Shared Project Decisions

Decisions that affect all contributors. Newest first.

## 2026-03-26 — Staging/Preview Workflow Established
- Adam uses `staging` branch for all work; merges to `main` for production
- Adam's Vercel previews deploy under `adamtdays-projects` scope
- Caleb's production Vercel is separate and manually deployed
- Push-to-main hook warns before accidental production pushes

## 2026-03-26 — Supabase Backend Added (by Caleb)
- Anonymous auth via client-side device_id (no user accounts)
- Going lists, event submissions, attendance counts
- All features degrade to localStorage if Supabase is down
- Schema in `supabase-schema.sql`

## 2026-03-26 — Single-File Architecture Decision
- Everything in `index.html` — intentional for zero dependencies, instant load, easy updates
- Any new features must go into the same file unless complexity demands separation
- This is a conscious trade-off, not tech debt
