<!-- SDD:BEGIN adapter=OPENCODE_CMD_SDD_CONTINUE version=1 -->
---
description: Continue the next dependency-ready SDD phase
agent: sdd-orchestrator
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
<!-- SDD:END adapter=OPENCODE_CMD_SDD_CONTINUE -->
