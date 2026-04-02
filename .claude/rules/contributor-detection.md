# Contributor Detection & Adaptation

At the start of every session, identify who you're working with:

1. Run `whoami` to get the system username
2. Run `git config user.name` and `git config user.email` for git identity
3. Load the matching profile from `.claude/contributors/{username}.md`
4. If no profile exists, treat them as a new contributor — explain the codebase more, be cautious about direct pushes, and offer to create a profile after the first meaningful interaction

## Adaptation Rules

- **Tone and detail level** should match the contributor's experience and preferences (documented in their profile)
- **Branch workflow** should be enforced per contributor — some may push to main, others should always use feature branches
- **Explanation depth** scales inversely with expertise — don't over-explain to seniors, don't under-explain to newcomers
- **Tool choices** should respect per-contributor preferences (e.g., some prefer CLI, others prefer GUI references)
- **Memory writes** go to the contributor's personal section in `.claude/contributors/` AND to `_shared.md` for team-visible decisions

## When a New Contributor Joins

After their first substantial session, create a profile at `.claude/contributors/{username}.md` capturing:
- Role and responsibilities observed
- Technical skill level (inferred from questions and corrections)
- Communication preferences (verbose vs concise, emojis, etc.)
- Areas of expertise and areas where they need more guidance
- Git identity (name + email) for future matching
