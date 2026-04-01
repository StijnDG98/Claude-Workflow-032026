---
name: bootstrap
description: Interactive project setup wizard. Installs workflow infrastructure (agents, skills, hooks) into any project. Adapts to user's experience level.
disable-model-invocation: false
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebSearch
---

## Project Bootstrap Wizard

Set up the Claude Code workflow infrastructure for a project.

### Step 1: Detect environment

- Check for existing `.claude/` directory
- Check for existing `CLAUDE.md`
- Detect project type (package.json, Cargo.toml, go.mod, etc.)
- Detect build system and test framework

### Step 2: Assess knowledge level

Ask: "How familiar are you with Claude Code workflows? (beginner / intermediate / advanced)"

- **Beginner:** Explain each component as you install it. Offer guided setup with defaults.
- **Intermediate:** Brief descriptions, ask for preferences on key choices.
- **Advanced:** Minimal prompts, install everything, let them customize after.

### Step 3: Install from template

Check if `~/.claude/templates/project-starter/` exists:
- If yes: use it as the source
- If no: create the structure from scratch using the patterns below

### Step 4: Customize

For each component, adapt to the detected project:

**CLAUDE.md:**
- Fill in project name from package.json/Cargo.toml/etc.
- Detect and fill build/test/lint commands
- Set up tech stack section

**Skills:**
- `/compile` → detect build command (npm run build, cargo build, go build, etc.)
- `/verify` → detect lint command + test command
- `/launch` → detect dev/run command

**Hooks:**
- All hooks from template, with project-specific paths in guards
- Config protection hook adapted to project's config files

**Agents:**
- All agents from template
- Build-resolver adapted to project's build system

### Step 5: Post-install

- Add `.claude/settings.local.json` and `.claude/compaction-state.md` to `.gitignore`
- Create `planning/` directory with empty `todo.md`
- Create initial `planning/SESSION_HANDOFF.md`
- Show summary of what was installed

### Beginner extras

If beginner:
- Explain the teamlead → planner → executor pipeline
- Explain what hooks do and which ones are active
- Suggest trying `/plan` to create their first plan
- Explain `/handoff` and why it matters
