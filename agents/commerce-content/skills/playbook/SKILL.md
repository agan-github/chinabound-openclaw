# playbook

Purpose: operational playbook for `commerce-content`.

Use this skill when:
- the current session belongs to `commerce-content`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 把权益、联名、商户和产品信息转化为可交易内容。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `commerceBrief`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `commerceDrafts`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
