---
name: plan
description: Create a new planning document with the standardized format. Works across any project.
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

## Open Questions
Things needing resolution before/during execution.

## Execution Log
_(Appended by executor)_

## What Didn't Work
_(Appended by executor)_

## Review
_(Appended by reviewer)_
```
