# playbook

Purpose: operational playbook for `time-trigger`.

Use this skill when:
- the current session belongs to `time-trigger`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 根据 cron、节庆、周末、夜间等窗口触发内容生成和推送。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `scheduleEvents`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `triggerOutputs`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
