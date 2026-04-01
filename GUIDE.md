# Claude Code Workflow Guide

A complete walkthrough for setting up and using this workflow system. Covers installation, daily usage, and what each component does and why.

---

## Table of Contents

1. [What is this?](#what-is-this)
2. [Installation](#installation)
3. [Your first session](#your-first-session)
4. [Daily workflow](#daily-workflow)
5. [Component reference](#component-reference)
   - [Agents](#agents)
   - [Skills (slash commands)](#skills-slash-commands)
   - [Hooks (automated guardrails)](#hooks-automated-guardrails)
   - [Memory system](#memory-system)
   - [Planning and archive](#planning-and-archive)
6. [Multi-app workflow](#multi-app-workflow)
7. [Customization](#customization)
8. [FAQ](#faq)

---

## What is this?

This is a workflow system for Claude Code that adds:

- **A team of AI agents** that specialize in different tasks (planning, coding, reviewing, documentation)
- **Slash commands** for common actions (`/compile`, `/handoff`, `/plan`)
- **Automated guardrails** that prevent common mistakes (pushing to main, leaving console.logs, skipping git hooks)
- **Persistent memory** so knowledge survives across sessions instead of being lost every time the context resets
- **Structured planning** with plan files, archive management, and session handoff

Without this, Claude Code is a single agent that forgets everything between sessions and has no guardrails. With this, it becomes a coordinated team with memory and safety nets.

---

## Installation

### New project

```bash
git clone https://github.com/StijnDG98/Claude-Workflow-032026.git
cd Claude-Workflow-032026
./install.sh /path/to/your/project
```

### Existing project

Same command. The installer will:
1. Back up your existing `.claude/settings.json` (if any)
2. Copy agents, skills, and hooks into `.claude/`
3. Create `planning/` and `.claude/agent-memory/` directories
4. Install user-level skills to `~/.claude/skills/`

If you already have a `.claude/agents/` or `.claude/skills/` directory, the installer copies files alongside existing ones -- it won't delete anything.

### Post-install steps

1. **Create your CLAUDE.md** -- Copy `templates/CLAUDE.md.template` to your project root as `CLAUDE.md` and fill in the placeholders:
   - `{{PROJECT_NAME}}` -- your project name
   - `{{PROJECT_DESCRIPTION}}` -- one-line description
   - `{{TECH_STACK}}` -- languages, frameworks, build tools (use a table)
   - `{{BUILD_COMMAND}}` -- e.g. `npm run build`, `cargo build`
   - `{{TEST_COMMAND}}` -- e.g. `npm test`, `pytest`
   - `{{LINT_COMMAND}}` -- e.g. `npm run lint`, `cargo clippy`
   - `{{RUN_COMMAND}}` -- e.g. `npm run dev`, `cargo run`
   - `{{GOTCHAS}}` -- project-specific pitfalls (add these as you discover them)

2. **Customize build commands** -- Edit `.claude/skills/compile/skill.md` and `.claude/skills/verify/skill.md` to match your project's actual build/test/lint commands.

3. **Create SESSION_HANDOFF.md** -- Create `planning/SESSION_HANDOFF.md` with a basic starting state:
   ```markdown
   # Session Handoff

   **Date:** YYYY-MM-DD
   **Branch:** `main`
   **Last verified:** not yet

   ## What's In Progress
   - Initial project setup

   ## What's Next
   - Start first feature

   ## Blockers
   - None
   ```

4. **Update .gitignore** -- Add:
   ```
   .claude/settings.local.json
   ```

5. **Commit the workflow files** -- Everything in `.claude/` and `planning/` should be committed so your whole team (or your future self) has the same setup.

### Alternative: use /bootstrap

If you have the user-level skills installed, you can skip the manual steps above. Open Claude Code in your project and type:

```
/bootstrap
```

The bootstrap wizard will detect your project type, ask your experience level, and set everything up interactively.

---

## Your first session

Once installed, start Claude Code in your project directory. CLAUDE.md and SESSION_HANDOFF.md load automatically -- you don't need to do anything special.

### Try these to get started:

**Create a plan:**
```
I want to add [feature]. Have the planner research and create a plan.
```

**Execute a plan:**
```
The plan looks good, execute it.
```

**Check your work:**
```
/compile
```

**End the session:**
```
/handoff
```

That's it. The system handles routing (which agent does what), memory (saving knowledge), and guardrails (catching mistakes) automatically.

---

## Daily workflow

### Starting a session

Just tell Claude what you want to do. CLAUDE.md and SESSION_HANDOFF.md are always loaded, so it knows the project context and where you left off.

```
continue where we left off
```

or jump straight in:

```
let's implement the user authentication
```

### Planning

Tell Claude to plan something. It routes to the planner agent, which researches and creates a plan file.

```
use the teamlead to plan the authentication system
```

or more casually:

```
I want to add login. Have the planner figure out how to do it.
```

The planner creates a file at `planning/<feature-name>.md` with research, steps, and acceptance criteria. Review it before approving execution.

### Executing

Once a plan looks good:

```
the plan looks good, execute it
```

The teamlead routes to the executor, which implements the plan. After execution, the reviewer automatically checks the work, and the secretary updates documentation.

### During development

```
/compile          # check for build errors
/verify           # full check: compile + lint + tests
```

If something breaks, just describe the problem. The teamlead will route to the right agent (build-resolver for compile errors, executor for code fixes).

### Ending a session

```
/handoff          # saves session state
commit and push   # persist everything
```

### Switching tasks

```
/clear            # resets context, reloads CLAUDE.md fresh
```

Then describe the new task. The `/clear` prevents context from one task bleeding into another.

### Finding old knowledge

Agents check their own memory automatically. If you want to search for older context:

```
check if we've researched this before
```

or point at the archive directly:

```
look in the memory archive for anything about authentication
```

---

## Component reference

### Agents

Agents are specialized AI personas with defined roles, tools, and models. They run as subagents -- Claude spawns them for specific tasks and relays the results back to you with a `**[agent-name]**` prefix so you know who's talking.

| Agent | What it does | When it runs |
|-------|-------------|-------------|
| **teamlead** | Routes tasks to the right agent, manages escalation | When you describe a task -- it decides who handles it |
| **planner** | Researches, designs plans, reviews execution results | New features, architecture decisions, investigation |
| **executor** | Writes code, implements approved plans | After a plan is approved |
| **reviewer** | Reviews code quality, runs `/verify` | Automatically after executor finishes |
| **secretary** | Audits docs, manages memory and archive | After execution, or when docs need updating |
| **build-resolver** | Fixes compilation errors (max 2 attempts) | When builds break -- delegated by executor |

**Prepared agents** (activate when needed):

| Agent | What it does | When to activate |
|-------|-------------|-----------------|
| **security-reviewer** | Reviews security implications | When touching APIs, auth, external comms |
| **e2e-runner** | Runs end-to-end tests | When you have UI to test |
| **ux-reviewer** | Reviews UI patterns and accessibility | When building user interfaces |
| **integration-tester** | Tests service integrations | When connecting systems |

**Why agents instead of one Claude?** Each agent has focused instructions, appropriate tools, and the right model for its job. A reviewer doesn't need write access. A secretary doesn't need an expensive model. The teamlead coordinates so you don't have to manually direct each one.

**The verification loop:** After the executor finishes, the teamlead automatically sends the work through a quality pipeline:

```
Executor finishes
  -> Reviewer checks code + runs /verify
     -> Pass: Secretary updates docs -> SHIP
     -> Fail: Teamlead evaluates and routes to the right fix agent
        -> Compile error: build-resolver (2 tries) -> executor
        -> Code quality: executor (2 tries) -> planner
        -> Architecture: planner (3 tries) -> YOU (fresh eyes needed)
```

### Skills (slash commands)

Skills are shortcuts you type in Claude Code. They expand into full prompts that Claude follows.

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/compile` | Runs your build command with correct flags | After making code changes |
| `/verify` | Full verification: compile + lint + tests | Before committing or as a final check |
| `/handoff` | Saves session state to `SESSION_HANDOFF.md` | Before ending a session or switching chats |
| `/plan` | Creates a new plan file with all required sections | Starting a new feature or task |
| `/todo` | Appends a timestamped note to `planning/todo.md` | Quick capture of ideas or reminders |
| `/launch` | Starts your app in dev mode | Testing your changes |
| `/dogfood` | Self-assessment of the workflow | After a few sessions, to evaluate what's working |
| `/review-execution` | Checks if an implementation follows its plan | After executing a plan |

**Non-invocable skills** (load automatically when relevant):
- `vscode-patterns` -- architecture reference, loads when editing VS Code contributions
- `claude-integration-patterns` -- prepared stub for future use
- `security-check` -- prepared stub for future use

**User-level skills** (available in all projects, installed to `~/.claude/skills/`):

| Command | What it does |
|---------|-------------|
| `/plan` | Same as project-level, works in any project |
| `/handoff` | Same as project-level, works in any project |
| `/todo` | Same as project-level, works in any project |
| `/bootstrap` | Interactive wizard that sets up the workflow in a new project |

### Hooks (automated guardrails)

Hooks run automatically in the background. You don't invoke them -- they fire on specific events and either warn you, block dangerous actions, or run maintenance tasks.

**Before a tool runs (PreToolUse):**

| Hook | What it does | Why |
|------|-------------|-----|
| Config protection | Blocks edits to `.eslintrc`, `tsconfig.json`, `.editorconfig` | Prevents "fixing" linter errors by changing the rules instead of the code |
| Markdown guard | Blocks `.md` writes outside `planning/`, `.claude/`, or root docs | Prevents random documentation files from appearing everywhere |
| No-verify blocker | Blocks `--no-verify` flag on git commands | Prevents bypassing git hooks -- fix the underlying issue instead |
| Git push gate | Warns when pushing directly to `main` or `master` | Catches accidental pushes to the main branch |

**After a tool runs (PostToolUse):**

| Hook | What it does | Why |
|------|-------------|-----|
| Console.log scanner | Warns when `console.log` is detected in changed files | Catches debug statements before they get committed |

**Before context compaction (PreCompact):**

| Hook | What it does | Why |
|------|-------------|-----|
| Compaction snapshot | Captures branch, commit, and modified files | Gives Claude a snapshot before memory is compressed |
| Memory save prompt | Tells Claude to save important findings to agent memory | Prevents knowledge loss during compaction -- the key to persistent memory |

**On session start (SessionStart):**

| Hook | What it does | Why |
|------|-------------|-----|
| Compact restore | Reminds Claude that SESSION_HANDOFF.md is loaded and where memory files are | Smooth resumption after compaction |

**When Claude stops (Stop):**

| Hook | What it does | Why |
|------|-------------|-----|
| Uncommitted changes reminder | Warns if source files changed since last commit | Prevents losing work by forgetting to commit |
| Rule capture prompt | Asks Claude to evaluate if the session produced reusable rules | Captures patterns that should become permanent instructions in CLAUDE.md |

**On permission prompt (Notification):**

| Hook | What it does | Why |
|------|-------------|-----|
| Desktop notification | Shows a system notification when Claude needs your approval | So you don't miss permission prompts while doing other things |

### Memory system

The memory system has three layers. Each layer serves a different purpose and loads at a different time.

**Layer 1: Session state** -- `planning/SESSION_HANDOFF.md`
- **What:** Current task, next steps, blockers
- **Loads:** Every session (auto-loaded via `@` import in CLAUDE.md)
- **Updated by:** `/handoff` skill or PreCompact hook
- **Purpose:** Session continuity -- what's happening right now

**Layer 2: Agent memory** -- `.claude/agent-memory/<agent>.md`
- **What:** Facts, findings, workarounds, failed approaches
- **Loads:** Only when that specific agent runs (doesn't eat main context)
- **Updated by:** Agents write their own memory; PreCompact hook triggers a save
- **Purpose:** Knowledge persistence -- what agents have learned

**Layer 3: Cold archive** -- `planning/memory-archive.md`
- **What:** Old agent memory entries that are no longer immediately relevant but might be useful later
- **Loads:** Only on demand, when you or an agent explicitly searches it
- **Updated by:** Secretary agent during memory validation audits
- **Purpose:** Long-term storage -- knowledge that's not active but shouldn't be lost

**Why three layers?** Without this, Claude loses everything when the context compacts or you start a new session. Session state tells it where you left off. Agent memory tells it what it learned. The archive prevents old knowledge from being deleted entirely. Together, they solve the knowledge degradation problem where each session summary loses fidelity until the original findings are gone.

### Planning and archive

**Plan files** live in `planning/` and follow a standard format (created by `/plan`):
- Context, research, step-by-step plan, open questions
- Execution log and "what didn't work" sections (appended during execution)
- Review section with verdict: SHIP / NEEDS WORK / BLOCKED

**The archive** at `planning/archive/` stores completed plans and superseded docs:

```
planning/archive/
  <topic>/                         <- phase name or feature group
    plan.md                        <- phase-level files at the top
    execution-log.md
    <YYYY-MM>/                     <- date subfolder when multiple files from same period
      feature-plan.md
      feature-execution-log.md
```

Each archived file has a header: `> Archived: YYYY-MM-DD | <reason>`

The secretary manages archival -- it moves completed plans to the right folder, validates memory entries, and keeps the archive organized.

---

## Multi-app workflow

You can split work across Claude Code apps. The repo files are the shared state.

### Planning in Claude Code (CLI or web)

Best for: research, architecture discussions, plan review. You don't need an IDE for this.

1. Discuss and plan with the teamlead/planner
2. Review the generated plan file
3. Run `/handoff` and commit/push

### Execution in VS Code / IDE with Claude Code extension

Best for: implementation. You can see files changing in real-time, use the terminal, and run the app.

1. Pull the latest changes
2. Say "continue where we left off" or "execute the plan at `@planning/<plan>.md`"
3. Claude reads SESSION_HANDOFF.md (auto-loaded) and picks up where you left off
4. Code, compile, review -- all within the IDE

### The handoff

The only rule: **commit and push before switching apps.** That's what carries the session state, agent memory, and plan files to the other environment.

---

## Customization

### Build commands

Edit these skills to match your project:
- `.claude/skills/compile/skill.md` -- your build command
- `.claude/skills/verify/skill.md` -- your full verification suite (build + lint + tests)
- `.claude/skills/launch/skill.md` -- your dev/run command

### Removing hooks you don't need

Edit `.claude/settings.json` and remove hook entries that don't apply. The essential ones to keep:
- Config protection (prevents linter config changes)
- No-verify blocker (prevents skipping git hooks)
- PreCompact memory save (prevents knowledge loss)
- Stop reminder (prevents forgetting to commit)

Everything else is optional.

### Agent models

Each agent has a `model:` field in its frontmatter. Adjust based on your preferences and budget:
- `opus` -- most capable, best for planning and complex decisions
- `sonnet` -- good balance of capability and speed
- `haiku` -- fast and cheap, good for simple tasks like doc auditing
- `inherit` -- uses whatever model the parent is running

### Adding project-specific hooks

Add entries to `.claude/settings.json` under the appropriate event. See the existing hooks for the format. Common additions:
- Entry point warnings (files that are dangerous to edit)
- File size guards
- Import restrictions

### Adding new agents

Create a `.md` file in `.claude/agents/` with frontmatter:

```yaml
---
name: my-agent
description: What this agent does and when to use it.
tools: Read, Glob, Grep, Bash
model: sonnet
memory: project
---
```

Add it to the teamlead's agent manifest and tool list so it can be dispatched.

---

## FAQ

**Do I need to manually call agents?**
No. The teamlead routes automatically. Just describe what you want in natural language. You'll see `**[agent-name]**` prefixes showing which agent handled each part.

**What if I don't want the full pipeline for a small change?**
Just make the change directly. The workflow scales -- small changes skip the planner entirely. The teamlead adjusts the quality gates based on change size.

**Will the hooks slow me down?**
No. They run in milliseconds. You'll only notice them when they catch something (which is the point).

**Can I use this without the teamlead?**
Yes. You can talk to any agent directly: "use the planner to research X" or "have the reviewer check these changes." The teamlead is a convenience, not a requirement.

**What if an agent gives bad results?**
The escalation ladder handles this automatically. If an agent fails twice, the work escalates to a higher-level agent. After 3 planner cycles, it surfaces to you for fresh eyes.

**How much context does this use?**
CLAUDE.md and SESSION_HANDOFF.md load every session (usually under 2K tokens combined). Agent memory only loads when that agent runs. The archive never loads unless you ask for it. Hooks are defined in settings.json and don't cost context tokens.

**Can I use this on Claude Code web (claude.ai/code)?**
Yes. All project-level files (agents, skills, hooks) are in the repo and work everywhere. A SessionStart hook can auto-restore user-level skills from the repo if they're missing locally.

**What gets committed to git?**
Everything in `.claude/` (agents, skills, settings.json) and `planning/` (plans, session handoff, archive, memory archive). Agent memory files in `.claude/agent-memory/` are also committed -- they're meant to be shared.

**Can I share this with my team?**
Yes. Since everything is in the repo, anyone who clones it gets the same agents, skills, hooks, and memory. Run `./install.sh` to set up the user-level skills on a new machine.
