#!/bin/sh
# Resolve the active local workflow notes directory.
# New local convention only:
#   ~/.codex/workflow-notes/<project-name>/<conversation-id>/

set -u

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

notes_root="${CODEX_WORKFLOW_NOTES_ROOT:-$HOME/.codex/workflow-notes}"

if [ -n "${CODEX_WORKFLOW_NOTES_DIR:-}" ] && [ -f "${CODEX_WORKFLOW_NOTES_DIR}/task_plan.md" ]; then
    printf '%s\n' "$CODEX_WORKFLOW_NOTES_DIR"
    exit 0
fi

conversation_id="${CODEX_THREAD_ID:-${CODEX_CONVERSATION_ID:-${THREAD_ID:-}}}"
if [ -n "$conversation_id" ]; then
    conversation_slug="$(slug "$conversation_id")"
    candidate="$notes_root/$project_slug/$conversation_slug"
    if [ -f "$candidate/task_plan.md" ]; then
        printf '%s\n' "$candidate"
    fi
    # A known conversation must never inherit another conversation's notes.
    exit 0
fi

active_file="$notes_root/$project_slug/.active_conversation"
if [ -f "$active_file" ]; then
    active_slug="$(tr -d '\r\n[:space:]' < "$active_file" 2>/dev/null)"
    candidate="$notes_root/$project_slug/$active_slug"
    if [ -n "$active_slug" ] && [ -f "$candidate/task_plan.md" ]; then
        printf '%s\n' "$candidate"
        exit 0
    fi
fi

latest=""
latest_mtime=0
if [ -d "$notes_root/$project_slug" ]; then
    for entry in "$notes_root/$project_slug"/*/; do
        [ -d "$entry" ] || continue
        [ -f "${entry%/}/task_plan.md" ] || continue
        mtime="$(stat -f '%m' "${entry%/}" 2>/dev/null || stat -c '%Y' "${entry%/}" 2>/dev/null || echo 0)"
        if [ "$mtime" -gt "$latest_mtime" ] 2>/dev/null; then
            latest_mtime="$mtime"
            latest="${entry%/}"
        fi
    done
fi

[ -n "$latest" ] && printf '%s\n' "$latest"
exit 0
