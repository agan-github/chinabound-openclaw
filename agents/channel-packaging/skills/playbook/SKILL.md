# playbook

Purpose: operational playbook for `channel-packaging`.

Use this skill when:
- the current session belongs to `channel-packaging`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 将内容拆分为官网、App、消息推送、社媒和礼宾版本。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `contentPackages`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `channelPackages`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
