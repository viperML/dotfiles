function __fish_command_not_found_handler --on-event fish_command_not_found
    echo -e >&2 "\n\e[31m-> $argv[1]: command not found\e[39m\n"

    set candidates (
        nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$argv[1]" \
        | string replace ".out" ""
    )

    set selections (printf "%s\n" $candidates | fzf --filter="$argv[1]")

    if set -q NIX_AUTO_RUN
        set result (nix build --no-link --print-out-paths nixpkgs\#$selections[1])
        $result/bin/$argv
        return 127
    else
        for item in $selections
            echo "nix shell nixpkgs#$item"
        end
        for item in $candidates
            if not contains $item $selections
                echo "nix shell nixpkgs#$item"
            end
        end
    end
end
