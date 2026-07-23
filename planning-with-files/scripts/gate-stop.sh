#!/bin/sh
# planning-with-files: Stop-hook dispatcher for the v3 completion gate.
#
# Thin wrapper: discover sibling check-complete.sh and run it with --gate,
# passing the Stop hook's stdin JSON
# through so check-complete can read stop_hook_active and apply the gate
# decision table. check-complete in --gate mode is the host-aware termination
# oracle (W1A); without .mode gate it keeps advisory behavior.
#
# Always exits with check-complete's exit code. Without a .mode file containing
# "gate", check-complete --gate never blocks.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd 2>/dev/null)" || SCRIPT_DIR="."

TARGET="${SCRIPT_DIR}/check-complete.sh"
[ -n "${TARGET:-}" ] && [ -f "$TARGET" ] || exit 0

sh "$TARGET" --gate
