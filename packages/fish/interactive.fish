set -gx fish_greeting

# Bindings
bind \cH backward-kill-path-component
bind \e\[3\;5~ kill-word


# EXA
# alias ls="eza --icons"
# alias la="eza --icons --all"
# alias ll="eza --icons --long --header --group"
# alias lla="eza --icons --all --long --header --group"
# alias lal="eza --icons --all --long --header --group"
# alias lt="eza --sort modified -1"
abbr -a -g e eza

# Bat
alias bat="bat --theme=base16 --style=changes,header --plain"

# Abbreviations
abbr -a -g p python
abbr -a -g n nvim
abbr -a -g pd pushd
abbr -a -g cdx cd \$XDG_RUNTIME_DIR

# Admin
abbr -a -g ss sudo systemctl
abbr -a -g us systemctl --user
abbr -a -g sf journalctl -xefu
abbr -a -g uf journalctl -xef --user-unit

# Image cat
abbr -a -g wat "wezterm imgcat --height 50%"

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
    echo
end

function __fish_command_not_found_handler --on-event fish_command_not_found
    echo -e >&2 "\e[31m$argv[1]: command not found\e[0m"
end
