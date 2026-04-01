---
name: verify
description: Full verification suite — build, lint, test. Use at checkpoints and before marking work as done.
disable-model-invocation: false
allowed-tools: Bash
---

Run the full verification suite in order. Stop at the first failure.

**Step 1: Build**
```bash
# CUSTOMIZE: Replace with your build command
npm run build 2>&1 | tail -100
```

**Step 2: Lint** (only if build passed)
```bash
# CUSTOMIZE: Replace with your lint command
npm run lint 2>&1 | tail -50
```

**Step 3: Test** (only if lint passed)
```bash
# CUSTOMIZE: Replace with your test command
npm test 2>&1 | tail -50
```

Report combined results. If any step fails, report which step and the errors.
