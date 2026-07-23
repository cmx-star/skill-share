#!/bin/sh
# Local wrapper kept for muscle memory. It initializes the shared Codex
# workflow-notes directory; it never writes planning files into the project.

set -eu

MODE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --gated)
            MODE="gate"
            shift
            ;;
        --autonomous)
            MODE="autonomous"
            shift
            ;;
        --template|-t)
            # Old template selection is intentionally ignored locally.
            shift
            [ $# -gt 0 ] && shift
            ;;
        --plan-dir)
            # Old project-local plan-dir mode is intentionally ignored locally.
            shift
            ;;
        *)
            shift
            ;;
    esac
done

INIT="/Users/cmx/.codex/skills/local-evidence-flow/scripts/init-workflow-notes.sh"
[ -f "$INIT" ] || {
    echo "[planning-with-files] Missing init script: $INIT" >&2
    exit 1
}

dir="$(sh "$INIT")"

if [ -n "$MODE" ]; then
    printf '%s\n' "$MODE" > "$dir/.mode"
fi

echo "$dir"
