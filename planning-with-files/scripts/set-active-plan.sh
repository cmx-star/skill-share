#!/bin/sh
# Set or display the active shared workflow-notes conversation for this project.

set -eu

slug() {
    printf '%s' "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//' \
        | cut -c 1-80
}

project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
project_slug="$(slug "$(basename "$project_root")")"
[ -n "$project_slug" ] || project_slug="project"

notes_root="${CODEX_WORKFLOW_NOTES_ROOT:-$HOME/.codex/workflow-notes}"
project_dir="$notes_root/$project_slug"
active_file="$project_dir/.active_conversation"

if [ "${1:-}" = "" ]; then
    if [ -f "$active_file" ]; then
        active="$(tr -d '\r\n[:space:]' < "$active_file")"
        path="$project_dir/$active"
        if [ -n "$active" ] && [ -d "$path" ]; then
            echo "Active workflow notes: $active"
            echo "Path: $path"
        else
            echo "Active workflow notes pointer is stale: $active"
        fi
    else
        echo "No active workflow notes set."
    fi
    exit 0
fi

conversation_slug="$(slug "$1")"
target="$project_dir/$conversation_slug"

if [ ! -d "$target" ]; then
    echo "Workflow notes directory not found: $target" >&2
    exit 1
fi

mkdir -p "$project_dir"
printf '%s\n' "$conversation_slug" > "$active_file"
echo "Active workflow notes set to: $conversation_slug"
echo "Path: $target"
