set -gx fish_greeting

# Use this function to get keys
# fish_key_reader

# Bindings
bind \b backward-kill-word
bind \e\x7F backward-delete-char

bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word


bind \e\[1\;5A history-token-search-backward
bind \e\[1\;5B history-token-search-forward


# Abbrs
abbr -a -g e eza
abbr -a -g p python3
abbr -a -g n nvim
abbr -a -g y yazi

# Admin
abbr -a -g ss sudo systemctl
abbr -a -g us systemctl --user
abbr -a -g sf journalctl -xefu
abbr -a -g uf journalctl -xef --user-unit

# Image cat
# abbr -a -g wat "wezterm imgcat --height 50%"

set self (builtin realpath /proc/self/exe)

# Git abbreviations
# https://gist.github.com/james2doyle/6e8a120e31dbaa806a2f91478507314c
abbr -a -g gd "git difftool"
abbr -a -g ga "git add"
abbr -a -g gs "git status"
abbr -a -g gm "git merge"
abbr -a -g gp "git push"
abbr -a -g gl "git logs"
abbr -a -g glt "git logtags"
abbr -a -g gr "cd (git-root)"
abbr -a -g gcm "git commit -m"

set -gx fish_color_normal brwhite
set -gx fish_color_command green
set -gx fish_color_keyword brblue
set -gx fish_color_quote yellow
set -gx fish_color_redirection brwhite
set -gx fish_color_end brred
set -gx fish_color_error -o red
set -gx fish_color_param white
set -gx fish_color_comment brblack
set -gx fish_color_selection --background=brblack
# set -gx fish_color_selection cyan
# set -gx fish_color_search_match cyan
set -gx fish_color_search_match --background=brblack
set -gx fish_color_operator green
set -gx fish_color_escape brblue
set -gx fish_color_autosuggestion brblack
set -gx fish_pager_color_progress brblack
set -gx fish_pager_color_prefix green
set -gx fish_pager_color_completion white
set -gx fish_pager_color_description brblack

# Configure FZF keybinds
# https://github.com/PatrickF1/fzf.fish
fzf_configure_bindings --directory=\cf

# Print newline after a command
function postexec_test --on-event fish_postexec
    echo -e '\e[5 q\e[?12h'
end

function __fish_command_not_found_handler --on-event fish_command_not_found
    echo -e >&2 "\e[31m$argv[1]: command not found\e[0m"
end

function ,
    if test (count $argv) -lt 1
        echo "Usage: , <name>"
        return
    end
    nix-locate --top-level --at-root -w /bin/$argv[1]
end

function yazi
	set tmp (mktemp -t -p "$XDG_RUNTIME_DIR" "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
