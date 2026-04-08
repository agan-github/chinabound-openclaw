# ChinaBound OpenClaw v4 Deploy Layer

This folder adds the deployment layer that sits on top of the 35-agent workspace pack.

It is designed for four tasks:

1. wire real channel accounts and route them with `bindings`
2. install recurring jobs with the Gateway cron scheduler
3. populate the official-source registry used by the crawler pipeline
4. connect publishing, messaging, approvals, and partner feeds through adapter contracts

## Folder map

- `config/` — include-ready OpenClaw config fragments and full example config
- `cron/` — install scripts and job manifests
- `adapters/` — placeholder contracts for CMS, messaging, approvals, and partner HTTP feeds
- `runbooks/` — operational guidance for first deployment and cutover

## Intended workflow

1. Review `config/openclaw.with-includes.example.json5`
2. Replace placeholders in `config/*.example.json5`
3. Populate `shared/data/source_registry.json`
4. Connect adapter implementations in `deploy/adapters/*`
5. Install cron jobs from `deploy/cron/install_all.sh`
6. Run a dry-run with `chief-orchestrator`, `public-source-crawler`, `channel-packaging`, `messaging`, and `human-gatekeeper`
