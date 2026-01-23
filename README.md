# Claude Tasks Plugin

A Claude Code plugin that provides persistent task management across sessions using [beads](https://github.com/steveyegge/beads) (swappable for other backends).

## Why?

- **Persistent memory**: Tasks survive session restarts and context compaction
- **Zero friction**: Just talk to Claude naturally, it handles the bookkeeping
- **Swappable**: Start with beads, switch to GitHub Issues or Linear later
- **Shareable**: Coworkers can install with one command

## Quick Start

### 1. Install beads

```bash
brew install beads
# or: npm install -g beads
```

### 2. Install the plugin

In Claude Code:

```
/plugin marketplace add YOUR_USERNAME/beads-claude-plugin
/plugin install beads-tasks
```

<details>
<summary>Alternative: Manual install</summary>

```bash
git clone https://github.com/YOUR_USERNAME/beads-claude-plugin.git
cd beads-claude-plugin
./install.sh
```

</details>

### 3. Initialize in your project

```bash
cd your-project
bd init
mkdir -p .claude && echo "beads" > .claude/tasks-adapter
```

### 4. Use it

```
You: /tasks
Claude: Shows current ready tasks, offers to help plan work

You: /tasks create Add user authentication
Claude: Creates the task, adds to beads

You: /tasks done beads-xxx-yyy
Claude: Closes the task, shows what's now unblocked
```

Or just talk naturally - Claude will manage tasks in the background.

## How It Works

```
~/.claude/skills/tasks/
├── SKILL.md              # Main skill - detects adapter, handles requests
└── adapters/
    └── beads.md          # Beads-specific instructions

your-project/
├── .beads/               # Task data (committed to git)
└── .claude/
    └── tasks-adapter     # Says "beads" (or "github", etc.)
```

When you invoke `/tasks` or Claude detects task-related work:
1. Skill checks `.claude/tasks-adapter` for which backend to use
2. Falls back to auto-detection (looks for `.beads/` directory)
3. Loads adapter-specific instructions
4. Handles your request using the appropriate commands

## Commands

| Command | Description |
|---------|-------------|
| `/tasks` or `/tasks ready` | Show actionable tasks |
| `/tasks create <title>` | Create a new task |
| `/tasks done <id>` | Mark task complete |
| `/tasks plan <description>` | Break work into subtasks |
| `/tasks sync` | Refresh task status |

## Swapping Backends

To use a different task system:

1. Create a new adapter in `~/.claude/skills/tasks/adapters/`
2. Update `.claude/tasks-adapter` in your project
3. That's it - the skill will use the new backend

Planned adapters:
- [x] beads
- [ ] GitHub Issues
- [ ] Linear
- [ ] Jira

## For Teams

Each team member just runs:
```
/plugin marketplace add YOUR_USERNAME/beads-claude-plugin
/plugin install beads-tasks
```

Then install beads CLI: `brew install beads`

The `.claude/tasks-adapter` file is committed to your project repo, so everyone uses the same backend automatically.

## License

MIT
