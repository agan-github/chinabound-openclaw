#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
JOBS_DIR="${ROOT_DIR}/deploy/cron/jobs"

echo "[INFO] installing ChinaBound cron jobs from ${JOBS_DIR}"

openclaw cron add --name "Source registry sync" --cron "0 */6 * * *" --tz "Asia/Shanghai" --agent "official-source-registry" --session isolated --message "Sync official source registry health, freshness, and crawl policy changes for ChinaBound." --no-deliver
openclaw cron add --name "Crawl national official signals" --cron "*/30 * * * *" --tz "Asia/Shanghai" --agent "public-source-crawler" --session isolated --message "Crawl approved national-level official sources and write structured updates for downstream tagging." --no-deliver
openclaw cron add --name "Crawl city official signals" --cron "15 * * * *" --tz "Asia/Shanghai" --agent "public-source-crawler" --session isolated --message "Crawl approved municipal and venue-level sources for active ChinaBound cities." --no-deliver
openclaw cron add --name "Weekly city packages" --cron "0 6 * * 1" --tz "Asia/Shanghai" --agent "chief-orchestrator" --session isolated --message "Generate weekly city package tasks for all enabled destinations and route outputs for packaging." --no-deliver
openclaw cron add --name "Daily alerts" --cron "0 8 * * *" --tz "Asia/Shanghai" --agent "messaging" --session isolated --message "Publish approved low-risk daily service alerts to the configured delivery channel." --announce --channel telegram --to "direct:REPLACE_OPERATOR_OR_CHANNEL"
openclaw cron add --name "Review digest" --cron "0 9 * * *" --tz "Asia/Shanghai" --agent "human-gatekeeper" --session isolated --message "Assemble yellow and red queue items into a human review digest and deliver to the review account." --announce --channel telegram --to "direct:REPLACE_REVIEW_TARGET"

echo "[INFO] done. run 'openclaw cron list' to verify."
