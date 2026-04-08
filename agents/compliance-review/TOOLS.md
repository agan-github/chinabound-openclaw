# TOOLS

你的实际工具权限由根目录 `openclaw.json` 控制；本文件只提供使用约定。

## 本 agent 的建议做法
- 先读 `shared/schemas/`、`shared/data/` 与本地 `schemas/`。
- 需要跨 agent 协作时，优先输出符合 `agent-handoff.schema.json` 的 payload。
- 只在职责范围内写文件，避免覆盖其他 agent workspace。
- 如拥有 web/browser 能力，优先抓取白名单源；如无此能力，不要尝试越权访问外网。

## 常见输出位置
- `tasks/`: 示例输入和回放任务
- `workflows/`: 本 agent 的流程说明
- `schemas/`: 本 agent 的输入/输出契约
