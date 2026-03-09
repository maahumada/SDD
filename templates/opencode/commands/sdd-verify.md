<!-- SDD:BEGIN adapter=OPENCODE_CMD_SDD_VERIFY version=1 -->
---
description: Verify SDD implementation quality and compliance
agent: sdd-orchestrator
---

Route this input through the SDD orchestrator as:

```text
/sdd-verify {argument}
```

Canonical argument format:

```text
<change-name>
```

Example:

```text
/sdd-verify add-dark-mode
```

Validation rules come from `docs/sdd-command-contract.md`.
<!-- SDD:END adapter=OPENCODE_CMD_SDD_VERIFY -->
