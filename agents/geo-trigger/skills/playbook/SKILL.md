# playbook

Purpose: operational playbook for `geo-trigger`.

Use this skill when:
- the current session belongs to `geo-trigger`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 根据用户位置或目的地位置触发附近内容和周边路线。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `geoEvents`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `triggerOutputs`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
