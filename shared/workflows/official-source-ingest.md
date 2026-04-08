# 官方信源自动抓取流水线

1. `official-source-registry` 选择活跃白名单信源并生成抓取计划。
2. `public-source-crawler` 或 `partner-feed-ingestion` 抓取内容并产出 feed item。
3. `freshness-conflict-checker` 去重、查过期、查口径冲突。
4. `geo-tagging`、`time-tagging`、`entity-linking` 提取结构化标签。
5. `knowledge-graph-update` 写入事实对象。
6. `assignment-planner` 判断是否触发内容任务。
