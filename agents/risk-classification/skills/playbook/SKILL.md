# playbook

Purpose: operational playbook for `risk-classification`.

Use this skill when:
- the current session belongs to `risk-classification`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 按导向、事实、版权、商业、隐私等维度评定风险等级。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `reviewTargets`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `riskReviews`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
