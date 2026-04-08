#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/agan-github/chinabound-openclaw.git"
TARGET_DIR="${HOME}/chinabound-openclaw"
CONFIG_MODE="symlink"
INSTALL_CRON="0"
SYNC_IDENTITIES="1"
FORCE="0"
DRY_RUN="0"
BRANCH=""
REF=""
GIT_DEPTH="1"

usage() {
  cat <<'EOF'
Usage:
  install_chinabound_openclaw_from_github.sh [options]

Options:
  --repo-url <url>       Git repository URL.
                         Default: https://github.com/agan-github/chinabound-openclaw.git
  --target <dir>         Clone/update target directory. Default: ~/chinabound-openclaw
  --branch <name>        Clone a specific branch. If omitted, use the repo default branch.
  --ref <name>           After clone/fetch, checkout a specific ref: branch, tag, or commit.
  --git-depth <n>        Shallow clone depth. Default: 1
  --config-mode <mode>   Pass through to inner installer: symlink | copy | env. Default: symlink
  --install-cron         Pass through to inner installer.
  --no-identity-sync     Pass through to inner installer.
  --force                Allow overwrite/update behaviors where safe.
  --dry-run              Print actions without changing files.
  -h, --help             Show this help.

What this script does:
  1. Clones or updates the ChinaBound OpenClaw repo from GitHub.
  2. Optionally checks out a specific ref.
  3. Runs the repo's bundled installer at scripts/install_all_agents.sh.

Notes:
  * If the repository is private, authenticate git first (SSH, gh auth, or credential helper),
    or pass an authenticated --repo-url.
  * The inner installer still expects you to fill .env and deploy/config placeholders afterward.
EOF
}

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

abspath() {
  python3 - "$1" <<'PY'
import os, sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-url)
      REPO_URL="$2"; shift 2 ;;
    --target)
      TARGET_DIR="$2"; shift 2 ;;
    --branch)
      BRANCH="$2"; shift 2 ;;
    --ref)
      REF="$2"; shift 2 ;;
    --git-depth)
      GIT_DEPTH="$2"; shift 2 ;;
    --config-mode)
      CONFIG_MODE="$2"; shift 2 ;;
    --install-cron)
      INSTALL_CRON="1"; shift ;;
    --no-identity-sync)
      SYNC_IDENTITIES="0"; shift ;;
    --force)
      FORCE="1"; shift ;;
    --dry-run)
      DRY_RUN="1"; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      err "Unknown option: $1"
      usage
      exit 2 ;;
  esac
done

case "$CONFIG_MODE" in
  symlink|copy|env) ;;
  *) err "Invalid --config-mode: ${CONFIG_MODE}"; exit 2 ;;
esac

if ! command -v git >/dev/null 2>&1; then
  err "git is required"
  exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  err "python3 is required"
  exit 1
fi

TARGET_DIR="$(abspath "$TARGET_DIR")"
PARENT_DIR="$(dirname "$TARGET_DIR")"
REPO_DIR="$TARGET_DIR"

clone_repo() {
  log "Cloning repository into $REPO_DIR"
  run_cmd mkdir -p "$PARENT_DIR"
  local -a cmd=(git clone)
  if [[ -n "$BRANCH" ]]; then
    cmd+=(--branch "$BRANCH")
  fi
  if [[ -n "$GIT_DEPTH" ]]; then
    cmd+=(--depth "$GIT_DEPTH")
  fi
  cmd+=("$REPO_URL" "$REPO_DIR")
  run_cmd "${cmd[@]}"
}

update_repo() {
  log "Updating existing repository in $REPO_DIR"
  local current_remote
  current_remote="$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || true)"
  if [[ -z "$current_remote" ]]; then
    err "Existing git repo has no origin remote: $REPO_DIR"
    exit 1
  fi
  if [[ "$current_remote" != "$REPO_URL" ]]; then
    if [[ "$FORCE" == "1" ]]; then
      run_cmd git -C "$REPO_DIR" remote set-url origin "$REPO_URL"
    else
      err "Existing repo remote differs from --repo-url. Use --force to update origin."
      err "Current origin: $current_remote"
      err "Requested    : $REPO_URL"
      exit 1
    fi
  fi

  run_cmd git -C "$REPO_DIR" fetch --tags origin

  if [[ -n "$BRANCH" ]]; then
    run_cmd git -C "$REPO_DIR" checkout "$BRANCH"
    run_cmd git -C "$REPO_DIR" pull --ff-only origin "$BRANCH"
  else
    local current_branch
    current_branch="$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
    if [[ -n "$current_branch" && "$current_branch" != "HEAD" ]]; then
      run_cmd git -C "$REPO_DIR" pull --ff-only origin "$current_branch"
    else
      warn "Detached HEAD detected; skipping branch pull. Use --ref or --branch if you want a specific checkout."
    fi
  fi
}

checkout_ref() {
  if [[ -z "$REF" ]]; then
    return 0
  fi
  log "Checking out ref: $REF"
  run_cmd git -C "$REPO_DIR" fetch --tags origin
  run_cmd git -C "$REPO_DIR" checkout "$REF"
}

ensure_repo() {
  if [[ ! -e "$REPO_DIR" ]]; then
    clone_repo
    return 0
  fi

  if [[ -d "$REPO_DIR/.git" ]]; then
    update_repo
    return 0
  fi

  if [[ "$FORCE" == "1" ]]; then
    warn "Target exists but is not a git repo. Removing because --force was set: $REPO_DIR"
    run_cmd rm -rf "$REPO_DIR"
    clone_repo
  else
    err "Target exists and is not a git repository: $REPO_DIR"
    err "Re-run with --force to replace it, or choose a different --target."
    exit 1
  fi
}

find_inner_installer() {
  local candidates=(
    "$REPO_DIR/scripts/install_all_agents.sh"
    "$REPO_DIR/install_chinabound_openclaw_agents.sh"
    "$REPO_DIR/scripts/install_chinabound_openclaw_agents.sh"
  )
  local c
  for c in "${candidates[@]}"; do
    if [[ -f "$c" ]]; then
      printf '%s\n' "$c"
      return 0
    fi
  done
  return 1
}

run_inner_installer() {
  local installer
  installer="$(find_inner_installer)" || {
    err "No bundled installer found in repository. Expected one of:"
    err "  scripts/install_all_agents.sh"
    err "  install_chinabound_openclaw_agents.sh"
    err "  scripts/install_chinabound_openclaw_agents.sh"
    exit 1
  }

  if [[ ! -x "$installer" ]]; then
    run_cmd chmod +x "$installer"
  fi

  local -a cmd=(bash "$installer" --source "$REPO_DIR" --target "$TARGET_DIR" --config-mode "$CONFIG_MODE")
  if [[ "$INSTALL_CRON" == "1" ]]; then
    cmd+=(--install-cron)
  fi
  if [[ "$SYNC_IDENTITIES" != "1" ]]; then
    cmd+=(--no-identity-sync)
  fi
  if [[ "$FORCE" == "1" ]]; then
    cmd+=(--force)
  fi
  if [[ "$DRY_RUN" == "1" ]]; then
    cmd+=(--dry-run)
  fi

  log "Running bundled installer: $installer"
  run_cmd "${cmd[@]}"
}

print_summary() {
  echo
  echo "GitHub install summary"
  echo "----------------------"
  echo "Repository : $REPO_URL"
  echo "Target     : $TARGET_DIR"
  if [[ -n "$BRANCH" ]]; then
    echo "Branch     : $BRANCH"
  fi
  if [[ -n "$REF" ]]; then
    echo "Ref        : $REF"
  fi
  echo "Config mode: $CONFIG_MODE"
  echo
  echo "Next steps"
  echo "1. Fill $TARGET_DIR/.env with real tokens and endpoints."
  echo "2. Update deploy/config/*.example.json5 placeholders or your include files."
  echo "3. Populate shared/data/source_registry.json with approved official sources."
  echo "4. Keep channels disabled until dry run passes."
  echo "5. Validate with: OPENCLAW_CONFIG_PATH=\"$TARGET_DIR/openclaw.json\" openclaw config validate"
}

log "Installing ChinaBound OpenClaw from GitHub"
ensure_repo
checkout_ref
run_inner_installer
print_summary
