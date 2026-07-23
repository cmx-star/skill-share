#!/usr/bin/env bash
set -eu

slug() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//' \
    | cut -c 1-80
}

project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
project_name="$(basename "$project_root")"
project_slug="$(slug "$project_name")"
[ -n "$project_slug" ] || project_slug="project"

conversation_id="${CODEX_THREAD_ID:-${CODEX_CONVERSATION_ID:-${THREAD_ID:-}}}"
if [ -z "$conversation_id" ]; then
  conversation_id="$(date +%Y%m%d-%H%M%S)"
fi
conversation_slug="$(slug "$conversation_id")"
[ -n "$conversation_slug" ] || conversation_slug="$(date +%Y%m%d-%H%M%S)"

root="${CODEX_WORKFLOW_NOTES_ROOT:-$HOME/.codex/workflow-notes}"
dir="${CODEX_WORKFLOW_NOTES_DIR:-$root/$project_slug/$conversation_slug}"
mkdir -p "$dir"
mkdir -p "$root/$project_slug"
printf '%s\n' "$(basename "$dir")" > "$root/$project_slug/.active_conversation"

create_file() {
  file="$1"
  title="$2"
  if [ ! -f "$dir/$file" ]; then
    {
      printf '# %s\n\n' "$title"
      printf 'Project: `%s`\n\n' "$project_name"
      printf 'Conversation: `%s`\n\n' "$conversation_slug"
    } > "$dir/$file"
  fi
}

create_file task_plan.md "Task Plan"
create_file findings.md "Findings"
create_file progress.md "Progress"
create_file decision-notes.md "Decision Notes"

printf '%s\n' "$dir"
