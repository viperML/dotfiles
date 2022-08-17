# bash handler
command_not_found_handle() {
    # do not run when inside Midnight Commander or within a Pipe
    if [ -n "${MC_SID-}" ] || ! [ -t 1 ]; then
        echo -e >&2 "\e[31m$1: command not found\e[39m"
        return 127
    fi

    echo -e >&2 "\n\e[31m-> $1: command not found\e[39m\n"

    mapfile -t candidates < <("nix-locate" --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$1")

    # Remove .out suffix
    candidates=("${candidates[@]%%.out}")

    # Sort by proximity
    mapfile -t selections < <(printf "%s\n" ${candidates[@]} | fzf --filter=$1)

    if [ -z ${NIX_AUTO_RUN+x} ]; then
        result="$(nix build --no-link --print-out-paths nixpkgs#${selections[0]}.out)"
        $result/bin/$@
        return $?
    else
        # Iterate through sorted programs
        for elem in "${selections[@]}"; do
            echo >&2 "nix shell nixpkgs#$elem"
        done
        # Iterate through the rest of programs not in fzf output
        for elem in "${candidates[@]}"; do
            if [[ ! " ${selections[*]} " =~ " ${elem} " ]]; then
                echo >&2 "nix shell nixpkgs#$elem"
            fi
        done
    fi

    return 127 # command not found should always exit with 127
}

# zsh handler
command_not_found_handler() {
    # do not run when inside Midnight Commander or within a Pipe
    if [ -n "${MC_SID-}" ] || ! [ -t 1 ]; then
        echo -e >&2 "\e[31m$1: command not found\e[39m"
        return 127
    fi

    echo -e >&2 "\n\e[31m-> $1: command not found\e[39m\n"

    candidates=("${(@f)$(nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root /bin/$1)}")

    # Remove .out suffix
    candidates=("${candidates[@]%%.out}")

    # Sort by proximity
    selections=("${(@f)$(printf "%s\n" ${candidates[@]} | fzf --filter=$1)}")

    if [ -z ${NIX_AUTO_RUN+x} ]; then
        result="$(nix build --no-link --print-out-paths nixpkgs\#${selections[1]}.out)"
        $result/bin/$@
        return $?
    else
        # Iterate through sorted programs
        for elem in "${selections[@]}"; do
            echo >&2 "nix shell nixpkgs#$elem"
        done
        # Iterate through the rest of programs not in fzf output
        for elem in "${candidates[@]}"; do
            if [[ ! " ${selections[*]} " =~ " ${elem} " ]]; then
                echo >&2 "nix shell nixpkgs#$elem"
            fi
        done
    fi

    return 127 # command not found should always exit with 127
}

