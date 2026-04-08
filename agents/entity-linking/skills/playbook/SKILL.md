# playbook

Purpose: operational playbook for `entity-linking`.

Use this skill when:
- the current session belongs to `entity-linking`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 识别景点、机构、人物、活动等实体并关联知识对象。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `rawObjects`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `entityLinks`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
