# playbook

Purpose: operational playbook for `destination-story`.

Use this skill when:
- the current session belongs to `destination-story`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 生成国家地理风格的目的地故事、文化延展与文明互鉴叙事。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `storyBrief`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `storyDrafts`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
