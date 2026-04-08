# playbook

Purpose: operational playbook for `public-source-crawler`.

Use this skill when:
- the current session belongs to `public-source-crawler`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 抓取官方站点、RSS、页面与公开 API，输出原始结构化内容。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `crawlRequests`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `feedItems`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
