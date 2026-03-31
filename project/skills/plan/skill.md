---
name: plan
description: Create a new planning document with the standardized format. Generates the file in the correct location with all required sections.
disable-model-invocation: true
allowed-tools: Read, Write, Glob
---

## Create Plan File

Create a new plan file at the correct location with all required sections.

### Steps

1. Ask for: feature name (if not provided)
2. Create file at `planning/<feature-name>.md`
3. Populate with this template:

```markdown
# <Feature Name>

## Context
What exists now, why this change is needed.

## Research
What was discovered, options considered, key files involved.

## Plan
Step-by-step implementation with acceptance criteria per step.
Each step should be verifiable. Include:
- Exact file paths to create or modify
- Which existing patterns to follow
- Expected gotchas
- Verification criteria

Pre-flight: branch name, expected files modified, verification criteria, known risks.

## Open Questions
Things needing resolution before/during execution.

## Execution Log
_(Appended by executor)_

## What Didn't Work
_(Appended by executor — failed approaches with exact error messages)_

## Review
_(Appended by planner/reviewer — verdict: SHIP / NEEDS WORK / BLOCKED)_
```