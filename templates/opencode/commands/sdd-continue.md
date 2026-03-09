<!-- SDD:BEGIN adapter=OPENCODE_CMD_SDD_CONTINUE version=2 -->
---
description: Continue workflow automatically. Usage: /sdd-continue [change-name]
agent: SDD
---

Route this input through the SDD orchestrator as:

```text
/sdd-continue {argument}
```

Canonical argument format:

```text
[change-name]
```

If no change name is provided, orchestrator resolves the active change from
`.sdd/changes/*/state.yaml`.

Behavior note:
- `/sdd-continue` auto-advances through apply and verify by default; separate
  `/sdd-apply` and `/sdd-verify` are optional targeted controls.
<!-- SDD:END adapter=OPENCODE_CMD_SDD_CONTINUE -->
