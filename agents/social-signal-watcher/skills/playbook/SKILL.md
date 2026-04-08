# playbook

Purpose: operational playbook for `social-signal-watcher`.

Use this skill when:
- the current session belongs to `social-signal-watcher`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 监测公开社交平台热点与反馈，作为辅助信号发现话题与问题。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `monitorTargets`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `signalDigest`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
