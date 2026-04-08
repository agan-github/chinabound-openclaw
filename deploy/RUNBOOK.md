# ChinaBound OpenClaw v4 Runbook

## 1. Preflight

- confirm the Gateway can load `openclaw.json`
- confirm required auth profiles exist
- confirm sandbox image exists on the deployment host
- confirm the enabled channel accounts are still disabled until credentials are filled
- confirm the source registry has only approved official sources

## 2. First deployment order

1. `official-source-registry`
2. `public-source-crawler`
3. `geo-tagging`
4. `time-tagging`
5. `freshness-conflict-checker`
6. `assignment-planner`
7. `channel-packaging`
8. `website-publishing`
9. `messaging`
10. `human-gatekeeper`
11. `audit-trace`
12. `chief-orchestrator`

## 3. Dry-run checklist

- crawl one low-risk official event page
- generate one utility guide draft
- package one website payload and one message payload
- open one approval ticket
- confirm audit trail was written
- confirm no live channel delivery occurred

## 4. Cutover checklist

- enable one delivery account at a time
- start with alert-only or internal-review delivery
- monitor cron runs and task states
- check task backoff after failures
- verify rollback path for publishing adapters

## 5. Emergency stop

- disable delivery accounts in channel config
- pause cron installs or remove recurring jobs
- route all yellow/red work to `human-gatekeeper`
- set all publishing adapters to dry-run mode
