# playbook

Purpose: operational playbook for `geo-tagging`.

Use this skill when:
- the current session belongs to `geo-tagging`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 提取国家、省、市、景区、场馆、商圈等地理实体并标准化。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `rawObjects`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `geoTags`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
