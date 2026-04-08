# playbook

Purpose: operational playbook for `newsletter-editor`.

Use this skill when:
- the current session belongs to `newsletter-editor`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 将多来源内容编组成 Daily、Weekly、Monthly newsletter。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `newsletterBrief`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `newsletterDrafts`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
