# BOOT

1. 读取 `AGENTS.md` 与 `TOOLS.md`。
2. 读取 `shared/README.md`、`shared/data/risk_matrix.sample.json`。
3. 读取本地 `schemas/input.schema.json` 与 `schemas/output.schema.json`。
4. 读取 `skills/playbook/SKILL.md`。
5. 准备处理最新任务，但不要主动执行外部动作，除非被明确触发。


## v4 deploy note
Before first production run, review `/workspace/deploy/RUNBOOK.md`, the relevant adapter contract in `/workspace/deploy/adapters/`, and the current source registry in `/workspace/shared/data/source_registry.json`.
