# Claude Code Workflow Infrastructure

A production-ready workflow setup for Claude Code with agents, skills, hooks, and a teamlead-driven development pipeline.

## What's included

### Agents (10)

| Agent | Role | Model |
|-------|------|-------|
| **teamlead** | Primary dispatcher, routes tasks, manages escalation | opus |
| **planner** | Research, plan features, review execution results (read-only) | opus |
| **executor** | Implement approved plans in isolated worktrees | inherit |
| **reviewer** | Code review with >80% confidence threshold | sonnet |
| **secretary** | Audit and update project documentation | haiku |
| **build-resolver** | Fix compilation errors (max 2 attempts) | sonnet |
| **security-reviewer** | _Prepared_ — activate for security-sensitive work | opus |
| **e2e-runner** | _Prepared_ — activate when UI exists to test | sonnet |
| **ux-reviewer** | _Prepared_ — activate for UI design review | sonnet |
| **integration-tester** | _Prepared_ — activate for integration testing | sonnet |

### Skills (11 project-level + 4 user-level)

**Project-level:**
- `/compile` — Build with correct flags
- `/launch` — Start IDE in dev mode
- `/verify` — Full verification suite (compile + lint)
- `/plan` — Create standardized plan files
- `/todo` — Timestamped note capture
- `/handoff` — Session state capture
- `/dogfood` — Workflow self-assessment
- `/review-execution` — Plan adherence review
- `vscode-patterns` — Auto-loads architecture reference (non-invocable)
- `claude-integration-patterns` — _Prepared_ stub
- `security-check` — _Prepared_ stub

**User-level (installed to `~/.claude/skills/`):**
- `/plan` — Portable plan creation
- `/handoff` — Portable session handoff
- `/todo` — Portable quick notes
- `/bootstrap` — Interactive project setup wizard

### Hooks (11)

- **Config protection** — blocks edits to linter/tsconfig files
- **No-verify blocker** — prevents `--no-verify` flag usage
- **Git push gate** — warns on push to main/master
- **Console.log scanner** — warns about debug statements
- **Entry point warning** — warns when editing workbench entry points
- **Markdown guard** — blocks .md writes outside designated dirs
- **Compaction save** — saves state before context compaction
- **Compaction restore** — restores state on session start
- **Stop reminder** — reminds to compile/handoff on session end
- **Pattern capture** — evaluates reusable patterns on stop
- **Desktop notification** — cross-platform permission prompt alerts

## Installation

```bash
git clone https://github.com/StijnDG98/Claude-Workflow-032026.git
cd Claude-Workflow-032026
./install.sh /path/to/your/project
```

The installer will:
1. Copy agents to `.claude/agents/`
2. Copy skills to `.claude/skills/`
3. Install settings.json with all hooks
4. Create directory structure (`planning/`, `.claude/agent-memory/`, etc.)
5. Install user-level skills to `~/.claude/skills/`

## Post-installation

1. Copy `templates/CLAUDE.md.template` to your project root as `CLAUDE.md`
2. Fill in the `{{placeholders}}` with your project info
3. Customize build/test/lint commands in `.claude/skills/compile/` and `.claude/skills/verify/`
4. Add `.claude/settings.local.json` and `.claude/compaction-state.md` to `.gitignore`
5. Start a Claude Code session and try `/plan` to create your first plan!

## Workflow overview

```
User request
  → Teamlead (dispatches)
    → Planner (designs) → creates plan file
    → Executor (builds) → in isolated worktree
      → Reviewer (gates quality) → runs /verify
        → Secretary (updates docs)
          → SHIP
```

The plan file is the contract. Actions authorized in the active plan do not require additional confirmation.

## Customization

### Build commands
Edit `.claude/skills/compile/skill.md` and `.claude/skills/verify/skill.md` to match your project's build system.

### Hook profiles
The settings.json includes all hooks. Remove any that don't apply to your project. The essential ones are:
- Config protection
- No-verify blocker
- Compaction save/restore

### Agent models
Adjust `model:` in agent frontmatter based on your preferences and budget.

## License

MIT
