# playbook

Purpose: operational playbook for `audit-trace`.

Use this skill when:
- the current session belongs to `audit-trace`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 记录来源、版本、决策路径、异常和回滚信息，支撑审计。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `auditEvents`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `auditEntries`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
