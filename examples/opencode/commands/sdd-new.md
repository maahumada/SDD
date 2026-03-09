---
description: Start change (explore+proposal). Usage: /sdd-new <change-name> -- <prompt>
agent: SDD
---

Route this input through the SDD orchestrator as:

```text
/sdd-new {argument}
```

Canonical argument format:

```text
<change-name> -- <prompt>
```

Examples:

```text
/sdd-new add-dark-mode -- add theme toggle with system fallback
```

Validate grammar with `docs/sdd-command-contract.md` before execution.
