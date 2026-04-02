---
name: sync-project
description: Re-analyze the codebase and update CLAUDE.md, contributor profiles, and shared decisions to reflect current state
argument-hint: [--full | --docs | --contributors | --shared]
---

# /sync-project

Manually refresh all Claude orientation files based on the current state of the codebase. Run this after pulling changes, adding integrations, changing workflows, or whenever things feel stale.

## Scope Options

- `$ARGUMENTS` may contain:
  - `--full` — Update everything (default if no argument given)
  - `--docs` — Only update CLAUDE.md
  - `--contributors` — Only update contributor profiles
  - `--shared` — Only update _shared.md decisions log

If no argument is provided, run a full sync.

---

## Step 1 — Gather Current State

Collect the facts needed to detect drift between docs and reality:

1. **Codebase snapshot**:
   - Read `index.html` lines 1-30 (meta/head for event count, title changes)
   - Count events: `grep -c '"name":' index.html` (approximate EVENTS array size)
   - Check for new files: `git ls-files` vs what CLAUDE.md documents
   - Check for new Supabase tables or schema changes in `supabase-schema.sql`

2. **Git state**:
   - `git log --oneline -10` — recent commits since last sync
   - `git branch -a` — active branches
   - `git remote -v` — remotes

3. **Configuration state**:
   - Read `.claude/settings.json` — hooks, plugins, env vars
   - Read `~/.claude/settings.json` — global permissions, env vars
   - Check Vercel link status: `cat .vercel/project.json 2>/dev/null`

4. **Current docs**:
   - Read `CLAUDE.md`
   - Read `.claude/contributors/_shared.md`
   - Read the current contributor's profile from `.claude/contributors/$(whoami).md`

## Step 2 — Identify Drift

Compare gathered state against documented state. Look for:

- Event count mismatch (CLAUDE.md says X, codebase has Y)
- New files not mentioned in CLAUDE.md
- New features in index.html not documented (search for new function definitions, new CSS classes, new data fields)
- Schema changes in supabase-schema.sql not reflected in docs
- New or removed hooks/plugins in settings.json
- Branch or deploy workflow changes
- New contributors (git log authors not in .claude/contributors/)
- Stale information (documented features that no longer exist)

## Step 3 — Update Files

Only update sections that have drifted. Do NOT rewrite files that are already accurate.

### CLAUDE.md Updates
- Update event count if changed
- Update event schema if fields were added/removed
- Add new features to Key Features section
- Update line number ranges if they shifted significantly (>20 lines)
- Update Supabase section if schema changed
- Update any URLs, branch names, or deploy commands that changed
- Preserve the `<!-- VERCEL BEST PRACTICES -->` block untouched (auto-managed by Vercel CLI)

### Contributor Profile Updates
- Add new git authors as starter profiles in `.claude/contributors/`
- Update "Current Focus" and "Last active" for the current contributor
- Do NOT modify other contributors' preference sections — only they should change those

### Shared Decisions Updates
- Append any new architectural or workflow decisions discovered in recent commits
- Timestamp all new entries
- Do NOT remove old entries — they're historical context

## Step 4 — Report

Output a summary table:

```
| File | Status | Changes |
|------|--------|---------|
| CLAUDE.md | Updated | Event count 198→205, added promo field docs |
| contributors/adamtday.md | Updated | Current focus updated |
| contributors/_shared.md | No changes | Already current |
```

If nothing needed updating, say so: "All docs are current — no drift detected."
