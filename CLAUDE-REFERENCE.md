# Claude Code Reference — MMW 2026 Directory

Quick reference for all commands, skills, agents, hooks, and rules available in this project.

---

## Custom Project Commands

These are unique to this repo. Run them by typing the command in Claude Code.

| Command | What it does | Arguments |
|---------|-------------|-----------|
| `/sync-project` | Re-analyze the codebase and update CLAUDE.md, contributor profiles, and shared decisions | `--full` (default), `--docs`, `--contributors`, `--shared` |

---

## Codebase Analysis (Understand Anything)

Analyze, explore, and explain this codebase using an AI-powered knowledge graph.

| Command | What it does | Arguments |
|---------|-------------|-----------|
| `/understand` | Full codebase analysis → generates knowledge graph | `--full` (rebuild), `[directory]` (scope) |
| `/understand-dashboard` | Launch interactive visual dashboard for the knowledge graph | `[project-path]` |
| `/understand-chat` | Ask questions about the codebase using the knowledge graph | `[your question]` |
| `/understand-explain` | Deep explanation of a specific file or component | `[file-path]` |
| `/understand-diff` | Analyze current git changes against the knowledge graph | — |
| `/understand-onboard` | Generate onboarding guide for new contributors | — |

---

## Feature Development (Feature Dev)

Guided feature development workflow with architecture-first approach.

| Command | What it does |
|---------|-------------|
| `/feature-dev:feature-dev` | Start the guided feature dev workflow (discovery → architecture → implementation) |

**Sub-agents** (dispatched automatically during feature dev):

| Agent | Role |
|-------|------|
| `code-explorer` | Traces execution paths and maps architecture layers |
| `code-architect` | Designs implementation blueprints with specific files and data flows |
| `code-reviewer` | Reviews for bugs, security, quality — confidence-filtered |

---

## Development Workflow (Superpowers)

Structured skills for planning, building, debugging, and shipping.

### Planning & Design
| Command | When to use |
|---------|------------|
| `/superpowers:writing-plans` | Before multi-step tasks — write a comprehensive implementation plan |
| `/superpowers:executing-plans` | Execute a written plan in a separate session with review checkpoints |
| `/superpowers:brainstorming` | Before any creative work — features, components, behavior changes |

### Building
| Command | When to use |
|---------|------------|
| `/superpowers:test-driven-development` | Before writing implementation code — tests first |
| `/superpowers:subagent-driven-development` | Execute plans with independent tasks in parallel |
| `/superpowers:dispatching-parallel-agents` | 2+ independent tasks that don't share state |
| `/superpowers:using-git-worktrees` | Isolate feature work from current workspace |

### Quality & Review
| Command | When to use |
|---------|------------|
| `/superpowers:systematic-debugging` | Before proposing fixes for bugs, test failures, unexpected behavior |
| `/superpowers:requesting-code-review` | After completing features, before merging |
| `/superpowers:receiving-code-review` | When acting on review feedback — verify before blindly implementing |
| `/superpowers:verification-before-completion` | Before claiming work is done — evidence before assertions |

### Shipping
| Command | When to use |
|---------|------------|
| `/superpowers:finishing-a-development-branch` | Implementation complete, tests pass — decide: merge, PR, or cleanup |
| `/superpowers:writing-skills` | Creating or editing custom skills |

---

## UI Components (shadcn)

Available when working with shadcn/ui components. The skill auto-triggers when relevant.

| Action | How |
|--------|-----|
| Add components | `npx shadcn@latest add button card dialog` |
| Search registry | `npx shadcn@latest search -q "table"` |
| View before install | `npx shadcn@latest view button` |
| Init new project | `npx shadcn@latest init -t next` |

---

## Code Quality

| Command / Agent | What it does |
|----------------|-------------|
| `/simplify` | Review changed code for reuse, quality, and efficiency |
| `code-simplifier` agent | Simplifies and refines code for clarity and maintainability |

---

## Setup & Configuration

| Command | What it does |
|---------|-------------|
| `/update-config` | Modify Claude Code settings via natural language (hooks, permissions, env vars) |
| `/claude-code-setup:claude-automation-recommender` | Analyze codebase and recommend Claude Code automations |

---

## Automated Hooks

These run automatically — no commands needed. Configured in `.claude/settings.json`.

### Session Lifecycle
| When | What happens |
|------|-------------|
| **Session starts** | Detects contributor via `whoami`, loads profile from `.claude/contributors/`, initializes memory timer |
| **Every 20 min** | Memory checkpoint — Claude evaluates if preferences, decisions, or context should be saved |
| **Session ends** | Final memory checkpoint opportunity |

### Git Safety
| When | What happens |
|------|-------------|
| **Before `git push` to main** | Warning: "This is Caleb's production repo. Consider pushing to staging instead." |
| **After `git commit`** | Memory checkpoint — evaluates if commit-related decisions should be persisted |

### Deploy
| When | What happens |
|------|-------------|
| **After `vercel deploy`** | Automatically prints the preview URL |

---

## Project Agents

Agents can be dispatched by Claude or invoked directly.

| Agent | Purpose | Model |
|-------|---------|-------|
| `memory-keeper` | Consolidates session learnings into contributor profiles and shared decisions | Sonnet |
| `knowledge-graph-guide` | Helps navigate and understand the Understand-Anything knowledge graph | Inherited |
| `code-simplifier` | Refines code for clarity while preserving functionality | Opus |
| `code-explorer` | Deep analysis of existing features, execution paths, dependencies | Sonnet |
| `code-architect` | Designs feature architecture with implementation blueprints | Sonnet |
| `code-reviewer` | Reviews code for bugs, security, quality (confidence-filtered) | Sonnet |

---

## Contributor System

Claude adapts to each team member based on profiles in `.claude/contributors/`.

| File | Purpose |
|------|---------|
| `adamtday.md` | Adam's preferences, skills, workflow, Vercel setup |
| `calebgardnerdev.md` | Caleb's profile — repo owner, production deployer |
| `_shared.md` | Team decisions log with timestamps |

New contributors get auto-detected at session start and profiled after their first meaningful interaction.

---

## File Locations

```
.claude/
├── settings.json              # Hooks, plugins, project config
├── settings.local.json        # Local overrides (not committed)
├── rules/
│   ├── contributor-detection.md   # How Claude identifies team members
│   └── memory-management.md       # When and what to save to memory
├── contributors/
│   ├── adamtday.md            # Adam's profile
│   ├── calebgardnerdev.md     # Caleb's profile
│   └── _shared.md             # Shared team decisions
├── agents/
│   └── memory-keeper.md       # Memory consolidation agent
└── skills/
    └── sync-project.md        # Manual docs/rules refresh command

CLAUDE.md                      # Main orientation doc for Claude
CLAUDE-REFERENCE.md            # This file
```

---

## Quick Cheat Sheet

```bash
# Sync docs after pulling changes
/sync-project

# Analyze the full codebase
/understand

# Ask about the code
/understand-chat How does the going list work?

# Start building a feature
/feature-dev:feature-dev

# Plan before coding
/superpowers:writing-plans

# Debug something broken
/superpowers:systematic-debugging

# Deploy a preview
vercel deploy

# Check what changed upstream
git fetch origin && git log --oneline origin/main --not main
```
