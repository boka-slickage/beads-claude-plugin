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
/plugin marketplace add boka-slickage/beads-claude-plugin
/plugin install beads-tasks
```

<details>
<summary>Alternative: Manual install</summary>

```bash
git clone https://github.com/boka-slickage/beads-claude-plugin.git
cd beads-claude-plugin
./install.sh
```

</details>

### 3. Initialize in your project (one person per repo)

```bash
cd your-project
bd init
mkdir -p .claude && echo "beads" > .claude/tasks-adapter
git add .claude/tasks-adapter && git commit -m "Configure beads for task tracking"
```

Once committed, teammates just need steps 1-2 - the adapter config syncs via git.

### 4. Use it

```
You: /bd
Claude: Shows current ready tasks, offers to help plan work

You: /bd create Add user authentication
Claude: Creates the task, adds to beads

You: /bd done beads-xxx-yyy
Claude: Closes the task, shows what's now unblocked
```

Or just talk naturally - Claude will manage tasks in the background.

## How It Works

```
~/.claude/skills/bd/
├── SKILL.md              # Main skill - detects adapter, handles requests
└── adapters/
    └── beads.md          # Beads-specific instructions

your-project/
├── .beads/               # Task data (committed to git)
└── .claude/
    └── tasks-adapter     # Says "beads" (or "github", etc.)
```

When you invoke `/bd` or Claude detects task-related work:
1. Skill checks `.claude/tasks-adapter` for which backend to use
2. Falls back to auto-detection (looks for `.beads/` directory)
3. Loads adapter-specific instructions
4. Handles your request using the appropriate commands

## Commands

| Command | Description |
|---------|-------------|
| `/bd` or `/bd ready` | Show actionable tasks |
| `/bd create <title>` | Create a new task |
| `/bd done <id>` | Mark task complete |
| `/bd plan <description>` | Break work into subtasks |
| `/bd sync` | Refresh task status |

## Swapping Backends

To use a different task system:

1. Create a new adapter in `~/.claude/skills/bd/adapters/`
2. Update `.claude/tasks-adapter` in your project
3. That's it - the skill will use the new backend

Planned adapters:
- [x] beads
- [ ] GitHub Issues
- [ ] Linear
- [ ] Jira

## License

MIT
