# playbook

Purpose: operational playbook for `freshness-conflict-checker`.

Use this skill when:
- the current session belongs to `freshness-conflict-checker`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 检查过期信息、冲突口径、死链和需更新项。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `candidateItems`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `validationResults`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
