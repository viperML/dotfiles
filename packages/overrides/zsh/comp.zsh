# zstyle ':completion:*' menu select
# zstyle ':completion:*' completer _expand _complete _match _ignored
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# # zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' list-suffixes true

# https://superuser.com/questions/1586405/zsh-autocomplete-if-only-one-suggestion
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-/]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE/compcache"
zstyle :compinstall filename "$ZSH_CACHE/compinstall"

autoload -Uz compinit
compinit

bindkey '^I' complete-word

setopt completealiases

alias ls="exa --icons"
alias la="exa --icons --all"
alias ll="exa --icons --long --header --group"
alias lla="exa --icons --all --long --header --group"
alias lal="exa --icons --all --long --header --group"
alias lt="exa --sort modified -1"

alias ip="ip -c=auto"

ealias n='nvim'
ealias pd='pushd'
ealias cdx='cd \$XDG_RUNTIME_DIR'
ealias ss='sudo systemctl'
ealias us='systemctl --user'

ealias gd='git diff'
ealias gdd='git diff | grep -v "^diff\|^index" | bat'
ealias ga='git add'
ealias gaa='git add --all .'
ealias gbd='git branch -D'
ealias gs='git status'
ealias gca='git commit -a -m'
ealias gm='git merge'
ealias gpt='git push --tags'
ealias gp='git push'
ealias grh='git reset --hard'
ealias gb='git branch'
ealias gcob='git checkout -b'
ealias gco='git checkout'
ealias gba='git branch -a'
ealias gcp='git cherry-pick'
ealias gl='git log --pretty=format:"%Cgreen%h%Creset - %Cblue%an%Creset @ %ar : %s\"'
ealias gl2='git log --pretty="format:%Cgreen%h%Creset %an - %s" --graph'
ealias glv='git log --stat'
ealias gpom='git pull origin master'
ealias gcd='cd $(git rev-parse --show-toplevel)'
ealias gcf='git clean -fd'
ealias gcod='git checkout -- .'
ealias gpum='git pull upstream master'
ealias gpod='git push origin --delete'
ealias gsu='git status -uno'
ealias gcm='git commit -m'
ealias gcv='git commit --verbose'
ealias gc='git commit --verbose'
ealias gds='git diff | sublime'
ealias grm='git reset HEAD'
ealias gacm='git add . --all; git commit --verbose'
ealias gtd='git log --tags --simplify-by-decoration --pretty="format:%ai %d\"'
ealias grs='git shortlog -s -n --all --no-merges'
ealias gss='git status --short'
ealias gr='cd $(git-root)'
