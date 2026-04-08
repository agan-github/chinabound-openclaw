# playbook

Purpose: operational playbook for `messaging`.

Use this skill when:
- the current session belongs to `messaging`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 负责邮件、WhatsApp、站内信和通知类触达内容的发送。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `messagePackages`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `deliveryResults`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
