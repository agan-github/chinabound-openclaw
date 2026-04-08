# playbook

Purpose: operational playbook for `localization`.

Use this skill when:
- the current session belongs to `localization`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 进行英文主稿和其他重点语种的跨文化改写与润色。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `localizedInputs`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `localizedPackages`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
