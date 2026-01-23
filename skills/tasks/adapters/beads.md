# Beads Adapter Instructions

Beads is a git-backed, distributed task tracker designed for AI coding agents. Tasks are stored in `.beads/` and can be committed with your code.

## Core Philosophy

- **Persistent memory**: Tasks survive across sessions and context limits
- **Dependency-aware**: Tasks can block other tasks, showing what's actually actionable
- **Git-native**: Task changes are committed like code changes
- **AI-optimized**: JSON output, hash-based IDs, structured data

## Command Reference

### Viewing Tasks

```bash
# Show tasks ready to work on (no blockers)
bd ready

# Show all open tasks
bd list

# Show task details
bd show <id>

# JSON output (for parsing)
bd list --json
bd ready --json
```

### Creating Tasks

```bash
# Basic task
bd create "Title"

# With priority (P0=critical, P1=high, P2=normal, P3=low)
bd create "Title" -p 1

# With description
bd create "Title" --description="Detailed explanation"

# With type (task, bug, feature, chore)
bd create "Title" --type=bug
```

### Managing Dependencies

```bash
# Make child blocked by parent (child depends on parent)
bd dep add <child-id> <parent-id>

# Remove dependency
bd dep remove <child-id> <parent-id>

# View dependency graph
bd show <id>  # Shows BLOCKS and BLOCKED BY
```

### Completing Tasks

```bash
# Close a task
bd close <id>

# Close with comment
bd close <id> --comment="Completed in commit abc123"
```

### Organizing

```bash
# Change priority
bd edit <id> --priority=0

# Add labels
bd label add <id> <label>

# Assign to someone
bd assign <id> <user>
```

## Best Practices for AI Agents

### Session Start
Always begin by checking what's ready:
```bash
bd ready
```

### During Work
- Reference task IDs in commit messages
- Close tasks immediately when done (don't batch)
- Create new tasks for discovered work
- Update task descriptions with learnings

### Task Breakdown
When planning complex work:
1. Create a parent task for the overall goal
2. Create child tasks for each step
3. Add dependencies so children are blocked by parent
4. As you complete the parent's planning, close it
5. Children become ready automatically

### Dependency Patterns

**Sequential work:**
```
A (ready) ← B (blocked) ← C (blocked)
```
Complete A first, then B becomes ready, then C.

**Parallel work:**
```
A (ready)
B (ready)  ← C (blocked by both A and B)
```
A and B can be done in any order. C waits for both.

## Integration with Git

Beads stores data in `.beads/` which should be committed:
```bash
git add .beads/
git commit -m "Update task tracking"
```

Task IDs use content-hashing, so parallel branches creating tasks won't conflict on merge.

## Troubleshooting

**"bd: command not found"**
- Install: `brew install beads` or `npm install -g beads`

**"Not a beads repository"**
- Run `bd init` in the project root

**Tasks not showing**
- Check `bd list --all` to see closed tasks too
- Verify you're in the right directory
