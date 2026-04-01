---
name: handoff
description: Capture current session state to planning/SESSION_HANDOFF.md. Run at end of session or before starting a fresh chat. Captures session state only — research and findings go in agent memory.
disable-model-invocation: false
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

## Session Handoff

Capture the current session state so the next session can pick up where this one left off. This is for **session continuity only** — not for preserving knowledge (that goes in agent memory files).

### Gather state

1. Current branch: `git branch --show-current`
2. Latest commit: `git log --oneline -1`
3. Modified files: `git status --short`
4. Active plan: most recently modified `.md` in `planning/` (excluding SESSION_HANDOFF.md)
5. Build status: result of last build or "not run this session"

### Write to `planning/SESSION_HANDOFF.md`

```markdown
# Session Handoff

**Date:** YYYY-MM-DD
**Branch:** `<branch>` (commit `<hash>`)
**Last verified:** <build status>

## What's In Progress
- <current task with specific state — not vague, exact details someone needs to continue>

## What's Next
- <ordered list of immediate next steps>

## Blockers
- <anything preventing progress>
```

Keep it short and specific. No research findings, no architectural knowledge, no history of what was done. Just: what's happening now, what's next, what's blocked.

### Before finishing

Remind the user: "Research findings and important facts should be in agent memory (.claude/agent-memory/). Run the secretary agent if you want to ensure memory is up to date."
