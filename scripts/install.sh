#!/usr/bin/env bash
set -euo pipefail

# ChinaBound OpenClaw installer
# Assumes project source is already present locally (default: /root/chinabound-openclaw)

REPO_DIR="${REPO_DIR:-/root/chinabound-openclaw}"
CONFIG_MODE="${CONFIG_MODE:-symlink}"   # symlink | copy | env
INSTALL_CRON=0
SYNC_IDENTITIES=1
VALIDATE_CONFIG=1
FORCE=0
DRY_RUN=0
NO_COLOR=0
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"

if [[ -t 1 ]]; then
  C_RESET='\033[0m'
  C_RED='\033[31m'
  C_GREEN='\033[32m'
  C_YELLOW='\033[33m'
  C_BLUE='\033[34m'
else
  C_RESET=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''
fi

log()  { printf "%b[INFO]%b %s\n"  "$C_BLUE" "$C_RESET" "$*"; }
ok()   { printf "%b[ OK ]%b %s\n"  "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf "%b[WARN]%b %s\n"  "$C_YELLOW" "$C_RESET" "$*" >&2; }
err()  { printf "%b[ERR ]%b %s\n"  "$C_RED" "$C_RESET" "$*" >&2; }

die() {
  err "$*"
  exit 1
}

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
  cat <<'USAGE'
Usage:
  bash install.sh [options]

Options:
  --repo-dir <dir>        Project directory. Default: /root/chinabound-openclaw
  --config-mode <mode>    symlink | copy | env. Default: symlink
  --install-cron          Install bundled cron jobs if available
  --no-identity-sync      Skip `openclaw agents set-identity --from-identity`
  --no-validate           Skip `openclaw config validate`
  --force                 Overwrite existing ~/.openclaw/openclaw.json if needed
  --dry-run               Print actions only, do not modify files
  --no-color              Disable colored output
  -h, --help              Show this help

Environment variables:
  REPO_DIR=/root/chinabound-openclaw
  CONFIG_MODE=symlink
  OPENCLAW_HOME=$HOME/.openclaw
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-dir)
      REPO_DIR="$2"; shift 2 ;;
    --config-mode)
      CONFIG_MODE="$2"; shift 2 ;;
    --install-cron)
      INSTALL_CRON=1; shift ;;
    --no-identity-sync)
      SYNC_IDENTITIES=0; shift ;;
    --no-validate)
      VALIDATE_CONFIG=0; shift ;;
    --force)
      FORCE=1; shift ;;
    --dry-run)
      DRY_RUN=1; shift ;;
    --no-color)
      NO_COLOR=1; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      usage
      die "Unknown option: $1"
      ;;
  esac
done

if [[ "$NO_COLOR" == "1" ]]; then
  C_RESET=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''
fi

case "$CONFIG_MODE" in
  symlink|copy|env) ;;
  *) die "Invalid --config-mode: $CONFIG_MODE (use symlink, copy, or env)" ;;
esac

[[ -d "$REPO_DIR" ]] || die "Project directory not found: $REPO_DIR"
[[ -f "$REPO_DIR/openclaw.json" ]] || die "Missing $REPO_DIR/openclaw.json"

log "Using project directory: $REPO_DIR"
log "OpenClaw home: $OPENCLAW_HOME"
log "Config mode: $CONFIG_MODE"

run_cmd mkdir -p "$OPENCLAW_HOME"
run_cmd mkdir -p "$OPENCLAW_HOME/logs"
run_cmd mkdir -p "$OPENCLAW_HOME/cron"
run_cmd mkdir -p "$OPENCLAW_HOME/cache"

CONFIG_SRC="$REPO_DIR/openclaw.json"
CONFIG_DST="$OPENCLAW_HOME/openclaw.json"

install_config() {
  case "$CONFIG_MODE" in
    symlink)
      if [[ -L "$CONFIG_DST" ]]; then
        local current
        current="$(readlink "$CONFIG_DST" || true)"
        if [[ "$current" == "$CONFIG_SRC" ]]; then
          ok "Config symlink already correct: $CONFIG_DST -> $CONFIG_SRC"
          return 0
        fi
        if [[ "$FORCE" == "1" ]]; then
          run_cmd rm -f "$CONFIG_DST"
        else
          die "$CONFIG_DST already exists and points elsewhere. Use --force to replace."
        fi
      elif [[ -e "$CONFIG_DST" ]]; then
        if [[ "$FORCE" == "1" ]]; then
          run_cmd rm -f "$CONFIG_DST"
        else
          die "$CONFIG_DST already exists. Use --force to replace."
        fi
      fi
      run_cmd ln -s "$CONFIG_SRC" "$CONFIG_DST"
      ok "Config linked: $CONFIG_DST -> $CONFIG_SRC"
      ;;
    copy)
      if [[ -e "$CONFIG_DST" && "$FORCE" != "1" ]]; then
        die "$CONFIG_DST already exists. Use --force to overwrite."
      fi
      run_cmd cp "$CONFIG_SRC" "$CONFIG_DST"
      ok "Config copied to $CONFIG_DST"
      ;;
    env)
      warn "CONFIG_MODE=env selected. No file written to $CONFIG_DST"
      printf '\nexport OPENCLAW_CONFIG_PATH=%q\n\n' "$CONFIG_SRC"
      ;;
  esac
}

install_env_hint() {
  if [[ -f "$REPO_DIR/.env.example" && ! -f "$REPO_DIR/.env" ]]; then
    warn "Detected .env.example but no .env"
    warn "Create one with: cp '$REPO_DIR/.env.example' '$REPO_DIR/.env'"
  fi
}

validate_openclaw_cli() {
  if command -v openclaw >/dev/null 2>&1; then
    ok "Found openclaw CLI"
    return 0
  fi
  warn "openclaw CLI not found in PATH"
  warn "Files can still be installed, but validate/identity/cron steps will be skipped"
  return 1
}

run_validation() {
  [[ "$VALIDATE_CONFIG" == "1" ]] || return 0
  if command -v openclaw >/dev/null 2>&1; then
    if [[ "$CONFIG_MODE" == "env" ]]; then
      export OPENCLAW_CONFIG_PATH="$CONFIG_SRC"
    fi
    log "Validating OpenClaw config"
    if run_cmd openclaw config validate; then
      ok "Config validation completed"
    else
      warn "Config validation reported issues"
    fi
  fi
}

sync_identities() {
  [[ "$SYNC_IDENTITIES" == "1" ]] || return 0
  if command -v openclaw >/dev/null 2>&1; then
    if [[ "$CONFIG_MODE" == "env" ]]; then
      export OPENCLAW_CONFIG_PATH="$CONFIG_SRC"
    fi
    log "Syncing agent identities from workspace"
    if run_cmd openclaw agents set-identity --from-identity; then
      ok "Agent identities synced"
    else
      warn "Identity sync skipped or failed"
    fi
  fi
}

install_cron_jobs() {
  [[ "$INSTALL_CRON" == "1" ]] || return 0
  local cron_installer="$REPO_DIR/deploy/cron/install_all.sh"
  if [[ ! -x "$cron_installer" && ! -f "$cron_installer" ]]; then
    warn "Bundled cron installer not found: $cron_installer"
    return 0
  fi
  if ! command -v openclaw >/dev/null 2>&1; then
    warn "Skipping cron installation because openclaw CLI is unavailable"
    return 0
  fi
  log "Installing bundled cron jobs"
  if run_cmd bash "$cron_installer"; then
    ok "Cron jobs installed"
  else
    warn "Cron installer returned a non-zero status"
  fi
}

print_next_steps() {
  cat <<EOF

Install complete.

Project directory : $REPO_DIR
OpenClaw home     : $OPENCLAW_HOME
Config mode       : $CONFIG_MODE

Recommended next steps:
  1. Fill $REPO_DIR/.env (if your deployment uses it)
  2. Review deploy/config/*.example.json5
  3. Populate shared/data/source_registry.json
  4. Keep external channels disabled until dry run passes
  5. Run a dry run from the repo before enabling cron

Useful commands:
  cd $REPO_DIR
  openclaw config validate
  openclaw agents list
EOF

  if [[ "$CONFIG_MODE" == "env" ]]; then
    printf '  export OPENCLAW_CONFIG_PATH=%q\n' "$CONFIG_SRC"
  fi

  printf '\n'
}

install_config
install_env_hint
validate_openclaw_cli || true
run_validation
sync_identities
install_cron_jobs
print_next_steps
