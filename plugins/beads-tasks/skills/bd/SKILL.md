---
name: bd
description: Manage project tasks using beads persistent task tracking. Use this when starting a session to check pending work, or when planning/tracking tasks.
argument-hint: "[command] [args] - e.g., 'ready', 'create Fix bug', 'done bd-xxx'"
user-invocable: true
allowed-tools: Bash(bd:*), Bash(cat:*), Bash(command:*), Bash(mkdir:*), Bash(echo:*), Bash(test:*)
---

# Task Management System

You are now operating with persistent task tracking enabled. This system maintains task state across sessions, so you can pick up where you left off.

## Environment Check

**Is `bd` CLI installed?**
!`command -v bd >/dev/null 2>&1 && echo "yes" || echo "no"`

**Is beads initialized in this project?**
!`test -d .beads && echo "yes" || echo "no"`

**Adapter config:**
!`cat .claude/tasks-adapter 2>/dev/null || echo "not-configured"`

## Setup Flow (if needed)

Based on the environment check above, follow this flow:

### If `bd` CLI is NOT installed ("no"):

Tell the user beads needs to be installed first:

```
To use task tracking, you need to install the beads CLI:

  npm install -g beads
  # or
  brew install beads

Once installed, run /bd again to continue setup.
```

**STOP HERE** - do not proceed until bd is installed.

### If `bd` IS installed but beads is NOT initialized ("no"):

Offer to initialize beads for this project:

"I see beads isn't set up in this project yet. Want me to initialize it? This will create a `.beads/` directory to track tasks."

If user agrees, run:
1. `bd init`
2. `mkdir -p .claude && echo "beads" > .claude/tasks-adapter`

Then proceed to show tasks.

### If adapter is "not-configured" but beads IS initialized:

The project has `.beads/` but no adapter config. Fix it automatically:
1. `mkdir -p .claude && echo "beads" > .claude/tasks-adapter`
2. Tell the user: "Found existing beads setup, configured adapter."
3. Proceed to show tasks.

### If everything is configured (bd installed, beads initialized, adapter set):

**Current tasks (ready to work on):**
!`bd ready`

Present these tasks to the user in a readable format.

## Key Commands

- `bd ready` - Show tasks ready to work on (no blockers)
- `bd list` - Show all open tasks
- `bd create "Title" -p N` - Create task (P0=critical, P1=high, P2=normal)
- `bd create "Title" --type <type>` - Types: bug, feature, task, chore
- `bd show <id>` - Show task details
- `bd close <id>` - Mark task complete
- `bd close <id> --reason "what was done"` - Close with context
- `bd dep add <child> <parent>` - Add dependency (child is blocked by parent)
- `bd update <id> --description "text"` - Update description (non-interactive)
- `bd update <id> --title "text"` - Update title
- `bd update <id> --notes "text"` - Update notes
- `bd update <id> --design "text"` - Update design notes
- `bd update <id> --acceptance "text"` - Update acceptance criteria
- `bd update <id> --status <status>` - Change status

**Important:** Use `bd update` for programmatic edits. Do NOT use `bd edit` - it opens an interactive editor which doesn't work in Claude Code.

## Handling the Request

User's request: $ARGUMENTS

**If no arguments or "ready" or "status":**
- Present the tasks from "Current tasks" section above in a clear, readable format
- If the JSON is empty `[]`, say "No open tasks"
- Summarize what's actionable and offer to help

**If "create <title>" or similar:**
- Create the task with `bd create`
- Add appropriate priority based on context
- Add dependencies if mentioned

**If "done <id>" or "close <id>":**
- Close the task with `bd close <id>`
- Check if this unblocks other tasks

**If "plan <description>":**
- Break down the work into subtasks
- Create them with dependencies
- Show the task graph

**If "sync" or "refresh":**
- Run `bd ready` to refresh state
- Report current status

**If "setup" or "init":**
- Run the setup flow above regardless of current state
- Useful for reinitializing or troubleshooting

## Proactive Task Tracking

**IMPORTANT:** Any work that requires multiple steps or can't be finished immediately MUST be tracked in bd.

- **bd tasks persist across sessions** - TodoWrite does not
- When you identify multi-step work, create a bd task BEFORE starting
- If the user asks for something complex, create the task first, then work on it
- When you discover subtasks or blockers, create them in bd with dependencies

**Examples of when to create tasks:**
- User reports a bug → `bd create "Fix: <description>" --type bug`
- Feature request → `bd create "Add: <feature>" --type feature`
- Multi-file refactor → `bd create "Refactor: <scope>"` with subtasks
- Investigation needed → `bd create "Investigate: <issue>"`

**Do NOT rely solely on TodoWrite** for tracking work. TodoWrite is for in-session progress visibility. bd is for persistent tracking that survives context limits and session restarts.

## Workflow Integration

When working on tasks:
1. At session start, always run `bd ready` to see pending work
2. Before starting work, create a bd task if one doesn't exist
3. As you complete tasks, close them with `bd close --reason "what was done"`
4. If you discover new work, create tasks for it immediately
5. Keep the user informed of task status changes

## Troubleshooting

### Always run bd from the project root
`bd` walks up looking for `.beads/`. If you're not in the right directory, it silently fails or says "No .beads/ directory found". Always `cd` to the project root first.

### After `brew upgrade beads` (daemon version mismatch)
The background daemon keeps running the old version after a CLI upgrade. Symptoms: `bd create` fails, `bd list` returns nothing, `bd config set` appears to work but has no effect.

Fix:
```bash
# Remove the stale daemon lock (new one starts automatically)
rm -f .beads/daemon.lock

# Remove any dolt crash locks
rm -f .beads/dolt-access.lock .beads/dolt/beads/.dolt/noms/LOCK

# Verify health
bd doctor
```

### "database not initialized: issue_prefix config is missing"
The dolt backend is empty or out of sync with the JSONL. Fix:
```bash
bd rename-prefix <prefix> --repair
# <prefix> is the short ID used by existing issues (e.g. "fulcrum" for "fulcrum-abc")
```
This syncs JSONL → dolt and consolidates any prefix collisions.

### `bd config set issue-prefix` doesn't fix the above
`bd config` writes to SQLite (ephemeral layer). `bd create` validates against the dolt backend's internal config. They are separate stores — use `rename-prefix --repair` instead.

### Stale lock files blocking database access
```bash
bd doctor --fix --yes   # removes dolt-access.lock automatically
rm -f .beads/dolt/beads/.dolt/noms/LOCK   # must be removed manually
```

Remember: The goal is seamless task tracking. The user shouldn't need to think about the mechanics - just tell you what to do and you handle the bookkeeping.
