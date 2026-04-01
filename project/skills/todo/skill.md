---
name: todo
description: Quick note capture. Appends a timestamped entry to planning/todo.md. Preserves raw text exactly — no summarizing, no formatting.
disable-model-invocation: true
allowed-tools: Read, Edit
---

## Quick Note Capture

Append the user's text to `planning/todo.md` with an ISO timestamp prefix.

### Rules

- Preserve the text EXACTLY as given — no summarizing, no reformatting, no editing
- Prefix with timestamp: `- [YYYY-MM-DDTHH:MM] <text>`
- Append only — never edit or remove existing entries
- If the file doesn't exist, create it with the header: `# TODO\n\nTimestamped notes. Append-only.\n`
