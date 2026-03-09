# Task 018: Add Adapter Update Script and Version Stamp

**Priority**: Medium  
**Status**: Pending  
**Depends on**: 016-adapter-template-pack.md, 017-installer-script-for-adapters.md

---

## Objective

Create an update workflow for already-installed adapters and add version stamping
to track template provenance.

## Deliverables

- `scripts/sdd-update.sh`
- Version stamp convention in managed blocks

## Scope

`sdd-update.sh` should:
- Reapply current templates to an installed project
- Detect and update only SDD-managed blocks
- Report per-file results: updated/unchanged/skipped/conflict
- Reuse installer logic where possible

Managed block version stamp example:

```
<!-- SDD:BEGIN adapter=CLAUDE version=1 -->
...
<!-- SDD:END adapter=CLAUDE -->
```

## Acceptance Criteria

- [ ] File created at `scripts/sdd-update.sh`
- [ ] Update script supports `--project`, `--adapters`, and `--dry-run`
- [ ] Managed block version stamp format is documented and applied
- [ ] Conflicts are detected and reported without destructive overwrite
- [ ] Update process reuses shared logic with installer where reasonable
