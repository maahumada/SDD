<!-- SDD:BEGIN adapter=OPENCODE_CMD_SDD_EXPLORE version=1 -->
---
description: Explore a topic. Usage: /sdd-explore -- <topic>
agent: SDD
---

Route this input through the SDD orchestrator as:

```text
/sdd-explore {argument}
```

Canonical argument format:

```text
-- <topic>
```

If the argument is missing or invalid, return usage help from
`docs/sdd-command-contract.md`.
<!-- SDD:END adapter=OPENCODE_CMD_SDD_EXPLORE -->
