#!/usr/bin/env bash

set -e

CONFIG_FILE="internal-submodules.json"
LOG_DIR="$(pwd)/logs"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/sync-$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

# === Clean logging
timestamp() {
  date +"[%H:%M:%S]"
}
log() {
  echo -e "$(timestamp) $1" | tee -a "$LOG_FILE"
}

# === Load config
if [[ ! -f "$CONFIG_FILE" ]]; then
  log "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

main_repo=$(jq -r '.main_repo_name' "$CONFIG_FILE")
submodules=($(jq -r '.submodules[].name' "$CONFIG_FILE" | tr -d '\r'))

# === Commit and push helper
commit_and_push() {
  local path=$1
  local label=$2

  pushd "$path" > /dev/null

  if [[ -n $(git status --porcelain) ]]; then
    log "📦 Committing changes in $label"
    git add .
    git commit -m "Auto-commit from sync script"
  else
    log "✅ No changes in $label"
  fi

  current_branch=$(git symbolic-ref --short HEAD)
  if git push origin "$current_branch"; then
    log "🚀 Pushed $label on $current_branch"
  else
    log "❌ Push failed for $label on $current_branch"
  fi

  popd > /dev/null
}

# === Start sync
log "📁 Using current directory as main repo: $(pwd)"

# Step 1: Submodules
log "🔁 Syncing submodules..."
for module in "${submodules[@]}"; do
  if [[ -d "$module" ]]; then
    log "🔸 Submodule: $module"
    # ✅ Stage the pointer in the parent repo
    commit_and_push "$module" "$module"
    git add "$module"
    log "🧷 Staged submodule pointer update for $module in parent repo"
  else
    log "⚠️  Submodule folder not found: $module"
  fi
done

# Step 2: Parent repo
log "📁 Syncing parent repo: $main_repo"
commit_and_push "." "main repo"

popd > /dev/null

log "✅ Sync complete — log saved to $LOG_FILE"
