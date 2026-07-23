#!/bin/sh
# planning-with-files: lock the current task_plan.md content with a SHA-256 attestation.
#
# Use after you finalise (or intentionally edit) a plan. The hooks then refuse
# to inject plan content into the model context if the file diverges from the
# attested hash, surfacing a "[PLAN TAMPERED]" warning instead.
#
# Resolution:
#   resolve-plan-dir.sh — local workflow notes directory
#
# Usage:
#   sh scripts/attest-plan.sh         # attest the active plan
#   sh scripts/attest-plan.sh --show  # print the stored hash
#   sh scripts/attest-plan.sh --clear # remove the attestation (re-open the plan)

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESOLVER="${SCRIPT_DIR}/resolve-plan-dir.sh"

resolve_plan_file() {
    plan_dir=""
    if [ -f "${RESOLVER}" ]; then
        plan_dir="$(sh "${RESOLVER}" 2>/dev/null)"
    fi
    if [ -n "${plan_dir}" ] && [ -f "${plan_dir}/task_plan.md" ]; then
        printf "%s\n" "${plan_dir}/task_plan.md"
        return 0
    fi
    return 1
}

attestation_path_for() {
    plan_file="$1"
    plan_dir="$(dirname "${plan_file}")"
    printf "%s\n" "${plan_dir}/.attestation"
}

compute_hash() {
    target="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "${target}" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "${target}" | awk '{print $1}'
    else
        printf "ERROR: no sha256 utility available\n" >&2
        return 1
    fi
}

mode="attest"
case "${1:-}" in
    --show)  mode="show"  ;;
    --clear) mode="clear" ;;
    "")      mode="attest" ;;
    *)
        printf "Usage: %s [--show|--clear]\n" "$0" >&2
        exit 2
        ;;
esac

plan_file="$(resolve_plan_file)" || {
    printf "[plan-attest] No task_plan.md found. Create a plan first.\n" >&2
    exit 1
}

attestation_file="$(attestation_path_for "${plan_file}")"

case "${mode}" in
    show)
        if [ -f "${attestation_file}" ]; then
            printf "Plan: %s\n" "${plan_file}"
            printf "Attestation: %s\n" "${attestation_file}"
            printf "SHA-256: %s\n" "$(cat "${attestation_file}")"
            # Nonce (security A1.4): if init-session generated a per-plan nonce
            # next to the attestation, surface it. Informational only here; the
            # hooks consume it to build collision-proof BEGIN/END delimiters.
            nonce_file="$(dirname "${attestation_file}")/.nonce"
            if [ -f "${nonce_file}" ]; then
                printf "Nonce: %s\n" "$(tr -d '\r\n[:space:]' < "${nonce_file}" 2>/dev/null)"
            fi
        else
            printf "[plan-attest] No attestation set for %s.\n" "${plan_file}"
            exit 1
        fi
        ;;
    clear)
        if [ -f "${attestation_file}" ]; then
            rm -f "${attestation_file}"
            printf "[plan-attest] Cleared attestation for %s.\n" "${plan_file}"
        else
            printf "[plan-attest] No attestation to clear.\n"
        fi
        ;;
    attest)
        hash_val="$(compute_hash "${plan_file}")" || exit 1

        tmp_file="${attestation_file}.tmp.$$"
        printf "%s\n" "${hash_val}" > "${tmp_file}" 2>/dev/null || {
            printf "[plan-attest] Failed to write %s\n" "${tmp_file}" >&2
            exit 1
        }
        mv_ok=1
        if command -v flock >/dev/null 2>&1; then
            # Advisory lock around the rename. lock_dir is the dir containing
            # the target file. The {} subshell pattern keeps the lock scoped to
            # the mv call.
            lock_dir="$(dirname "${attestation_file}")"
            (
                flock -w 5 9 || true
                mv -f "${tmp_file}" "${attestation_file}"
            ) 9>"${lock_dir}/.attestation.lock" 2>/dev/null || mv_ok=0
            rm -f "${lock_dir}/.attestation.lock" 2>/dev/null
        else
            mv -f "${tmp_file}" "${attestation_file}" 2>/dev/null || mv_ok=0
        fi

        # A failed atomic rename must not be
        # allowed to silently leave a stale attestation when the target already
        # existed. On mv failure we re-write the intended hash through a second
        # atomic rename (never a bare
        # redirect onto the live file, which would expose torn reads to
        # concurrent verifiers), then verify the on-disk content.
        if [ "${mv_ok}" -eq 0 ] || [ ! -f "${attestation_file}" ]; then
            fb_tmp="${attestation_file}.fb.$$"
            printf "%s\n" "${hash_val}" > "${fb_tmp}" 2>/dev/null \
                && mv -f "${fb_tmp}" "${attestation_file}" 2>/dev/null || {
                rm -f "${fb_tmp}" "${tmp_file}" 2>/dev/null
                printf "[plan-attest] Failed to write attestation %s\n" "${attestation_file}" >&2
                exit 1
            }
        fi
        rm -f "${tmp_file}" 2>/dev/null

        # Read-back verification. Both write paths above are atomic renames, so
        # a concurrent verifier always reads a complete 64-hex hash — either our
        # own or an identical one from a peer attesting the same plan content.
        # A mismatch here therefore means our intended hash genuinely did not
        # land (stale content, failed write); fail loudly with a nonzero exit so
        # callers never trust a stale attestation.
        stored_hash="$(tr -d '\r\n[:space:]' < "${attestation_file}" 2>/dev/null)"
        if [ "${stored_hash}" != "${hash_val}" ]; then
            printf "[plan-attest] Attestation write verification FAILED for %s\n" "${attestation_file}" >&2
            printf "[plan-attest] Expected %s, found %s. The plan is NOT attested.\n" "${hash_val}" "${stored_hash}" >&2
            exit 1
        fi

        short_hash="$(printf "%s" "${hash_val}" | cut -c1-12)"
        printf "[plan-attest] Locked %s\n" "${plan_file}"
        printf "[plan-attest] SHA-256: %s... (stored in %s)\n" "${short_hash}" "${attestation_file}"
        printf "[plan-attest] Hooks will block injection if the file is modified without re-running this command.\n"
        ;;
esac

exit 0
