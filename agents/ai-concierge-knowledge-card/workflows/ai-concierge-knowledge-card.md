# ai-concierge-knowledge-card workflow

## 典型输入
- `faqInputs`

## 处理步骤
1. 读取本地输入 schema。
2. 校验 task 与来源字段完整性。
3. 执行 礼宾知识卡官 的核心处理。
4. 将结果写成 `conciergeCards`。
5. 给出 handoff 建议和风险结论。
6. 必要时要求 `audit-trace` 记录，或发起 `human-gatekeeper` 门控。

## 上游/下游
- 上游：utility-guide, itinerary-composer, freshness-conflict-checker
- 下游：knowledge-graph-update, messaging, app-mini-program
