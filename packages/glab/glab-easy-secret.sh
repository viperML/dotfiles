#! /usr/bin/env bash
set -e
if [[ "$#" != "1" ]]; then
    echo "Usage: $0 [name]" 1>&2
    exit 1
fi
t="$(easy-secret "$1")"
printf '{"type": "pat", "token": "%s"}' "$t"
