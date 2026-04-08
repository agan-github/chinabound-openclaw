# playbook

Purpose: operational playbook for `knowledge-graph-update`.

Use this skill when:
- the current session belongs to `knowledge-graph-update`;
- you need the canonical responsibilities, inputs, outputs, and escalation rules for this agent.

Responsibilities:
- 把新增内容写入知识对象、事实卡、问答卡、路线卡与实体关系。
- keep payloads compatible with `shared/schemas/`
- preserve traceability fields
- escalate out-of-scope or high-risk work

Required inputs:
- `knowledgeInputs`
- shared context from `shared/data/`
- any upstream handoff notes

Required outputs:
- `knowledgeUpdates`
- concise execution summary
- next-hop handoff recommendation

Escalate to:
- yellow/red tasks -> `human-gatekeeper`
- policy/commercial/privacy issues -> `compliance-review`
- routing or retry issues -> `chief-orchestrator`
