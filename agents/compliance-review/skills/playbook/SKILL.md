# playbook

Purpose: operational playbook for `compliance-review`.

Use this skill when:
- the current session belongs to `compliance-review`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 审核敏感内容、跨境数据、用户隐私、商业承诺与政策口径。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `reviewTargets`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `complianceDecisions`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
