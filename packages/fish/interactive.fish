set -gx fish_greeting

# Bindings
bind \cH backward-kill-path-component
bind \e\[3\;5~ kill-word

# Aliases
alias ip="ip -c=auto"

# EXA
alias ls="eza --icons"
alias la="eza --icons --all"
alias ll="eza --icons --long --header --group"
alias lla="eza --icons --all --long --header --group"
alias lal="eza --icons --all --long --header --group"
alias lt="eza --sort modified -1"

# Bat
alias bat="bat --theme=base16 --style=changes,header --plain"

# Abbreviations
abbr -a -g p python
abbr -a -g n nvim
abbr -a -g pd pushd
abbr -a -g cdx cd \$XDG_RUNTIME_DIR
abbr -a -g z zellij attach -c main

# Admin
abbr -a -g ss sudo systemctl
abbr -a -g us systemctl --user
abbr -a -g sf journalctl -xefu
abbr -a -g uf journalctl -xef --user-unit

# Image cat
abbr -a -g kat "kitty +icat"
abbr -a -g wat "wezterm imgcat --height 50%"

# Git abbreviations
# https://gist.github.com/james2doyle/6e8a120e31dbaa806a2f91478507314c
abbr -a -g gd "git diff"
abbr -a -g gdd "git diff | grep -v '^diff\|^index' | bat"
abbr -a -g ga "git add"
abbr -a -g gaa "git add --all ."
abbr -a -g gbd "git branch -D"
abbr -a -g gs "git status"
abbr -a -g gca "git commit -a -m"
abbr -a -g gm "git merge"
abbr -a -g gpt "git push --tags"
abbr -a -g gp "git push"
abbr -a -g grh "git reset --hard"
abbr -a -g gb "git branch"
abbr -a -g gcob "git checkout -b"
abbr -a -g gco "git checkout"
abbr -a -g gba "git branch -a"
abbr -a -g gcp "git cherry-pick"
abbr -a -g gl "git log --pretty=format:\"%Cgreen%h%Creset - %Cblue%an%Creset @ %ar : %s\""
abbr -a -g gl2 "git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
abbr -a -g glv "git log --stat"
abbr -a -g gpom "git pull origin master"
abbr -a -g gcd 'cd "`git rev-parse --show-toplevel`"'
abbr -a -g gcf "git clean -fd"
abbr -a -g gcod "git checkout -- ."
abbr -a -g gpum "git pull upstream master"
abbr -a -g gpod "git push origin --delete"
abbr -a -g gsu "git status -uno"
abbr -a -g gcm "git commit -m"
abbr -a -g gcv "git commit --verbose"
abbr -a -g gc "git commit --verbose"
abbr -a -g gds "git diff | sublime"
abbr -a -g grm "git reset HEAD"
abbr -a -g gacm "git add . --all; git commit --verbose"
abbr -a -g gtd "git log --tags --simplify-by-decoration --pretty=\"format:%ai %d\""
abbr -a -g grs "git shortlog -s -n --all --no-merges"
abbr -a -g gss "git status --short"
abbr -a -g gr "cd (git-root)"

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
