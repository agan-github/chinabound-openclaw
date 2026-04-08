# playbook

Purpose: operational playbook for `time-tagging`.

Use this skill when:
- the current session belongs to `time-tagging`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 提取发布时间、活动时间、有效期、节庆窗口、时段属性。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `rawObjects`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `timeTags`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
