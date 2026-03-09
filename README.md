# SDD -- Spec Driven Development

**Agent-Team Orchestration for Structured Feature Development**

An orchestrator + 7 specialized AI sub-agents for building software features with specifications, design documents, and quality gates.

Zero dependencies. Pure Markdown. OpenSpec persistence.

---

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
  -> shows you summary, you approve
  -> launches PROPOSER sub-agent     -> returns: proposal artifact
  -> launches SPEC WRITER sub-agent  -> returns: spec artifact      (parallel)
  -> launches DESIGNER sub-agent     -> returns: design artifact     (parallel)
  -> launches TASK PLANNER sub-agent -> returns: tasks artifact
  -> shows you everything, you approve
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
│  - Ask for approval between phases                       │
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

## Commands

| Command | What It Does |
|---------|-------------|
| `/sdd-explore <topic>` | Investigate an idea. Reads codebase, compares approaches. |
| `/sdd-new <name>` | Start a new change: exploration + proposal. |
| `/sdd-continue` | Run the next dependency-ready phase via sub-agent(s). |
| `/sdd-ff <name>` | Fast-forward planning (proposal -> specs -> design -> tasks). |
| `/sdd-apply` | Implement tasks in batches. Checks off items as it goes. |
| `/sdd-verify` | Validate implementation against specs. CRITICAL / WARNING / SUGGESTION. |

### Example Flow

```
You: /sdd-new add-dark-mode

AI:  Launching explorer sub-agent...
     Done. React + Tailwind detected. Hardcoded light mode in globals.css.
     
     Launching proposer sub-agent...
     Done. proposal.md created.
       Intent: Add dark mode toggle with system preference detection
       Scope: Theme context, toggle component, CSS variables
     
     Want me to continue with specs and design? (or review the proposal first)

You: Go ahead

AI:  Launching spec-writer and designer in parallel...
     Done.
       specs/ui/spec.md -- 3 requirements, 7 scenarios
       design.md -- CSS variables approach, React Context, localStorage
     
     Launching task-planner...
     Done. tasks.md -- 3 phases, 8 tasks
     
     Ready to implement. Run /sdd-apply to start.

You: /sdd-apply

AI:  Implementing Phase 1 (Foundation)...
     [x] 1.1 Created ThemeContext
     [x] 1.2 Added CSS custom properties
     [x] 1.3 Added localStorage persistence
     
     3/8 tasks complete. Continue with Phase 2?
```

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
├── README.md                          <- You are here
├── tasks/                             <- Task definitions for building this project
│   ├── ADR-001-vision-and-mission.md  <- Architecture decision record
│   ├── 001-explorer-subagent.md       <- Task: define Explorer
│   ├── 002-proposer-subagent.md       <- Task: define Proposer
│   ├── 003-spec-writer-subagent.md    <- Task: define Spec-Writer
│   ├── 004-designer-subagent.md       <- Task: define Designer
│   ├── 005-task-planner-subagent.md   <- Task: define Task-Planner
│   ├── 006-implementer-subagent.md    <- Task: define Implementer
│   └── 007-verifier-subagent.md       <- Task: define Verifier
└── skills/                            <- (to be created) The 7 sub-agent skill files
    ├── _shared/
    │   └── sdd-convention.md          <- Filesystem paths & structure
    ├── sdd-explore/SKILL.md
    ├── sdd-propose/SKILL.md
    ├── sdd-spec/SKILL.md
    ├── sdd-design/SKILL.md
    ├── sdd-tasks/SKILL.md
    ├── sdd-apply/SKILL.md
    └── sdd-verify/SKILL.md
```

---

## Inspiration

This project is heavily inspired by [Agent Teams Lite](https://github.com/gentleman-programming/agent-teams-lite) by Gentleman Programming. Key differences:

| | Agent Teams Lite | SDD |
|---|---|---|
| **Persistence** | Pluggable (engram/openspec/hybrid/none) | `.sdd/` directory only (filesystem) |
| **Roles** | 9 (includes Init + Archive) | 7 (core workflow roles) |
| **Mode resolution** | Complex multi-backend logic | None needed -- always filesystem |
| **Shared conventions** | 3 files (persistence, engram, openspec) | 1 file (sdd convention) |
| **Philosophy** | Maximum flexibility | Maximum simplicity |

---

## Created by Manuel Ahumada

Spec Driven Development: because building without a plan is just vibe coding with extra steps.
