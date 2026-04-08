# 低干预审核发布

1. `risk-classification` 输出绿色/黄色/红色。
2. 绿色任务直接继续执行。
3. 黄色任务由 `human-gatekeeper` 请求确认后继续。
4. 红色任务由 `compliance-review` 和人工编辑共同处理。
5. `audit-trace` 全程记录。
