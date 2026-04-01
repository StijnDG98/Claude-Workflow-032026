---
name: review-execution
description: Review an executor's implementation against its plan file. Check adherence, acceptance criteria, deviations. Produces SHIP / NEEDS WORK / BLOCKED verdict.
disable-model-invocation: true
context: fork
agent: planner
---

## Execution Review

Review the executor's implementation against the approved plan.

### Steps

1. Read the plan file (path will be provided or find the most recently modified plan in `planning/`)
2. Read the execution log appended to the plan
3. For each plan step, verify:
   - Was it implemented as specified?
   - Were the acceptance criteria met?
   - Are there deviations? If so, were they justified?
4. Check the "What Didn't Work" section
5. Run `/verify` if not already done

### Verdict

Append a review section to the plan file:

```markdown
## Review

**Date:** YYYY-MM-DD
**Reviewer:** planner (via /review-execution)

### Plan adherence
- [step-by-step assessment]

### Acceptance criteria
- [which passed, which failed]

### Verdict: SHIP / NEEDS WORK / BLOCKED

### Notes
- [anything for next time]
```
