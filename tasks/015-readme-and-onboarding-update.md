# Task 015: Update README and Onboarding for Dual Usage Modes

**Priority**: High  
**Status**: Completed  
**Depends on**: 008-command-contract-and-grammar.md, 009-orchestrator-core-skill.md, 011-agents-md-adapter.md, 012-claude-md-adapter.md, 013-gemini-md-adapter.md, 014-opencode-adapter-and-command-pack.md

---

## Objective

Update documentation so users clearly understand both framework entrypoints:

1. Explicit command mode (`/sdd-*`)
2. Auto-router adapter mode (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, OpenCode)

## Deliverables

- Update `README.md`
- Add references to new adapter docs and command contract

## Scope

README updates must include:
- Canonical command syntax with `--` separator pattern
- Example flows for command mode
- Example behavior for non-command prompts routed via adapters
- Compatibility table showing supported adapter files
- Guidance on when to use command mode vs auto-router mode

## Acceptance Criteria

- [x] `README.md` documents both usage modes clearly
- [x] Command examples use canonical syntax from Task 008
- [x] New adapter files are linked in README
- [x] Onboarding path is clear for first-time users
- [x] Existing sub-agent architecture section remains accurate
- [x] No references to `engram`, `hybrid`, or `openspec` naming
