---
name: compile
description: Run the project build command. Use after any code changes. Reports errors with file paths and line numbers.
disable-model-invocation: false
allowed-tools: Bash
---

Run the project build:

```bash
# CUSTOMIZE: Replace with your project's build command
npm run build 2>&1 | tail -100
```

Report the result:
- If 0 errors: "Compilation passed."
- If errors: list each error with file path and line number. Fix type errors first — they cascade.
