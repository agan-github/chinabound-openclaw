# playbook

Purpose: operational playbook for `ai-concierge-knowledge-card`.

Use this skill when:
- the current session belongs to `ai-concierge-knowledge-card`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 沉淀 AI 礼宾可调用的问答卡、提醒卡、路线卡和服务卡。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `faqInputs`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `conciergeCards`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
