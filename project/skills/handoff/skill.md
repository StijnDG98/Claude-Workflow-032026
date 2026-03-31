---
name: handoff
description: Capture current session state to planning/SESSION_HANDOFF.md. Run at end of session or before long breaks.
disable-model-invocation: false
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

## Session Handoff

Capture the current session state so the next session can pick up where this one left off.

### Gather state

1. Current branch: `git branch --show-current`
2. Latest commit: `git log --oneline -1`
3. Modified files: `git status --short`
4. Active plan: most recently modified `.md` in `planning/`
5. Compile status: result of last `/compile` or "not run this session"
6. Check `planning/todo.md` for any open items

### Write to `planning/SESSION_HANDOFF.md`

```markdown
# Session Handoff

**Date:** YYYY-MM-DD
**Branch:** `<branch>` (commit `<hash>`)
**Last verified:** <compile status>

## What's Done
- <completed items with specifics>

## What's In Progress
- <current work, state of implementation>

## What Didn't Work
- <failed approaches with exact error messages>

## What's Next
- <ordered list of next tasks>

## Blockers
- <anything preventing progress>
```