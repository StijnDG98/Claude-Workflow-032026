#!/bin/bash
set -e

# Claude Code Workflow Installer
# Usage: ./install.sh [/path/to/project]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
USER_CLAUDE_DIR="$HOME/.claude"

echo "Claude Code Workflow Installer"
echo "================================"
echo "Project: $PROJECT_DIR"
echo ""

# Project-level files
echo "[1/5] Installing project agents..."
mkdir -p "$PROJECT_DIR/.claude/agents"
cp -r "$SCRIPT_DIR/project/agents/"* "$PROJECT_DIR/.claude/agents/"
echo "  -> 10 agents installed"

echo "[2/5] Installing project skills..."
mkdir -p "$PROJECT_DIR/.claude/skills"
cp -r "$SCRIPT_DIR/project/skills/"* "$PROJECT_DIR/.claude/skills/"
echo "  -> 11 skills installed"

echo "[3/5] Installing settings and hooks..."
if [ -f "$PROJECT_DIR/.claude/settings.json" ]; then
  echo "  WARNING: .claude/settings.json already exists -- backed up to settings.json.bak"
  cp "$PROJECT_DIR/.claude/settings.json" "$PROJECT_DIR/.claude/settings.json.bak"
fi
cp "$SCRIPT_DIR/project/settings.json" "$PROJECT_DIR/.claude/settings.json"
echo "  -> 11 hooks + permissions installed"

echo "[4/5] Creating directory structure..."
mkdir -p "$PROJECT_DIR/.claude/agent-memory"
mkdir -p "$PROJECT_DIR/.claude/worktrees"
mkdir -p "$PROJECT_DIR/planning"
touch "$PROJECT_DIR/.claude/agent-memory/.gitkeep"
touch "$PROJECT_DIR/.claude/worktrees/.gitkeep"
if [ ! -f "$PROJECT_DIR/planning/todo.md" ]; then
  printf '# TODO\n\nTimestamped notes. Append-only.\n' > "$PROJECT_DIR/planning/todo.md"
fi
echo "  -> directories created"

echo "[5/5] Installing user-level skills..."
mkdir -p "$USER_CLAUDE_DIR/skills"
for skill in plan handoff todo bootstrap; do
  mkdir -p "$USER_CLAUDE_DIR/skills/$skill"
  cp "$SCRIPT_DIR/user/skills/$skill/skill.md" "$USER_CLAUDE_DIR/skills/$skill/skill.md"
done
echo "  -> 4 user skills installed to $USER_CLAUDE_DIR/skills/"

echo ""
echo "Done! Next steps:"
echo "  1. Copy templates/CLAUDE.md.template to $PROJECT_DIR/CLAUDE.md"
echo "  2. Fill in the {{placeholders}} with your project info"
echo "  3. Customize build/test/lint commands in .claude/skills/compile/ and .claude/skills/verify/"
echo "  4. Add .claude/settings.local.json and .claude/compaction-state.md to .gitignore"
echo "  5. Start a Claude Code session and try /plan to create your first plan!"