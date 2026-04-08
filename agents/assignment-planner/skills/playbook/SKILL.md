# playbook

Purpose: operational playbook for `assignment-planner`.

Use this skill when:
- the current session belongs to `assignment-planner`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 把信号转为选题、任务包、优先级与内容体裁建议。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `signals`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `assignmentBriefs`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
