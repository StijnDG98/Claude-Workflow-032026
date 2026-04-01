---
name: handoff
description: Capture current session state for the next session. Works across any project.
disable-model-invocation: false
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

## Session Handoff

Capture the current session state so the next session can pick up seamlessly.

### Gather state

1. Current branch: `git branch --show-current`
2. Latest commit: `git log --oneline -1`
3. Modified files: `git status --short`
4. Active plan: most recently modified `.md` in `planning/`
5. Build status: "not run this session" if unknown

### Write to `planning/SESSION_HANDOFF.md`

```markdown
# Session Handoff

**Date:** YYYY-MM-DD
**Branch:** `<branch>` (commit `<hash>`)
**Last verified:** <build status>

## What's Done
- <completed items>

## What's In Progress
- <current work>

## What Didn't Work
- <failed approaches with exact error messages>

## What's Next
- <ordered list>

## Blockers
- <anything preventing progress>
```
