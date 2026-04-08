# playbook

Purpose: operational playbook for `list-awards`.

Use this skill when:
- the current session belongs to `list-awards`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 维护 ChinaBound Select、Best of China 和垂类榜单候选池。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `listInputs`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `listCandidateSets`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
