#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] remove jobs manually after checking IDs:"
openclaw cron list
echo "[INFO] for each job id:"
echo "openclaw cron delete <job-id>"
