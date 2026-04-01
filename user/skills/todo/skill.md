---
name: todo
description: Quick note capture. Appends timestamped entry to planning/todo.md. Works across any project.
disable-model-invocation: true
allowed-tools: Read, Edit
---

## Quick Note Capture

Append the user's text to `planning/todo.md` with an ISO timestamp prefix.

### Rules

- Preserve the text EXACTLY as given
- Prefix with timestamp: `- [YYYY-MM-DDTHH:MM] <text>`
- Append only — never edit or remove existing entries
- If the file doesn't exist, create it with the header: `# TODO\n\nTimestamped notes. Append-only.\n`