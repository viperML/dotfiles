starship init fish | source

function os_greeter
    echo 'Welcome to'
    set_color cyan
    echo (grep "PRETTY_NAME" /etc/os-release | sed 's/PRETTY_NAME=//g;s/"//g')
    set_color normal
    echo 'powered by'
    set_color brcyan
    echo ' Nix'
    set_color normal
end

set -g -x fish_greeting (os_greeter)

# Bindings
bind \cH backward-kill-path-component
bind \e\[3\;5~ kill-word

# Variables
# export GREP_OPTIONS='--color=always'
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Aliases
alias ip="ip -c=auto"
alias svim="sudoedit"
alias cpuinfo="watch -n.1 'cat /proc/cpuinfo | grep \'^[c]pu MHz\''"

# LSD
alias ls="lsd"
alias la="lsd -A"
alias ll="lsd -A -l"
alias lt="lsd -A -t -r"

# Abbreviations
abbr --add --global p python
abbr --add --global n nvim
abbr --add --global netboot docker run --net=host pixiecore/pixiecore:master quick xyz --dhcp-no-bind
abbr --add --global ns nix-shell --run fish --packages
abbr --add --global x xdg-open
abbr --add --global nf nix --option experimental-features \"nix-command flakes\"

# Admin
abbr --add --global s sudo
abbr --add --global ss sudo systemctl
abbr --add --global us systemctl --user
abbr --add --global se sudo -E systemctl edit
abbr --add --global sf sudo --preserve-env=PATH (which fish)

# Gentoo abbreviations
abbr --add --global eq equery
abbr --add --global nuse sudo nvim /etc/portage/package.use/my-use
abbr --add --global nacc sudo nvim /etc/portage/package.accept_keywords

# Git abbreviations
# https://gist.github.com/james2doyle/6e8a120e31dbaa806a2f91478507314c
# tj git aliases
abbr -a gd "git diff -M"
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

# Fix ssh passing wrong $TERM
function ssh
  begin; set -lx TERM xterm-256color; command ssh $argv; end
end

function dotinstall
  $DOTDIR/dotbot.sh -c $DOTDIR/install-linux.yaml
  $PRIVDIR/dotbot.sh -c $PRIVDIR/install-linux.yaml
end

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

# After resetting fish, set again each color for each component
function set_colorscheme
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
end


# Configure FZF keybinds
# https://github.com/PatrickF1/fzf.fish
fzf_configure_bindings --directory=\cf
