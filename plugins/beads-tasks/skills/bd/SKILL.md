---
name: bd
description: Manage project tasks using beads persistent task tracking. Use this when starting a session to check pending work, or when planning/tracking tasks.
argument-hint: "[command] [args] - e.g., 'ready', 'create Fix bug', 'done bd-xxx'"
user-invocable: true
allowed-tools: Bash(bd:*), Bash(cat:*)
---

# Task Management System

You are now operating with persistent task tracking enabled. This system maintains task state across sessions, so you can pick up where you left off.

## Detected Configuration

**Adapter config:**
!`cat .claude/tasks-adapter`

**Current tasks (ready to work on):**
!`bd ready`

Present these tasks to the user in a readable format.

## Your Instructions

Based on the adapter detected above, follow the appropriate workflow:

### If adapter is "beads":

Key beads commands:
- `bd ready` - Show tasks ready to work on (no blockers)
- `bd list` - Show all open tasks
- `bd create "Title" -p N` - Create task (P0=critical, P1=high, P2=normal)
- `bd show <id>` - Show task details
- `bd close <id>` - Mark task complete
- `bd dep add <child> <parent>` - Add dependency (child is blocked by parent)

### If adapter is "none":

No task system detected. Ask the user if they'd like to set one up:
1. **beads** - Git-backed task tracking (recommended for AI workflows)
2. **github** - GitHub Issues (good for open source)
3. **manual** - Just use TodoWrite (no persistence)

To set up beads: `bd init` then `echo "beads" > .claude/tasks-adapter`

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

## Workflow Integration

When working on tasks:
1. At session start, always run `bd ready` to see pending work
2. Before starting work, mark the task you're working on (mention it)
3. As you complete tasks, close them with `bd close`
4. If you discover new work, create tasks for it
5. Keep the user informed of task status changes

Remember: The goal is seamless task tracking. The user shouldn't need to think about the mechanics - just tell you what to do and you handle the bookkeeping.
