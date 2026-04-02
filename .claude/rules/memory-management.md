# Memory Management Rules

This project uses per-contributor memory to build persistent context across sessions. Memories live in two places:
- **`.claude/contributors/{name}.md`** — per-person profile, preferences, current focus (checked into repo, team-visible)
- **`~/.claude/projects/.../memory/`** — private auto-memory (personal to each machine, not shared)

## When to Save Memory

### Save immediately (don't wait)
- User explicitly asks to remember something
- A new integration, tool, or service is configured
- A workflow or deployment process changes
- User corrects your approach — save as feedback with the reason
- User confirms a non-obvious approach worked — save what was validated
- A decision is made about architecture, data model, or conventions

### Save at natural breakpoints
- After a feature is completed (what was built, any gotchas)
- After a deploy to staging or production (what was shipped)
- After a PR is created or merged (scope and outcome)
- After resolving a non-trivial bug (root cause, not the fix itself — the fix is in git)
- When switching between major areas of work

### Save during extended sessions (checkpoint trigger)
After ~15-20 minutes of active work OR after 5+ file modifications, pause and evaluate:
- Have any contributor preferences been revealed that aren't yet documented?
- Were any project decisions made that future sessions need to know?
- Is there context about current work-in-progress that would be lost?

To track this, check the **session memory marker**. If the file `/tmp/claude-memory-{project-hash}` is older than 20 minutes or doesn't exist, it's time to evaluate. Update the marker after each check.

### Do NOT save
- Code patterns or file structure derivable from reading the codebase
- Git history or who-changed-what (`git log` is authoritative)
- Debugging steps or fix recipes (the fix is in the code)
- Anything already in CLAUDE.md
- Ephemeral task state only useful in the current conversation
- Routine operations (file reads, searches, test runs)

## What to Save Where

| Content | Location | Why |
|---------|----------|-----|
| Contributor preferences, habits, skill level | `.claude/contributors/{name}.md` | Team-visible, helps all Claude sessions adapt |
| Shared architectural decisions | `.claude/contributors/_shared.md` | Team context, not tied to one person |
| Private observations about workflow | `~/.claude/projects/.../memory/` | Personal, machine-specific |
| Feedback/corrections from user | Both contributor profile AND auto-memory | Profile for team, memory for this machine |

## Memory Hygiene
- Before writing a new memory, check if an existing one should be updated instead
- Remove or update memories that are contradicted by current state
- Keep contributor profiles focused — they should fit in ~50 lines
- Timestamp entries in `_shared.md` so stale decisions are visible
