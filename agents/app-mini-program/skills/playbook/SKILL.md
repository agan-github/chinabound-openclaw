# playbook

Purpose: operational playbook for `app-mini-program`.

Use this skill when:
- the current session belongs to `app-mini-program`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 负责 App、小程序、站内卡片和入口位的发布同步。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `appPackages`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `publishResults`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
