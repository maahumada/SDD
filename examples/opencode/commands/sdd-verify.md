---
description: Verify quality gate. Usage: /sdd-verify <change-name>
agent: SDD
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
