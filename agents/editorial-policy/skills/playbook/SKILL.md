# playbook

Purpose: operational playbook for `editorial-policy`.

Use this skill when:
- the current session belongs to `editorial-policy`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 统一标题逻辑、品牌语气、栏目规范和编辑体例。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `contentCandidates`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `policyEdits`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
