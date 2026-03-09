# Adapter Sync Policy

Version: 1  
Status: Active

This policy defines source-of-truth hierarchy, update workflow, and review
checklist for all SDD adapter files.

## Source-of-Truth Hierarchy

Use this precedence order:

1. `docs/sdd-command-contract.md`
2. `skills/sdd-orchestrator/SKILL.md`
3. `docs/adapters/sdd-router-core.md`
4. Adapter templates and adapter files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`,
   OpenCode command files)

Rules:
- Higher level files define behavior.
- Lower level adapter files must only adapt wording/tool specifics.
- Adapter files must not redefine command grammar or DAG rules.

## Adapter vs Core Classification

| File Type | Role | Can Define Behavior? |
|-----------|------|----------------------|
| Command contract | Canonical syntax and validation | Yes |
| Orchestrator skill | Workflow and delegation policy | Yes |
| Router core | Adapter routing policy | Yes |
| Tool adapter file | Tool-specific entrypoint wording | No (adapts only) |

## Update Workflow (Actionable)

When command behavior changes, update in this order:

1. Update `docs/sdd-command-contract.md`.
2. Update `skills/sdd-orchestrator/SKILL.md` if orchestration behavior changed.
3. Update `docs/adapters/sdd-router-core.md` to align adapter policy.
4. Update adapter templates/files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`,
   OpenCode commands).
5. Update README references and examples.
6. Run a manual conformance check using the checklist below.

Do not start with adapter files. Always change source files first.

## Versioning Notes

Track versions independently:
- Command contract version in `docs/sdd-command-contract.md`.
- Router core version in `docs/adapters/sdd-router-core.md`.
- Adapter template version stamps once template install/update scripts are added.

Recommended bump policy:
- Major: breaking grammar or command semantics.
- Minor: new command or new optional argument behavior.
- Patch: wording clarifications, non-behavioral examples.

## Review Checklist

Use this checklist for every adapter-related change:

- [ ] Command examples in adapters use canonical syntax.
- [ ] Required `--` separator usage is preserved.
- [ ] No adapter introduces command names outside canonical set.
- [ ] Adapter text references orchestrator flow, not duplicated local logic.
- [ ] Approval gates (proposal/planning/apply/verify) are still represented.
- [ ] README examples match command contract.
- [ ] No references to deprecated naming or storage modes.

## Drift Detection Guidance

Adapter drift is present when one or more occur:
- Different syntax examples across adapter files.
- Adapter-specific command semantics not present in command contract.
- Missing or inconsistent approval gate behavior.

When drift is detected:
1. Treat source-of-truth files as canonical.
2. Update adapters to match.
3. Record the fix in the next commit message and changelog notes if used.
