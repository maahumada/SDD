<!-- SDD:BEGIN adapter=OPENCODE_CMD_SDD_APPLY version=1 -->
---
description: Implement task batch. Usage: /sdd-apply <change-name> [-- <task-range-or-note>]
agent: SDD
---

Route this input through the SDD orchestrator as:

```text
/sdd-apply {argument}
```

Canonical argument format:

```text
<change-name> [-- <task-range-or-note>]
```

Examples:

```text
/sdd-apply add-dark-mode
/sdd-apply add-dark-mode -- 1.1-1.3
```

Use `docs/sdd-command-contract.md` for validation.
<!-- SDD:END adapter=OPENCODE_CMD_SDD_APPLY -->
