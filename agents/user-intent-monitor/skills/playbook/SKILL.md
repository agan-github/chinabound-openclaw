# playbook

Purpose: operational playbook for `user-intent-monitor`.

Use this skill when:
- the current session belongs to `user-intent-monitor`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 分析站内搜索、问答、收藏、点击与跳失，识别用户需求缺口。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `behaviorSignals`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `intentFindings`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
