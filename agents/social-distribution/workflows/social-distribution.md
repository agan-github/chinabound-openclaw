# social-distribution workflow

## 典型输入
- `socialPackages`

## 处理步骤
1. 读取本地输入 schema。
2. 校验 task 与来源字段完整性。
3. 执行 社媒分发官 的核心处理。
4. 将结果写成 `distributionResults`。
5. 给出 handoff 建议和风险结论。
6. 必要时要求 `audit-trace` 记录，或发起 `human-gatekeeper` 门控。

## 上游/下游
- 上游：channel-packaging, visual-script, human-gatekeeper
- 下游：performance-analyst, audit-trace
