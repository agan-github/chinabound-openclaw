#!/usr/bin/env bash
set -euo pipefail

# ChinaBound OpenClaw full installer
# - assumes source repo already exists locally
# - copies each source agent workspace into ~/.openclaw/workspace-<agent-id>
# - creates ~/.openclaw/agents/<agent-id>/agent state dirs
# - merges only supported/sanitized fields into ~/.openclaw/openclaw.json
# - does NOT overwrite openclaw.json wholesale

SCRIPT_NAME="$(basename "$0")"
HOME_DIR="${HOME:-/root}"
OPENCLAW_HOME_DEFAULT="${HOME_DIR}/.openclaw"
SOURCE_DEFAULT="${OPENCLAW_HOME_DEFAULT}/chinabound-openclaw"

SOURCE_ROOT="${SOURCE_DEFAULT}"
OPENCLAW_HOME="${OPENCLAW_HOME_DEFAULT}"
INSTALL_CRON="0"
SYNC_IDENTITIES="1"
VALIDATE_CONFIG="1"
FORCE_COPY="0"
DRY_RUN="0"
MERGE_CHANNELS="1"
MERGE_BINDINGS="1"
MERGE_TOOLS="1"
MERGE_SKILLS="1"
QUIET="0"

log() { if [[ "$QUIET" != "1" ]]; then printf '[INFO] %s\n' "$*"; fi; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
err() { printf '[ERROR] %s\n' "$*" >&2; }

usage() {
  cat <<'EOF'
ChinaBound OpenClaw full installer

Usage:
  install.sh [options]

Options:
  --source <dir>          Source project root. Default: ~/.openclaw/chinabound-openclaw
  --openclaw-home <dir>   OpenClaw home. Default: ~/.openclaw
  --install-cron          Run deploy/cron/install_all.sh if present
  --no-identity-sync      Skip: openclaw agents set-identity --from-identity
  --no-validate           Skip: openclaw config validate
  --no-merge-channels     Do not merge source channels into target openclaw.json
  --no-merge-bindings     Do not merge source bindings into target openclaw.json
  --no-merge-tools        Do not merge root tools from source openclaw.json
  --no-merge-skills       Do not merge root skills from source openclaw.json
  --force-copy            Use rsync --delete when syncing workspaces
  --dry-run               Print actions but do not change files
  --quiet                 Reduce logs
  -h, --help              Show this help

What this script does:
  1) Detects source agents under <source>/agents/*
  2) Copies each source agent to ~/.openclaw/workspace-<agent-id>
  3) Creates ~/.openclaw/agents/<agent-id>/agent
  4) Backs up ~/.openclaw/openclaw.json
  5) Merges sanitized settings from source openclaw.json into target openclaw.json
  6) Optionally validates config, syncs identities, installs cron

Important:
  - This script never overwrites ~/.openclaw/openclaw.json wholesale.
  - Unsupported source keys such as root identity, agents.defaults.tools,
    and agents.defaults.skills are ignored during merge.
EOF
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[DRYRUN]'
    for a in "$@"; do printf ' %q' "$a"; done
    printf '\n'
  else
    "$@"
  fi
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Required command not found: $1"; exit 1; }
}

abspath() {
  python3 - "$1" <<'PY'
import os, sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE_ROOT="$2"; shift 2 ;;
    --openclaw-home) OPENCLAW_HOME="$2"; shift 2 ;;
    --install-cron) INSTALL_CRON="1"; shift ;;
    --no-identity-sync) SYNC_IDENTITIES="0"; shift ;;
    --no-validate) VALIDATE_CONFIG="0"; shift ;;
    --no-merge-channels) MERGE_CHANNELS="0"; shift ;;
    --no-merge-bindings) MERGE_BINDINGS="0"; shift ;;
    --no-merge-tools) MERGE_TOOLS="0"; shift ;;
    --no-merge-skills) MERGE_SKILLS="0"; shift ;;
    --force-copy) FORCE_COPY="1"; shift ;;
    --dry-run) DRY_RUN="1"; shift ;;
    --quiet) QUIET="1"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) err "Unknown option: $1"; usage; exit 2 ;;
  esac
done

need_cmd python3

SOURCE_ROOT="$(abspath "$SOURCE_ROOT")"
OPENCLAW_HOME="$(abspath "$OPENCLAW_HOME")"
TARGET_CONFIG="${OPENCLAW_HOME}/openclaw.json"
SOURCE_CONFIG="${SOURCE_ROOT}/openclaw.json"
AGENTS_SOURCE_DIR="${SOURCE_ROOT}/agents"
AGENT_STATE_ROOT="${OPENCLAW_HOME}/agents"
BACKUP_DIR="${OPENCLAW_HOME}/backups"

log "Source root      : ${SOURCE_ROOT}"
log "OpenClaw home    : ${OPENCLAW_HOME}"
log "Target config    : ${TARGET_CONFIG}"

[[ -d "$SOURCE_ROOT" ]] || { err "Source root not found: $SOURCE_ROOT"; exit 1; }
[[ -d "$AGENTS_SOURCE_DIR" ]] || { err "Source agents dir not found: $AGENTS_SOURCE_DIR"; exit 1; }
[[ -f "$SOURCE_CONFIG" ]] || { warn "Source openclaw.json not found: $SOURCE_CONFIG"; }

run mkdir -p "$OPENCLAW_HOME" "$AGENT_STATE_ROOT" "$BACKUP_DIR"

# Discover agents from source directory names.
mapfile -t AGENT_IDS < <(
  find "$AGENTS_SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
)

if [[ "${#AGENT_IDS[@]}" -eq 0 ]]; then
  err "No agents found under: $AGENTS_SOURCE_DIR"
  exit 1
fi

log "Detected ${#AGENT_IDS[@]} source agent directories"

sync_dir() {
  local src="$1"
  local dst="$2"
  run mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    if [[ "$FORCE_COPY" == "1" ]]; then
      run rsync -a --delete "$src/" "$dst/"
    else
      run rsync -a "$src/" "$dst/"
    fi
  else
    if [[ "$FORCE_COPY" == "1" ]]; then
      warn "rsync not found; --force-copy delete behavior not available, falling back to cp -R"
    fi
    run cp -R "$src/." "$dst/"
  fi
}

# Copy each source agent into its own workspace, and create per-agent state directory.
for agent_id in "${AGENT_IDS[@]}"; do
  src_ws="${AGENTS_SOURCE_DIR}/${agent_id}"
  dst_ws="${OPENCLAW_HOME}/workspace-${agent_id}"
  dst_state="${AGENT_STATE_ROOT}/${agent_id}/agent"

  log "Sync workspace: ${agent_id}"
  sync_dir "$src_ws" "$dst_ws"
  run mkdir -p "$dst_state"
done

# Optional: ensure shared directories exist if present in source.
for maybe_dir in "shared" "shared-skills" "deploy" ".env.example"; do
  if [[ -e "${SOURCE_ROOT}/${maybe_dir}" ]]; then
    log "Source contains ${maybe_dir} at ${SOURCE_ROOT}/${maybe_dir}"
  fi
done

if [[ -f "$TARGET_CONFIG" ]]; then
  ts="$(date +%Y%m%d-%H%M%S)"
  backup="${BACKUP_DIR}/openclaw.json.${ts}.bak"
  log "Backing up existing config -> ${backup}"
  run cp "$TARGET_CONFIG" "$backup"
fi

# Persist detected agents to a temp file for the embedded Python merger.
TMP_AGENTS="$(mktemp)"
TMP_FLAGS="$(mktemp)"
printf '%s\n' "${AGENT_IDS[@]}" > "$TMP_AGENTS"
cat > "$TMP_FLAGS" <<EOF
SOURCE_ROOT=${SOURCE_ROOT}
OPENCLAW_HOME=${OPENCLAW_HOME}
SOURCE_CONFIG=${SOURCE_CONFIG}
TARGET_CONFIG=${TARGET_CONFIG}
MERGE_CHANNELS=${MERGE_CHANNELS}
MERGE_BINDINGS=${MERGE_BINDINGS}
MERGE_TOOLS=${MERGE_TOOLS}
MERGE_SKILLS=${MERGE_SKILLS}
EOF

merge_config() {
python3 - "$TMP_AGENTS" "$TMP_FLAGS" <<'PY'
import json, os, sys, pathlib, copy

agents_file = pathlib.Path(sys.argv[1])
flags_file = pathlib.Path(sys.argv[2])

flags = {}
for line in flags_file.read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    k, v = line.split("=", 1)
    flags[k] = v

source_root = flags["SOURCE_ROOT"]
openclaw_home = flags["OPENCLAW_HOME"]
source_config_path = pathlib.Path(flags["SOURCE_CONFIG"])
target_config_path = pathlib.Path(flags["TARGET_CONFIG"])

merge_channels = flags["MERGE_CHANNELS"] == "1"
merge_bindings = flags["MERGE_BINDINGS"] == "1"
merge_tools = flags["MERGE_TOOLS"] == "1"
merge_skills = flags["MERGE_SKILLS"] == "1"

agent_ids = [line.strip() for line in agents_file.read_text(encoding="utf-8").splitlines() if line.strip()]

def load_json(path: pathlib.Path):
    if not path.exists():
        return {}
    text = path.read_text(encoding="utf-8").strip()
    if not text:
        return {}
    return json.loads(text)

src = load_json(source_config_path)
dst = load_json(target_config_path)

if not isinstance(dst, dict):
    dst = {}
if not isinstance(src, dict):
    src = {}

# Initialize root structures in target.
dst.setdefault("agents", {})
if not isinstance(dst["agents"], dict):
    dst["agents"] = {}
dst["agents"].setdefault("list", [])
if not isinstance(dst["agents"]["list"], list):
    dst["agents"]["list"] = []

dst_agents_by_id = {}
for item in dst["agents"]["list"]:
    if isinstance(item, dict) and item.get("id"):
        dst_agents_by_id[item["id"]] = item

src_agents_by_id = {}
src_agents_list = (((src.get("agents") or {}).get("list")) or [])
if isinstance(src_agents_list, list):
    for item in src_agents_list:
        if isinstance(item, dict) and item.get("id"):
            src_agents_by_id[item["id"]] = item

def sanitize_agent(src_agent: dict, agent_id: str):
    out = {}
    out["id"] = agent_id
    out["name"] = src_agent.get("name", agent_id)
    out["workspace"] = f"{openclaw_home}/workspace-{agent_id}"
    out["agentDir"] = f"{openclaw_home}/agents/{agent_id}/agent"

    if agent_id == "chief-orchestrator":
        out["default"] = True

    # Optional carry-over fields that are valid at per-agent scope.
    for key in ("identity", "tools", "model", "modelName", "toolProfile", "description"):
        if key in src_agent:
            out[key] = copy.deepcopy(src_agent[key])

    # If source has unsupported garbage, intentionally ignore it.
    return out

# Upsert managed agents.
managed_ids = set(agent_ids)
for agent_id in agent_ids:
    src_agent = src_agents_by_id.get(agent_id, {})
    merged = sanitize_agent(src_agent, agent_id)
    if agent_id in dst_agents_by_id:
        existing = dst_agents_by_id[agent_id]
        # Preserve unrelated keys already in target, but override managed keys.
        existing.update(merged)
    else:
        dst["agents"]["list"].append(merged)
        dst_agents_by_id[agent_id] = merged

# Merge root tools from source if requested.
if merge_tools and isinstance(src.get("tools"), dict):
    if not isinstance(dst.get("tools"), dict):
      dst["tools"] = {}
    dst["tools"].update(copy.deepcopy(src["tools"]))
else:
    dst.setdefault("tools", {"profile": "coding"})

# Merge root skills.load.extraDirs from source plus project shared-skills.
if merge_skills:
    if not isinstance(dst.get("skills"), dict):
        dst["skills"] = {}
    dst["skills"].setdefault("load", {})
    if not isinstance(dst["skills"]["load"], dict):
        dst["skills"]["load"] = {}
    extra = dst["skills"]["load"].get("extraDirs") or []
    if not isinstance(extra, list):
        extra = []
    src_extra = (((src.get("skills") or {}).get("load") or {}).get("extraDirs")) or []
    if isinstance(src_extra, list):
        extra.extend([x for x in src_extra if isinstance(x, str)])
    project_shared = f"{source_root}/shared-skills"
    if os.path.isdir(project_shared):
        extra.append(project_shared)
    # de-duplicate while preserving order
    seen = set()
    clean = []
    for item in extra:
        if item not in seen:
            seen.add(item)
            clean.append(item)
    dst["skills"]["load"]["extraDirs"] = clean

# Merge channels and bindings carefully if requested.
if merge_channels and isinstance(src.get("channels"), dict):
    if not isinstance(dst.get("channels"), dict):
        dst["channels"] = {}
    for channel_name, channel_cfg in src["channels"].items():
        if isinstance(channel_cfg, dict):
            dst["channels"][channel_name] = copy.deepcopy(channel_cfg)

if merge_bindings and isinstance(src.get("bindings"), list):
    existing = dst.get("bindings")
    if not isinstance(existing, list):
        existing = []
    # keep non-managed bindings; replace ones that route to managed agents
    filtered = []
    for item in existing:
        if not isinstance(item, dict):
            continue
        agent_id = item.get("agentId")
        if agent_id in managed_ids:
            continue
        filtered.append(item)
    for item in src["bindings"]:
        if isinstance(item, dict):
            filtered.append(copy.deepcopy(item))
    dst["bindings"] = filtered

# Remove known-invalid legacy keys if present.
dst.pop("identity", None)
agents_defaults = ((dst.get("agents") or {}).get("defaults"))
if isinstance(agents_defaults, dict):
    agents_defaults.pop("tools", None)
    agents_defaults.pop("skills", None)

# If target config does not exist, create parent dir.
target_config_path.parent.mkdir(parents=True, exist_ok=True)
target_config_path.write_text(json.dumps(dst, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

summary = {
    "managedAgents": agent_ids,
    "targetConfig": str(target_config_path),
    "sharedSkillsConfigured": os.path.isdir(f"{source_root}/shared-skills"),
    "channelsMerged": merge_channels and isinstance(src.get("channels"), dict),
    "bindingsMerged": merge_bindings and isinstance(src.get("bindings"), list),
}
print(json.dumps(summary, ensure_ascii=False))
PY
}

if [[ "$DRY_RUN" == "1" ]]; then
  log "Would merge sanitized config into ${TARGET_CONFIG}"
else
  summary_json="$(merge_config)"
  log "Config merge summary: ${summary_json}"
fi

rm -f "$TMP_AGENTS" "$TMP_FLAGS"

if command -v openclaw >/dev/null 2>&1; then
  if [[ "$VALIDATE_CONFIG" == "1" ]]; then
    log "Validating OpenClaw config"
    if ! run openclaw config validate; then
      warn "openclaw config validate reported issues"
    fi
  fi

  if [[ "$SYNC_IDENTITIES" == "1" ]]; then
    log "Syncing identities from workspace IDENTITY.md files"
    if ! run openclaw agents set-identity --from-identity; then
      warn "openclaw agents set-identity --from-identity failed or is unsupported in this version"
    fi
  fi

  if [[ "$INSTALL_CRON" == "1" ]]; then
    CRON_INSTALLER="${SOURCE_ROOT}/deploy/cron/install_all.sh"
    if [[ -x "$CRON_INSTALLER" || -f "$CRON_INSTALLER" ]]; then
      log "Installing bundled cron jobs"
      run bash "$CRON_INSTALLER" || warn "Bundled cron install failed"
    else
      warn "Cron installer not found: ${CRON_INSTALLER}"
    fi
  fi
else
  warn "openclaw CLI not found; skipped validate / identity sync / cron"
fi

cat <<EOF

Install complete.

Source project:
  ${SOURCE_ROOT}

Managed agents copied to:
  ${OPENCLAW_HOME}/workspace-<agent-id>

Per-agent state dirs:
  ${OPENCLAW_HOME}/agents/<agent-id>/agent

Updated config:
  ${TARGET_CONFIG}

Next checks:
  1) Review ${TARGET_CONFIG}
  2) Fill any channel tokens / CMS / approval config you still need
  3) Run: openclaw config validate
  4) Run: openclaw agents set-identity --from-identity
  5) Keep external channels disabled until dry run passes
EOF
