# playbook

Purpose: operational playbook for `visual-script`.

Use this skill when:
- the current session belongs to `visual-script`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 为图解卡、短视频、社媒图文生成脚本和镜头结构。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `visualBrief`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `scriptDrafts`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
