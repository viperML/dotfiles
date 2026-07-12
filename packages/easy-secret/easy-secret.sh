#! /usr/bin/env bash
set -uo pipefail

if [[ "$#" != "1" ]]; then
    echo "Usage: $0 [name]" 1>&2
    exit 1
fi

name="$1"

if [[ "$name" != "$(printf "%q" "$name")" ]]; then
    echo "Bad name: $name" 1>&2
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
        echo "Secret is unset, but stdin is not a TTY!" 1>&2
        exit 1
    fi

    secret-tool store --label "easy-secret/$name" "${kv[@]}"
fi

lookup
_exit="$?"
exit "$_exit"
