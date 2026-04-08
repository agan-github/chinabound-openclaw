# playbook

Purpose: operational playbook for `utility-guide`.

Use this skill when:
- the current session belongs to `utility-guide`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 生成签证、支付、交通、预约和行前行中服务型内容。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `guideBrief`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `guideDrafts`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
