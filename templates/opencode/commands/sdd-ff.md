<!-- SDD:BEGIN adapter=OPENCODE_CMD_SDD_FF version=1 -->
---
description: Fast-forward SDD planning artifacts
agent: sdd-orchestrator
---

Route this input through the SDD orchestrator as:

```text
/sdd-ff {argument}
```

Canonical argument format:

```text
<change-name> [-- <prompt>]
```

Example:

```text
/sdd-ff add-dark-mode -- regenerate planning after revised proposal
```

Validate syntax via `docs/sdd-command-contract.md`.
<!-- SDD:END adapter=OPENCODE_CMD_SDD_FF -->
