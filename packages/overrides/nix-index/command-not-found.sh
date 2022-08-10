#!/usr/bin/env bash

# mod of https://github.com/bennofs/nix-index/blob/master/command-not-found.sh

command_not_found_handle () {
    # - do not run when inside Midnight Commander or within a Pipe
    if [ -n "${MC_SID-}" ] || ! [ -t 1 ]; then
        >&2 echo "$1: command not found"
        return 127
    fi

    mapfile -t candidates < <(nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$1")
    candidates=("${candidates[@]%%.out}")

    >&2 printf "%s\n" "command not found: $1" ""

    if [ -n "${NIX_AUTO_RUN}" ]; then
        mapfile -t selections < <(printf "%s\n" ${candidates[@]} | fzf --filter=$1)
        result="$(nix build --no-link --print-out-paths nixpkgs#${selections[0]}.out)"
        $result/bin/$@
        return $?
    else
        mapfile -t candidates_sorted < <(printf "%s\n" ${candidates[@]} | fzf --filter $1)
        for elem in "${candidates_sorted[@]}"; do
            >&2 echo "nix shell nixpkgs#$elem"
        done
    fi

    return 127 # command not found should always exit with 127
}

# zsh handler
command_not_found_handler () {
    command_not_found_handle $@
    return $?
}
