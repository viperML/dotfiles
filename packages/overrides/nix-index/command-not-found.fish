function __fish_command_not_found_handler --on-event fish_command_not_found
    echo -e >&2 "\n\e[31m-> $argv[1]: command not found\e[39m\n"
    # mapfile -t candidates < <("nix-locate" --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$1")
    nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$argv[1]" | read --list --line candidates

    echo $candidates
end
