#! /usr/bin/env bash
set -uo pipefail

log() {
  printf "easy-secret: %s\n" "$*" >&2
}

if [[ "$#" != "1" ]]; then
    echo "Usage: $0 [name]" 1>&2
    exit 1
fi

name="$1"

if [[ "$name" != "$(printf "%q" "$name")" ]]; then
    log bad name: "$name"
    exit 1
fi

declare -a kv
kv+=("user" "$name")
kv+=("server" "easy-secret")
kv+=("type" "plaintext")
kv+=("xdg:schema" "org.qt.keychain")

lookup() {
    secret-tool lookup "${kv[@]}"
}

lookup 2>/dev/null 1>/dev/null
_exit="$?"

if [[ "$_exit" != 0 ]]; then
    if [[ ! -t 1 ]]; then
        log secret \""$name"\" unset: stdin is not a tty
        exit 1
    fi

    secret-tool store --label "easy-secret/$name" "${kv[@]}"
fi

lookup
_exit="$?"
exit "$_exit"
