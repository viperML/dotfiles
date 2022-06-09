# function os_greeter
#     echo 'Welcome to'
#     set_color cyan
#     echo (grep "PRETTY_NAME" /etc/os-release | sed 's/PRETTY_NAME=//g;s/"//g')
#     set_color normal
# end
# set -g -x fish_greeting (os_greeter)
set fish_greeting

# Bindings
bind \cH backward-kill-path-component
bind \e\[3\;5~ kill-word

# Aliases
alias ip="ip -c=auto"
alias svim="sudoedit"

# LSD
# alias ls="lsd"
# alias la="lsd -A"
# alias ll="lsd -A -l"
# alias lt="lsd -A -t -r"

# EXA
alias ls="exa --icons"
alias la="exa --icons --all"
alias ll="exa --icons --long --header --group"
alias lla="exa --icons --all --long --header --group"
alias lal="exa --icons --all --long --header --group"
alias lt="exa --sort modified -1"

# Abbreviations
abbr --add --global p python
abbr --add --global n nvim
abbr --add --global x xdg-open
abbr --add --global pd pushd
abbr --add --global cdx cd \$XDG_RUNTIME_DIR

# Admin
abbr --add --global ss sudo systemctl
abbr --add --global us systemctl --user
abbr --add --global se sudo -E systemctl edit
# abbr --add --global sf sudo --preserve-env=PATH (which fish)

# Gentoo abbreviations
abbr --add --global eq equery

# Nix abbreviations
abbr --add --global ns nix shell pkgs#
abbr --add --global nr nix run pkgs#
abbr --add --global no "sudo nixos-rebuild switch --flake \$FLAKE" -L
abbr --add --global nb "sudo nixos-rebuild boot --flake \$FLAKE" -L
abbr --add --global vl "\$FLAKE/modules/home-manager/vscode/extensions/updater.sh"

# Image cat
abbr --add --global kat "kitty +icat"
alias wat="wezterm imgcat --height 50%"

# Git abbreviations
# https://gist.github.com/james2doyle/6e8a120e31dbaa806a2f91478507314c
# tj git aliases
abbr -a gd "git diff"
abbr -a gdd "git diff | grep -v '^diff\|^index' | bat"
abbr -a ga "git add"
abbr -a gaa "git add --all ."
abbr -a gbd "git branch -D"
abbr -a gs "git status"
abbr -a gca "git commit -a -m"
abbr -a gm "git merge"
abbr -a gpt "git push --tags"
abbr -a gp "git push"
abbr -a grh "git reset --hard"
abbr -a gb "git branch"
abbr -a gcob "git checkout -b"
abbr -a gco "git checkout"
abbr -a gba "git branch -a"
abbr -a gcp "git cherry-pick"
abbr -a gl "git log --pretty=format:\"%Cgreen%h%Creset - %Cblue%an%Creset @ %ar : %s\""
abbr -a gl2 "git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
abbr -a glv "git log --stat"
abbr -a gpom "git pull origin master"
abbr -a gcd 'cd "`git rev-parse --show-toplevel`"'
# remove files that are not under version control
abbr -a gcf "git clean -fd"
# discard changes in the working directory
abbr -a gcod "git checkout -- ."
# grab the latest upstream version
abbr -a gpum "git pull upstream master"
# delete branch from github. follow with branch name
abbr -a gpod "git push origin --delete"
# show git status without untracked files
abbr -a gsu "git status -uno"
# commit -m
abbr -a gcm "git commit -m"
abbr -a gcv "git commit --verbose"
abbr -a gc "git commit --verbose"
# diff in sublime
abbr -a gds "git diff | sublime"
# remove staged file
abbr -a grm "git reset HEAD"
# add current files, commit those file
abbr -a gacm "git add . --all; git commit --verbose"
# list the git tags by date
abbr -a gtd "git log --tags --simplify-by-decoration --pretty=\"format:%ai %d\""
# list stats for the repo
abbr -a grs "git shortlog -s -n --all --no-merges"

abbr -a gss "git status --short"
abbr -a gr "cd (git-root)"

# Fix ssh passing wrong $TERM
# function ssh */
#   begin; set -lx TERM xterm-256color; command ssh $argv; end */
# end */

switch $TERM
    case 'st-*' # suckless' simple terminal
        # Enable keypad, do it once before fish_postexec ever fires
        tput smkx
        function st_smkx --on-event fish_postexec
            tput smkx
        end
        function st_rmkx --on-event fish_preexec
            tput rmkx
        end
end

set fish_color_normal brwhite
set fish_color_command green
set fish_color_keyword brblue
set fish_color_quote yellow
set fish_color_redirection brwhite
set fish_color_end brred
set fish_color_error -o red
set fish_color_param white
set fish_color_comment brblack
set fish_color_selection --background=brblack
# set fish_color_selection cyan
# set fish_color_search_match cyan
set fish_color_search_match --background=brblack
set fish_color_operator green
set fish_color_escape brblue
set fish_color_autosuggestion brblack

# Completion Pager Colors
set fish_pager_color_progress brblack
set fish_pager_color_prefix green
set fish_pager_color_completion white
set fish_pager_color_description brblack

# Configure FZF keybinds
# https://github.com/PatrickF1/fzf.fish
fzf_configure_bindings --directory=\cf

# Print newline after a command
function postexec_test --on-event fish_postexec
    echo
end

set sponge_regex_patterns '(?:\d{1,3}\.){3}\d{1,3}'

function rw
    readlink -f (which $argv)
end