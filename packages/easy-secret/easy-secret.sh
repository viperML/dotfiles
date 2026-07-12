#! /usr/bin/env bash
set -uo pipefail

usage() {
    echo "Usage: $0 [name]"
}

if [[ "$#" != "1" ]]; then
    usage
    exit 1
    fi

declare -a kv
kv+=("server" "easy-secret")
kv+=("type" "plaintext")
kv+=("xdg:schema" "org.qt.keychain")

kv+=("user" "$1")

value="$(secret-tool lookup "${kv[@]}")"
_exit="$?"
if [[ "$_exit" != 0 ]]; then
    secret-tool store --label "easy-secret/$0" "${kv[@]}"
else
    printf "%s" "$value"
fi
