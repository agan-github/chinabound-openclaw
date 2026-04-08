# playbook

Purpose: operational playbook for `chief-orchestrator`.

Use this skill when:
- the current session belongs to `chief-orchestrator`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 负责路由任务、调度专业 agents、控制审核门、处理异常与汇总执行报告。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `incomingTasks`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `executionPlan`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
