# Task 026: Define the SDD-Skillsmith Sub-Agent

**Priority**: High  
**Status**: Pending  
**Depends on**: 022-extension-contract-and-manifest-schema.md, 025-orchestrator-extension-hooks.md

---

## Objective

Create a specialized sub-agent that can design and scaffold extension packs in
a consistent, policy-compliant way.

## Deliverable

- `skills/sdd-skillsmith/SKILL.md`

## Scope

The skillsmith must:
- Translate use-case requirements into extension structure
- Generate manifest, rules, skills, checklists, and templates layout
- Follow extension schema and naming conventions
- Return a structured artifact map and next steps

It should support extension creation for multiple domains without embedding any
single domain as mandatory.

## Acceptance Criteria

- [ ] `skills/sdd-skillsmith/SKILL.md` exists
- [ ] Skill references extension schema and contract docs
- [ ] Output envelope includes generated artifacts and risks
- [ ] Rules prevent ad-hoc, non-standard extension structures
- [ ] Skill is domain-agnostic and reusable across use cases
