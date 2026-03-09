# SDD -- Spec Driven Development

**Agent-Team Orchestration for Structured Feature Development**

An orchestrator + 7 specialized AI sub-agents for building software features with specifications, design documents, and quality gates.

Zero dependencies. Pure Markdown. `.sdd/` filesystem persistence.

---

## Installation

### Install In A Project

Install adapters into any repository:

```bash
./scripts/sdd-install.sh --project ../my-project --adapters agents,claude,gemini,opencode
```

### Install Globally In OpenCode

Install SDD directly into your OpenCode config (`~/.config/opencode`):

```bash
./scripts/sdd-install-opencode.sh
```

This configures `SDD` as a primary agent (`mode: primary`), so you
can pick it with Tab like `build` and `plan`.

### Update Installed Adapters

```bash
./scripts/sdd-update.sh --project ../my-project --adapters agents,opencode
```

Preview changes without writing files:

```bash
./scripts/sdd-install.sh --project ../my-project --adapters agents --dry-run
```

Installer behavior note:
- `sdd-install.sh` is non-interactive and overwrites existing target files by default.
- Backups are created automatically unless you pass `--no-backup`.

### Full Installation Docs

- `docs/adapter-installation.md`
- `templates/README.md`

## Usage Modes By Platform

### OpenCode

- Select `SDD` in the primary agent picker (Tab).
- `SDD` is an agent profile, not a slash command.
- Slash command entries (`/sdd-*`) include one-line usage hints in the command description.
- You can use:
  - conversational mode (plain language prompts), or
  - command mode (recommended for deterministic runs).

Recommended command mode examples:

```text
/sdd-new add-dark-mode -- add theme toggle with persisted preference
/sdd-continue add-dark-mode
```

Optional targeted controls (normally not needed):

```text
/sdd-apply add-dark-mode -- 1.1-1.3
/sdd-verify add-dark-mode
```

### Claude Code

- Use `CLAUDE.md` for routing behavior.
- For complex changes, prefer canonical `/sdd-*` commands.

### Codex (AGENTS.md-aware)

- Use `AGENTS.md` as adapter entrypoint.
- Run canonical `/sdd-*` commands for best reproducibility.

### Gemini

- Use `GEMINI.md` adapter.
- If true sub-agent delegation is unavailable, follow inline fallback while
  preserving SDD phase order and automatic gate progression.

### Canonical Command Format

```text
/sdd-<command> [args...] [-- <free-text-prompt>]
```

Command reference:

| Command | What It Does |
|---------|-------------|
| `/sdd-explore -- <topic>` | Investigate an idea. Reads codebase, compares approaches. |
| `/sdd-new <change-name> -- <prompt>` | Start a new change and auto-advance by orchestrator policy. |
| `/sdd-continue [change-name]` | Run dependency-ready phases end-to-end (including apply + verify) until completion or blocked state. |
| `/sdd-ff <change-name> [-- <prompt>]` | Fast-forward planning (proposal -> specs -> design -> tasks). |
| `/sdd-apply <change-name> [-- <task-range-or-note>]` | Implement tasks directly (targeted override or recovery path). |
| `/sdd-verify <change-name>` | Run verification directly (optional explicit rerun). |

## Index

- [Installation](#installation)
- [Usage Modes By Platform](#usage-modes-by-platform)
- [The Problem](#the-problem)
- [The Solution](#the-solution)
- [How It Works](#how-it-works)
- [The 7 Sub-Agents](#the-7-sub-agents)
- [Concepts](#concepts)
- [Project Structure](#project-structure)
- [Inspiration](#inspiration)
- [Created by Manuel Ahumada](#created-by-manuel-ahumada)

## The Problem

AI coding assistants are powerful, but they struggle with complex features:

- **Context overload** -- Long conversations lead to compression, lost details, hallucinations
- **No structure** -- "Build me dark mode" produces unpredictable results
- **No review gate** -- Code gets written before anyone agrees on what to build
- **No memory** -- Specs live in chat history that vanishes

## The Solution

**SDD** is an agent-team orchestration framework where a lightweight coordinator delegates all real work to specialized sub-agents. Each sub-agent starts with fresh context, executes one focused task, and returns a structured result.

```
YOU: "I want to add CSV export to the app"

ORCHESTRATOR (delegate-only, minimal context):
  -> launches EXPLORER sub-agent     -> returns: codebase analysis
  -> synthesizes summary and auto-advances
  -> launches PROPOSER sub-agent     -> returns: proposal artifact
  -> launches SPEC WRITER sub-agent  -> returns: spec artifact      (parallel)
  -> launches DESIGNER sub-agent     -> returns: design artifact     (parallel)
  -> launches TASK PLANNER sub-agent -> returns: tasks artifact
  -> synthesizes planning summary and auto-advances
  -> launches IMPLEMENTER sub-agent  -> returns: code written, tasks checked off
  -> launches VERIFIER sub-agent     -> returns: verification report
```

**The key insight**: the orchestrator NEVER does phase work directly. It only coordinates sub-agents, tracks state, and synthesizes summaries. This keeps the main thread small and stable.

### Persistence: `.sdd/` Directory (Filesystem)

All artifacts are persisted as human-readable files in a hidden `.sdd/` directory at the project root:

```
.sdd/
├── config.yaml                        <- Project context (stack, conventions)
├── specs/                             <- Source of truth: how the system works TODAY
│   ├── auth/spec.md
│   ├── export/spec.md
│   └── ui/spec.md
└── changes/
    ├── add-csv-export/                <- Active change
    │   ├── state.yaml                 <- DAG state (orchestrator recovery)
    │   ├── exploration.md             <- from Explorer
    │   ├── proposal.md               <- from Proposer
    │   ├── specs/                     <- from Spec-Writer (delta specs)
    │   │   └── export/spec.md
    │   ├── design.md                  <- from Designer
    │   ├── tasks.md                   <- from Task-Planner (updated by Implementer)
    │   └── verify-report.md           <- from Verifier
    └── archive/                       <- Completed changes (audit trail)
        └── 2026-02-16-fix-auth/
```

Why `.sdd/`:
- **Transparent**: artifacts are human-readable files you can inspect anytime
- **Version controllable**: commit artifacts alongside code in git
- **No external dependencies**: no servers, no APIs, no setup
- **Debuggable**: if something goes wrong, read the files
- **Clean project root**: hidden directory, like `.git/` or `.vscode/`

---

## How It Works

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│  ORCHESTRATOR (your main agent thread)                   │
│                                                          │
│  Responsibilities:                                       │
│  - Detect when SDD is needed                             │
│  - Launch sub-agents via Task tool                       │
│  - Show summaries to user                                │
│  - Auto-advance phase gates by policy                    │
│  - Track state: which artifacts exist, what's next       │
│                                                          │
│  Context usage: MINIMAL (only state + summaries)         │
└──────────────┬───────────────────────────────────────────┘
               │
               │ Task(subagent_type: 'general', prompt: 'Read skill...')
               │
    ┌──────────┴──────────────────────────────────────────┐
    │                                                      │
    v          v          v         v         v           v
┌────────┐┌────────┐┌────────┐┌────────┐┌────────┐┌────────┐┌────────┐
│EXPLORE ││PROPOSE ││  SPEC  ││ DESIGN ││ TASKS  ││ APPLY  ││VERIFY  │
│        ││        ││        ││        ││        ││        ││        │
│ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  │
│context ││context ││context ││context ││context ││context ││context │
└────────┘└────────┘└────────┘└────────┘└────────┘└────────┘└────────┘
```

### The Dependency Graph

```
                    proposal
                   (root node)
                       |
         +-------------+-------------+
         |                           |
         v                           v
      specs                       design
   (requirements                (technical
    + scenarios)                 approach)
         |                           |
         +-------------+-------------+
                       |
                       v
                    tasks
                (implementation
                  checklist)
                       |
                       v
                    apply
                (write code)
                       |
                       v
                   verify
              (quality gate)
```

Specs and Design can run in **parallel** (both depend only on the proposal). Everything else is sequential.

### Sub-Agent Result Contract

Each sub-agent returns a structured payload:

```json
{
  "status": "ok | warning | blocked | failed",
  "executive_summary": "short decision-grade summary",
  "detailed_report": "optional long-form analysis when needed",
  "artifacts": [
    {
      "name": "design",
      "ref": ".sdd/changes/{change-name}/design.md"
    }
  ],
  "next_recommended": ["tasks"],
  "risks": ["optional risk list"]
}
```

---

## The 7 Sub-Agents

Each sub-agent is a SKILL.md file -- pure Markdown instructions that any AI assistant can follow.

| # | Sub-Agent | Skill File | What It Does |
|---|-----------|-----------|-------------|
| 1 | **Explorer** | `skills/sdd-explore/SKILL.md` | Reads codebase, compares approaches, identifies risks |
| 2 | **Proposer** | `skills/sdd-propose/SKILL.md` | Creates `proposal.md` with intent, scope, rollback plan |
| 3 | **Spec-Writer** | `skills/sdd-spec/SKILL.md` | Writes delta specs (ADDED/MODIFIED/REMOVED) with Given/When/Then |
| 4 | **Designer** | `skills/sdd-design/SKILL.md` | Creates `design.md` with architecture decisions and rationale |
| 5 | **Task-Planner** | `skills/sdd-tasks/SKILL.md` | Breaks down into phased, numbered task checklist |
| 6 | **Implementer** | `skills/sdd-apply/SKILL.md` | Writes code following specs and design. Supports TDD workflow |
| 7 | **Verifier** | `skills/sdd-verify/SKILL.md` | Validates implementation with real test execution. Spec compliance matrix |

---

For setup and daily usage, see [Installation](#installation) and
[Usage Modes By Platform](#usage-modes-by-platform).

---

## Concepts

### Delta Specs

Instead of rewriting entire specs, changes describe what's different:

```markdown
## ADDED Requirements

### Requirement: CSV Export
The system SHALL support exporting data to CSV format.

#### Scenario: Export all observations
- GIVEN the user has observations stored
- WHEN the user requests CSV export
- THEN a CSV file is generated with all observations
- AND column headers match the observation fields

## MODIFIED Requirements

### Requirement: Data Export
The system SHALL support multiple export formats.
(Previously: The system SHALL support JSON export.)
```

### RFC 2119 Keywords

Specs use standardized language for requirement strength:

| Keyword | Meaning |
|---------|---------|
| **MUST / SHALL** | Absolute requirement |
| **SHOULD** | Recommended, exceptions may exist |
| **MAY** | Optional |

### Fresh Context Per Sub-Agent

Each sub-agent starts with a clean context window. It receives only:
1. Its SKILL.md instructions
2. The relevant artifacts from the filesystem
3. The specific task from the orchestrator

This prevents context overload (the #1 cause of AI hallucinations in long coding sessions) and ensures each agent gets focused, high-quality instructions.

---

## Project Structure

```
SDD/
├── README.md
├── AGENTS.md                          <- Generic adapter
├── CLAUDE.md                          <- Claude adapter
├── GEMINI.md                          <- Gemini adapter
├── docs/
│   ├── sdd-command-contract.md        <- Canonical /sdd-* grammar
│   └── adapters/
│       ├── sdd-router-core.md         <- Adapter routing policy
│       └── sync-policy.md             <- Source-of-truth and sync process
├── examples/
│   └── opencode/
│       ├── opencode.json
│       ├── sdd-orchestrator.md
│       └── commands/sdd-*.md
├── skills/
│   ├── sdd-orchestrator/SKILL.md
│   ├── sdd-explore/SKILL.md
│   ├── sdd-propose/SKILL.md
│   ├── sdd-spec/SKILL.md
│   ├── sdd-design/SKILL.md
│   ├── sdd-tasks/SKILL.md
│   ├── sdd-apply/SKILL.md
│   └── sdd-verify/SKILL.md
└── tasks/
    ├── ADR-001-vision-and-mission.md
    ├── ADR-002-dual-entrypoint-strategy.md
    └── 001..021 task definitions
```

---

## Inspiration

This project is heavily inspired by [Agent Teams Lite](https://github.com/gentleman-programming/agent-teams-lite) by Gentleman Programming. Key differences:

| | Agent Teams Lite | SDD |
|---|---|---|
| **Persistence** | Pluggable multi-backend modes | `.sdd/` directory only (filesystem) |
| **Roles** | 9 (includes Init + Archive) | 7 (core workflow roles) |
| **Mode resolution** | Complex multi-backend logic | None needed -- always filesystem |
| **Shared conventions** | Multiple backend-specific conventions | Focused SDD conventions only |
| **Philosophy** | Maximum flexibility | Maximum simplicity |

---

## Created by Manuel Ahumada

Spec Driven Development: because building without a plan is just vibe coding with extra steps.
