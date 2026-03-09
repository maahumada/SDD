# ADR-001: Vision and Mission of SDD (Spec Driven Development)

**Status**: Accepted  
**Date**: 2026-03-09  
**Author**: Manuel Ahumada

---

## Context

AI coding assistants are increasingly powerful but suffer from fundamental limitations when building complex features: context overload causes hallucinations, lack of structure produces unpredictable results, there are no review gates before code gets written, and specifications live in chat history that vanishes.

Existing solutions like agent-teams-lite (by Gentleman Programming) address this through an orchestrator + sub-agent pattern with pluggable persistence (engram, openspec, hybrid, none). However, we want a system that:

1. Is opinionated about persistence from the start (filesystem-based, own convention)
2. Removes the complexity of mode resolution and multi-backend support
3. Focuses on the core workflow roles without the overhead of init/archive lifecycle phases
4. Is designed as a standalone framework, not a plugin for a specific AI tool

## Vision

**SDD (Spec Driven Development)** is an agentic development framework where AI sub-agents collaborate through a structured workflow to build software features. Each sub-agent has a single responsibility, starts with fresh context, and produces structured artifacts that persist on the filesystem.

The framework ensures that:
- No code is written before requirements are agreed upon
- Every implementation decision is traceable to a specification
- Quality gates exist before work is considered complete
- The orchestrator never does phase work directly -- it only coordinates

## Mission

Build a lightweight, zero-dependency, Markdown-based agent team system with 7 specialized roles:

| Role | Responsibility |
|------|---------------|
| **Explorer** | Investigate the codebase, compare approaches, identify risks |
| **Proposer** | Create structured proposals with intent, scope, rollback plan |
| **Spec-Writer** | Write delta specifications with Given/When/Then scenarios |
| **Designer** | Produce technical design with architecture decisions and rationale |
| **Task-Planner** | Break down implementation into phased, actionable task checklists |
| **Implementer** | Write code following specs and design, mark tasks complete |
| **Verifier** | Validate implementation against specs with real test execution |

### Workflow DAG

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

## Key Decisions

### 1. Filesystem-Only Persistence (`.sdd/` directory)

**Decision**: Use a hidden `.sdd/` directory at the project root as the only persistence mechanism. No engram, no hybrid, no mode resolution logic. No dependency on the OpenSpec CLI or npm package.

**Rationale**:
- Simplicity: eliminates the entire mode resolution layer and shared convention files for engram
- Transparency: artifacts are human-readable files in the project directory
- Version control: artifacts can be committed to git alongside code
- Debuggability: any developer can inspect the state by reading files
- No external dependencies: no need for engram server, API, or npm packages
- Identity: `.sdd/` is our own convention, not tied to the OpenSpec product by Fission AI
- Hidden directory: keeps the project root clean (similar to `.git/`, `.vscode/`, etc.)

**Note on OpenSpec**: The OpenSpec project (https://github.com/Fission-AI/OpenSpec) by Fission AI popularized the convention of `openspec/` directories with specs, changes, and delta specs. We adopt the same structural patterns (specs by domain, delta specs with ADDED/MODIFIED/REMOVED, archive) but under our own directory name `.sdd/` to avoid confusion with the OpenSpec product and CLI.

**Trade-off**: We lose cross-session memory that engram provides. See ADR section on persistence value below.

### 2. Seven Core Roles (No Init/Archive)

**Decision**: Start with 7 roles (Explorer, Proposer, Spec-Writer, Designer, Task-Planner, Implementer, Verifier). Exclude Init and Archive from the initial scope.

**Rationale**:
- Init can be handled by the orchestrator or a simple bootstrap step
- Archive (merging deltas into main specs) is valuable but is a lifecycle concern that can be added later
- These 7 roles cover the complete development cycle from idea to verified implementation

### 3. Fresh Context Per Sub-Agent

**Decision**: Each sub-agent starts with a clean context window, receives only its skill definition + relevant artifacts, and returns a structured result.

**Rationale**:
- Prevents context overload and hallucinations
- Each agent gets focused instructions = better output quality
- Orchestrator stays lightweight and can handle longer sessions

### 4. Structured Result Envelope

**Decision**: Every sub-agent returns a structured payload:

```json
{
  "status": "ok | warning | blocked | failed",
  "executive_summary": "short decision-grade summary",
  "detailed_report": "optional long-form analysis",
  "artifacts": [{"name": "...", "ref": "..."}],
  "next_recommended": ["..."],
  "risks": ["..."]
}
```

**Rationale**: The orchestrator needs a predictable format to parse results, track state, and present summaries to the user.

### 5. Tool-Agnostic Design

**Decision**: Skills are pure Markdown files. The framework works with any AI assistant that can read files and spawn sub-agents (Claude Code, OpenCode, etc.) or run skills inline (Gemini CLI, Cursor, etc.).

**Rationale**: No runtime dependencies, no CLI tools, no npm packages. Maximum portability.

## On the Value of Persistence in This System

Persistence (writing artifacts to the filesystem in `.sdd/`) is **highly valuable** in this system for the following reasons:

1. **Inter-agent communication**: Sub-agents don't share context. The only way for the Designer to read what the Proposer wrote is through persisted artifacts. Without persistence, the orchestrator must relay everything in the prompt, which bloats context.

2. **Compaction survival**: Long sessions hit context limits. With filesystem artifacts, a compacted session can recover state by reading `state.yaml` and the existing artifact files.

3. **Human review**: The proposal, specs, design, and tasks are meant to be reviewed by humans between phases. Persisted files make this natural (open the file, read it, approve or request changes).

4. **Audit trail**: After a feature is complete, the artifacts document WHY decisions were made. This is valuable for future maintainers.

5. **Incremental progress**: If the `apply` phase is interrupted, the marked tasks in `tasks.md` survive. The next session picks up where it left off.

**Where persistence is less critical**:
- Standalone explorations (`/sdd-explore`) that are one-off investigations
- Small changes where the overhead of artifact creation exceeds the benefit

**Conclusion**: For a multi-agent workflow with 7+ phases, filesystem persistence is not optional -- it's the backbone that enables the agents to collaborate without sharing context windows. The decision to use filesystem-only (rather than engram) means we trade cross-session memory for simplicity and transparency. This is the right trade-off for a file-based development workflow.

## Directory Structure

```
.sdd/
├── config.yaml                        <- Project context (stack, conventions)
├── specs/                             <- Source of truth: main specs by domain
│   └── {domain}/spec.md
└── changes/
    ├── archive/                       <- Completed changes (audit trail)
    │   └── YYYY-MM-DD-{change-name}/
    └── {change-name}/                 <- Active change
        ├── state.yaml                 <- DAG state (orchestrator recovery)
        ├── exploration.md             <- from Explorer
        ├── proposal.md                <- from Proposer
        ├── specs/                     <- from Spec-Writer
        │   └── {domain}/spec.md       <- Delta specs
        ├── design.md                  <- from Designer
        ├── tasks.md                   <- from Task-Planner (updated by Implementer)
        └── verify-report.md           <- from Verifier
```

## References

- [agent-teams-lite](https://github.com/gentleman-programming/agent-teams-lite) -- The reference implementation that inspired this project
- [OpenSpec](https://github.com/Fission-AI/OpenSpec) -- The project that popularized the spec-driven directory convention (we adopt the patterns under our own `.sdd/` directory)
