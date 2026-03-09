---
description: Continue next phase. Usage: /sdd-continue [change-name]
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
