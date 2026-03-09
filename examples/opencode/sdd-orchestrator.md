# OpenCode SDD Adapter

Use this snippet to configure SDD orchestration in OpenCode.

Quick install helper:

```bash
./scripts/sdd-install-opencode.sh
```

## New Setup

1. Copy command files:

```bash
cp examples/opencode/commands/sdd-*.md ~/.config/opencode/commands/
```

2. Add or merge the `SDD` agent from
`examples/opencode/opencode.json` into your OpenCode config.

   The provided config sets `mode: primary`, so `SDD` appears in
   the primary agent picker (Tab) alongside agents like `build` and `plan`.

3. Ensure your skills include:
- `skills/sdd-orchestrator/SKILL.md`
- `skills/sdd-explore/SKILL.md`
- `skills/sdd-propose/SKILL.md`
- `skills/sdd-spec/SKILL.md`
- `skills/sdd-design/SKILL.md`
- `skills/sdd-tasks/SKILL.md`
- `skills/sdd-apply/SKILL.md`
- `skills/sdd-verify/SKILL.md`

## Merge Strategy (Existing Config)

If you already have `~/.config/opencode/opencode.json`:

1. Keep your existing agents untouched.
2. Add a new `agent.SDD` entry from `examples/opencode/opencode.json`.
3. Keep command files in `~/.config/opencode/commands/`.
4. If command names conflict, keep `/sdd-*` names canonical and remove aliases.
5. If you already had `sdd-orchestrator`, running the installer migrates it to
   the `SDD` primary agent automatically.

## Command Contract

Commands must follow `docs/sdd-command-contract.md`:

```text
/sdd-explore -- <topic>
/sdd-new <change-name> -- <prompt>
/sdd-continue [change-name]
/sdd-ff <change-name> [-- <prompt>]
/sdd-apply <change-name> [-- <task-range-or-note>]
/sdd-verify <change-name>
```

## Behavior Reference

- Router policy: `docs/adapters/sdd-router-core.md`
- Orchestrator flow: `skills/sdd-orchestrator/SKILL.md`
