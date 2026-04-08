#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR=""
TARGET_DIR="${HOME}/chinabound-openclaw"
CONFIG_MODE="symlink"
INSTALL_CRON="0"
SYNC_IDENTITIES="1"
FORCE="0"
DRY_RUN="0"

log() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
err() { printf '[ERROR] %s\n' "$*" >&2; }

run_cmd() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[DRYRUN]'
    for arg in "$@"; do printf ' %q' "$arg"; done
    printf '\n'
  else
    "$@"
  fi
}

usage() {
  cat <<'EOH'
Usage:
  install_all_agents.sh [options]

Options:
  --source <dir>         Source repo directory. Default: parent of this script.
  --target <dir>         Install target directory. Default: ~/chinabound-openclaw
  --config-mode <mode>   symlink | copy | env. Default: symlink
  --install-cron         Install bundled cron jobs if available.
  --no-identity-sync     Skip openclaw agents set-identity.
  --force                Allow overwrite where safe.
  --dry-run              Print actions without changing files.
  -h, --help             Show this help.
EOH
}

abspath() {
  python3 - "$1" <<'PY'
import os, sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE_DIR="$2"; shift 2 ;;
    --target) TARGET_DIR="$2"; shift 2 ;;
    --config-mode) CONFIG_MODE="$2"; shift 2 ;;
    --install-cron) INSTALL_CRON="1"; shift ;;
    --no-identity-sync) SYNC_IDENTITIES="0"; shift ;;
    --force) FORCE="1"; shift ;;
    --dry-run) DRY_RUN="1"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) err "Unknown option: $1"; usage; exit 2 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ -z "$SOURCE_DIR" ]]; then
  SOURCE_DIR="$REPO_DIR"
fi

SOURCE_DIR="$(abspath "$SOURCE_DIR")"
TARGET_DIR="$(abspath "$TARGET_DIR")"

case "$CONFIG_MODE" in
  symlink|copy|env) ;;
  *) err "Invalid --config-mode: $CONFIG_MODE"; exit 2 ;;
esac

if [[ ! -f "$SOURCE_DIR/openclaw.json" ]]; then
  err "openclaw.json not found in source dir: $SOURCE_DIR"
  exit 1
fi

log "Source: $SOURCE_DIR"
log "Target: $TARGET_DIR"

run_cmd mkdir -p "$TARGET_DIR"
run_cmd mkdir -p "${HOME}/.openclaw"

if [[ "$SOURCE_DIR" != "$TARGET_DIR" ]]; then
  if command -v rsync >/dev/null 2>&1; then
    log "Syncing repo to target via rsync"
    run_cmd rsync -a --delete \
      --exclude '.git' \
      --exclude '.github' \
      "$SOURCE_DIR/" "$TARGET_DIR/"
  else
    log "Syncing repo to target via cp"
    run_cmd cp -R "$SOURCE_DIR/." "$TARGET_DIR/"
  fi
else
  log "Source and target are the same; skipping file sync"
fi

CONFIG_SRC="$TARGET_DIR/openclaw.json"
CONFIG_DST="${HOME}/.openclaw/openclaw.json"

case "$CONFIG_MODE" in
  symlink)
    if [[ -e "$CONFIG_DST" || -L "$CONFIG_DST" ]]; then
      if [[ "$FORCE" == "1" ]]; then
        run_cmd rm -f "$CONFIG_DST"
      else
        warn "$CONFIG_DST already exists; keeping it. Use --force to replace."
      fi
    fi
    if [[ ! -e "$CONFIG_DST" && ! -L "$CONFIG_DST" ]]; then
      log "Linking config to $CONFIG_DST"
      run_cmd ln -s "$CONFIG_SRC" "$CONFIG_DST"
    fi
    ;;
  copy)
    log "Copying config to $CONFIG_DST"
    run_cmd cp "$CONFIG_SRC" "$CONFIG_DST"
    ;;
  env)
    warn "CONFIG_MODE=env selected; not writing ~/.openclaw/openclaw.json"
    warn "Use: export OPENCLAW_CONFIG_PATH=\"$CONFIG_SRC\""
    ;;
esac

if command -v openclaw >/dev/null 2>&1; then
  if [[ "$CONFIG_MODE" == "env" ]]; then
    export OPENCLAW_CONFIG_PATH="$CONFIG_SRC"
  fi

  log "Validating config"
  run_cmd openclaw config validate || warn "Config validation reported issues"

  if [[ "$SYNC_IDENTITIES" == "1" ]]; then
    log "Syncing agent identities"
    run_cmd openclaw agents set-identity --from-identity || warn "Identity sync skipped/failed"
  fi

  if [[ "$INSTALL_CRON" == "1" ]]; then
    if [[ -x "$TARGET_DIR/deploy/cron/install_all.sh" ]]; then
      log "Installing bundled cron jobs"
      run_cmd bash "$TARGET_DIR/deploy/cron/install_all.sh" || warn "Cron install skipped/failed"
    else
      warn "No cron installer found at $TARGET_DIR/deploy/cron/install_all.sh"
    fi
  fi
else
  warn "openclaw CLI not found; files installed, but validate/identity/cron were skipped"
fi

echo
echo "Install complete"
echo "----------------"
echo "Source : $SOURCE_DIR"
echo "Target : $TARGET_DIR"
echo "Config : $CONFIG_MODE"
echo
echo "Next:"
echo "1. Fill $TARGET_DIR/.env"
echo "2. Fill deploy/config/*.example.json5 or your include files"
echo "3. Populate shared/data/source_registry.json"
echo "4. Keep channels disabled until dry run passes"
