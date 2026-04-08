# ChinaBound OpenClaw Agents V3

本工程是面向 ChinaBound 的 OpenClaw 多 agent 全量骨架，目标是支持“完全自动运行 + 低干预门控”的内容生产与自动化运营体系。

## 对齐的 OpenClaw 约定
本包按 OpenClaw 官方 agent workspace 约定组织：每个 agent workspace 都包含 `AGENTS.md`、`SOUL.md`、`USER.md`、`IDENTITY.md`、`TOOLS.md`、`HEARTBEAT.md`，并补充了可选的 `BOOT.md` 与 `MEMORY.md`。多 agent 配置集中在根目录 `openclaw.json`。共享 skills 通过 `skills.load.extraDirs` 接入，并使用 `agents.defaults.skills` / `agents.list[].skills` 做可见性控制。

## 目录
- `openclaw.json`: 全量 35-agent 配置。
- `agents/`: 每个 agent 的独立 workspace。
- `shared/`: 共享 schema、workflow、task、data。
- `shared-skills/`: 全局共享技能包。
- `manifest.v3.json`: 文件清单与版本信息。

## 部署建议
1. 将本目录放到 `~/chinabound-openclaw`。
2. 将 `openclaw.json` 链接或复制到 `~/.openclaw/openclaw.json`，或设置 `OPENCLAW_CONFIG_PATH=~/chinabound-openclaw/openclaw.json`。
3. 确认每个 `agents.list[].workspace` 与 `agents.list[].agentDir` 路径可写。
4. 按实际渠道补充 `bindings` 与 `channels.*.accounts`。
5. 执行 `openclaw agents list --bindings` 与 `openclaw channels status --probe` 验证路由和渠道状态。
6. 如启用 Docker sandbox，确认镜像、网络和 bind mounts 存在。

## 这份工程包含什么
- 全量 35 个 agents，其中原 12 个已同步升级。
- 每个 agent 都带本地 playbook skill、输入/输出 schema、sample task、workflow 说明。
- 全局共享 schema、流程 playbook、白名单样例、风险矩阵和渠道映射。


## v4 增补内容

本版新增了部署层文件，重点包括：

- `deploy/config/`：可直接替换占位符的配置碎片与 include 示例
- `deploy/cron/`：6 个递归任务清单与安装脚本
- `deploy/adapters/`：CMS、消息、审批、合作方 feed 适配器占位合同
- `shared/data/source_registry.json`：官方信源白名单 starter
- `.env.example`：常用环境变量样板

建议先用 `deploy/config/openclaw.with-includes.example.json5` 对照修改，再将你们的真实账号、token、审批流和 CMS 接口填入。

## 快速安装

### 一键安装（curl）
仓库中已经包含安装脚本 `scripts/install_chinabound_openclaw_from_github.sh`，可直接执行：

```bash
curl -fsSL https://raw.githubusercontent.com/agan-github/chinabound-openclaw/main/scripts/install_chinabound_openclaw_from_github.sh | bash
```

更稳妥的做法是先下载再执行：

```bash
curl -fsSL -o /tmp/install_chinabound_openclaw_from_github.sh https://raw.githubusercontent.com/agan-github/chinabound-openclaw/main/scripts/install_chinabound_openclaw_from_github.sh && bash /tmp/install_chinabound_openclaw_from_github.sh
```

### 安装后建议
1. 检查 `~/.openclaw/openclaw.json` 或 `OPENCLAW_CONFIG_PATH` 是否已指向本工程配置。
2. 补充 `.env`、渠道账号、CMS/审批/消息接口和官方信源白名单。
3. 执行 `openclaw agents list --bindings` 检查 agent 路由。
4. 执行 `openclaw channels status --probe` 检查通道状态。
5. 首轮先用 dry run，不要直接开启真实外发。
