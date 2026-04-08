# playbook

Purpose: operational playbook for `human-gatekeeper`.

Use this skill when:
- the current session belongs to `human-gatekeeper`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 在高风险或高价值任务节点发起人工审批和接管。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `approvalRequests`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `approvalDecisions`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
