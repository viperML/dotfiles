#! /usr/bin/env bash
# Evict all owner-hierarchy persistent handles created by tpm2_ptool
# (range 0x81000000-0x817FFFFF), leaving firmware/EK handles intact.
set -ue

dry_run=0

for arg in "$@"; do
    case "$arg" in
        --dry-run|-n) dry_run=1 ;;
        --help|-h)
            echo "Usage: $0 [--dry-run]"
            echo "  Evicts owner-hierarchy TPM handles (0x81000000-0x817FFFFF)"
            echo "  typically left behind by failed tpm2_ptool init runs."
            echo ""
            echo "  --dry-run  Show what would be evicted without evicting"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 1
            ;;
    esac
done

mapfile -t handles < <(tpm2_getcap handles-persistent 2>/dev/null | awk '/^- / { print $2 }')

if [ "${#handles[@]}" -eq 0 ]; then
    echo "No persistent handles found."
    exit 0
fi

evicted=0

for h in "${handles[@]}"; do
    # Convert to decimal for comparison
    dec=$(printf '%d' "$h")
    lo=$(printf '%d' 0x81000000)
    hi=$(printf '%d' 0x817FFFFF)

    if [ "$dec" -ge "$lo" ] && [ "$dec" -le "$hi" ]; then
        if [ "$dry_run" -eq 1 ]; then
            echo "[dry-run] would evict $h"
        else
            echo "Evicting $h ..."
            tpm2_evictcontrol -c "$h"
        fi
        evicted=$((evicted + 1))
    else
        echo "Skipping $h (outside owner-hierarchy range)"
    fi
done

if [ "$dry_run" -eq 1 ]; then
    echo "Dry run complete. $evicted handle(s) would be evicted."
else
    echo "Done. $evicted handle(s) evicted."
fi
