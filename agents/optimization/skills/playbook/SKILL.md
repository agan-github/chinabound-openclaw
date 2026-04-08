# playbook

Purpose: operational playbook for `optimization`.

Use this skill when:
- the current session belongs to `optimization`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 根据数据反馈优化模板、分发策略、选题结构和工作流。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `performanceReports`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `optimizationActions`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
