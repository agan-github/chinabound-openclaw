# Agent Index

共 35 个 agents：

- `chief-orchestrator` / 总控编排官 / stage=orchestrate — 负责路由任务、调度专业 agents、控制审核门、处理异常与汇总执行报告。
- `official-source-registry` / 官方信源注册官 / stage=ingest — 维护官方信源白名单、抓取频率、可信等级、更新策略与失效检测。
- `public-source-crawler` / 公共信源抓取官 / stage=ingest — 抓取官方站点、RSS、页面与公开 API，输出原始结构化内容。
- `partner-feed-ingestion` / 合作信源接入官 / stage=ingest — 接入合作方 API、邮件订阅和内容同步接口，标准化合作数据。
- `social-signal-watcher` / 社交信号观察官 / stage=sense — 监测公开社交平台热点与反馈，作为辅助信号发现话题与问题。
- `user-intent-monitor` / 用户意图监测官 / stage=sense — 分析站内搜索、问答、收藏、点击与跳失，识别用户需求缺口。
- `geo-tagging` / 地理标签官 / stage=understand — 提取国家、省、市、景区、场馆、商圈等地理实体并标准化。
- `time-tagging` / 时间标签官 / stage=understand — 提取发布时间、活动时间、有效期、节庆窗口、时段属性。
- `entity-linking` / 实体链接官 / stage=understand — 识别景点、机构、人物、活动等实体并关联知识对象。
- `risk-classification` / 风险分级官 / stage=govern — 按导向、事实、版权、商业、隐私等维度评定风险等级。
- `knowledge-graph-update` / 知识图谱更新官 / stage=understand — 把新增内容写入知识对象、事实卡、问答卡、路线卡与实体关系。
- `freshness-conflict-checker` / 新鲜度与冲突校验官 / stage=govern — 检查过期信息、冲突口径、死链和需更新项。
- `assignment-planner` / 选题与任务策划官 / stage=produce — 把信号转为选题、任务包、优先级与内容体裁建议。
- `destination-story` / 目的地叙事官 / stage=produce — 生成国家地理风格的目的地故事、文化延展与文明互鉴叙事。
- `utility-guide` / 实用攻略官 / stage=produce — 生成签证、支付、交通、预约和行前行中服务型内容。
- `itinerary-composer` / 路线编排官 / stage=produce — 按地点、时长、预算和人群偏好生成 itinerary 与路线卡。
- `list-awards` / 榜单与评选官 / stage=produce — 维护 ChinaBound Select、Best of China 和垂类榜单候选池。
- `commerce-content` / 导购内容官 / stage=produce — 把权益、联名、商户和产品信息转化为可交易内容。
- `newsletter-editor` / 邮件刊编辑官 / stage=produce — 将多来源内容编组成 Daily、Weekly、Monthly newsletter。
- `ai-concierge-knowledge-card` / 礼宾知识卡官 / stage=produce — 沉淀 AI 礼宾可调用的问答卡、提醒卡、路线卡和服务卡。
- `visual-script` / 视觉与短视频脚本官 / stage=produce — 为图解卡、短视频、社媒图文生成脚本和镜头结构。
- `localization` / 多语种本地化官 / stage=produce — 进行英文主稿和其他重点语种的跨文化改写与润色。
- `channel-packaging` / 渠道封装官 / stage=distribute — 将内容拆分为官网、App、消息推送、社媒和礼宾版本。
- `website-publishing` / 官网发布官 / stage=distribute — 负责官网、专题页、城市页和榜单页的发布与更新编排。
- `app-mini-program` / 应用端发布官 / stage=distribute — 负责 App、小程序、站内卡片和入口位的发布同步。
- `messaging` / 消息触达官 / stage=distribute — 负责邮件、WhatsApp、站内信和通知类触达内容的发送。
- `social-distribution` / 社媒分发官 / stage=distribute — 负责多平台社媒文案、短帖和短视频分发封装。
- `geo-trigger` / 地理触发官 / stage=trigger — 根据用户位置或目的地位置触发附近内容和周边路线。
- `time-trigger` / 时间触发官 / stage=trigger — 根据 cron、节庆、周末、夜间等窗口触发内容生成和推送。
- `compliance-review` / 合规审核官 / stage=govern — 审核敏感内容、跨境数据、用户隐私、商业承诺与政策口径。
- `editorial-policy` / 编辑规范官 / stage=govern — 统一标题逻辑、品牌语气、栏目规范和编辑体例。
- `human-gatekeeper` / 人工门控官 / stage=govern — 在高风险或高价值任务节点发起人工审批和接管。
- `performance-analyst` / 绩效分析官 / stage=optimize — 统计打开率、点击率、转化率、问答调用等效果指标。
- `optimization` / 优化迭代官 / stage=optimize — 根据数据反馈优化模板、分发策略、选题结构和工作流。
- `audit-trace` / 审计追踪官 / stage=govern — 记录来源、版本、决策路径、异常和回滚信息，支撑审计。


## v4 deployment-aware notes

- `chief-orchestrator` now assumes cron-installed recurring jobs may wake it in isolated sessions.
- `official-source-registry` should treat `shared/data/source_registry.json` as the production starter file.
- `website-publishing` and `messaging` should prefer the contracts in `deploy/adapters/`.
- `human-gatekeeper` should open external approval tickets through `deploy/adapters/approval-generic/`.
