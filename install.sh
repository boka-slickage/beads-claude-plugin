#!/bin/bash
# Install the Claude bd skill (manual method)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/bd"

echo "Installing Claude bd skill..."

# Create skills directory if needed
mkdir -p "$HOME/.claude/skills"

# Remove existing if present
if [ -d "$SKILL_DIR" ] || [ -L "$SKILL_DIR" ]; then
    echo "Removing existing bd skill..."
    rm -rf "$SKILL_DIR"
fi

# Symlink or copy based on preference
if [ "$1" = "--copy" ]; then
    echo "Copying skill to $SKILL_DIR..."
    cp -r "$SCRIPT_DIR/plugins/beads-tasks/skills/bd" "$SKILL_DIR"
else
    echo "Symlinking skill to $SKILL_DIR..."
    ln -s "$SCRIPT_DIR/plugins/beads-tasks/skills/bd" "$SKILL_DIR"
fi

echo "Done! Skill installed at $SKILL_DIR"
echo ""
echo "Next steps:"
echo "  1. Install beads: brew install beads"
echo "  2. In your project: bd init"
echo "  3. Configure adapter: mkdir -p .claude && echo 'beads' > .claude/tasks-adapter"
echo "  4. Use it: /bd"
